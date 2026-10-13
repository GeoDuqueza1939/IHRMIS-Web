#!/usr/bin/env node
"use strict";
// tools/seed-janus.mjs — idempotent seeder for JANUS auth reference data.
// (lives at src/tools/seed-janus.mjs so `mysql2` resolves from src/node_modules).
//
// Seeds (source of truth = table COMMENTs in .docsanddesign/DB-ERD.mwb):
//   ENUM_User_Status (0-3), ENUM_OAuth_Provider (0-3), ENUM_User_Type (0-2),
//   Role (JOB_APPLICANT default, EXTERNAL_USER, REGULAR_EMPLOYEE, HRMO, SYSTEM_ADMIN),
//   Right (rights.assign, roles.assign, users.manage, users.link.approve),
//   Role_Right (SYSTEM_ADMIN + HRMO get all four; applicant roles get none yet).
//
// Connection mirrors src/modules/config.mjs mysql block (env-driven):
//   IHRMIS_MYSQL_HOST / PORT / USER / PASSWORD / DATABASE
// Usage (from src/):
//   node tools/seed-janus.mjs [--dry-run]
// Exit non-zero on failure so CI/deploy can gate on it.

import mysql from 'mysql2/promise';

const DRY_RUN = process.argv.includes('--dry-run');

const dbConfig = {
    host: process.env.IHRMIS_MYSQL_HOST || 'localhost',
    port: Number(process.env.IHRMIS_MYSQL_PORT) || 3306,
    user: process.env.IHRMIS_MYSQL_USER,
    password: process.env.IHRMIS_MYSQL_PASSWORD,
    database: process.env.IHRMIS_MYSQL_DATABASE || 'ihrmis',
};

const ENUM_SEEDS = {
    ENUM_User_Status: {
        key: 'status',
        rows: [
            [0, 'Not specified', 'Unspecified status'],
            [1, 'Active', 'Active user'],
            [2, 'Inactive', 'Inactive user'],
            [3, 'Separated', 'Separated employee; keeps record, loses access'],
        ],
    },
    ENUM_OAuth_Provider: {
        key: 'provider',
        rows: [
            [0, 'Not specified', 'Unspecified provider'],
            [1, 'Local', 'Email + password (non-DepEd only)'],
            [2, 'Google', 'DepEd Google SSO'],
            [3, 'Microsoft 365', 'DepEd Microsoft 365 SSO'],
        ],
    },
    ENUM_User_Type: {
        key: 'user_type',
        rows: [
            [0, 'Not specified', 'Unspecified type'],
            [1, 'External', 'Job applicant, JO/COS, or hire without DepEd email'],
            [2, 'Employee', 'Employee with (or pending) DepEd account'],
        ],
    },
};

const ROLE_SEEDS = [
    ['JOB_APPLICANT', 'Job Applicant', 'Default role for new external signups; least rights'],
    ['EXTERNAL_USER', 'External User', 'Auxiliary personnel and verified externals'],
    ['REGULAR_EMPLOYEE', 'Regular Employee', 'Employee with linked DepEd account'],
    ['HRMO', 'HRMO', 'Human Resource Management Officer; full HRM + role assignment'],
    ['SYSTEM_ADMIN', 'System Administrator', 'ITO sysadmin; full rights including user linking'],
];

const RIGHT_SEEDS = [
    ['rights.assign', 'Assign rights', 'Modify other users’ direct rights (limited scope)'],
    ['roles.assign', 'Assign roles', 'Assign/remove both roles and rights'],
    ['users.manage', 'Manage users', 'Create/update/activate/deactivate user accounts'],
    ['users.link.approve', 'Approve account unlink', 'Approve user-requested DepEd account unlinks'],
];

async function upsert(conn, sql, params, label) {
    if (DRY_RUN) {
        console.log(`[dry-run] ${label}: ${sql} -- ${JSON.stringify(params)}`);
        return;
    }
    await conn.execute(sql, params);
    console.log(`seeded ${label}`);
}

async function main() {
    if (DRY_RUN) {
        // No DB connection needed: print the full planned seed set.
        for (const [table, spec] of Object.entries(ENUM_SEEDS)) {
            for (const [id, name, desc] of spec.rows) {
                console.log(`[dry-run] ${table}:${id}=${name} -- ${JSON.stringify(desc)}`);
            }
        }
        for (const [code, name, desc] of ROLE_SEEDS) {
            console.log(`[dry-run] Role:${code} -- ${JSON.stringify([name, desc])}`);
        }
        for (const [code, name, desc] of RIGHT_SEEDS) {
            console.log(`[dry-run] Right:${code} -- ${JSON.stringify([name, desc])}`);
        }
        for (const roleCode of ['HRMO', 'SYSTEM_ADMIN']) {
            for (const [rightCode] of RIGHT_SEEDS) {
                console.log(`[dry-run] Role_Right:${roleCode}+${rightCode}`);
            }
        }
        console.log('dry-run complete.');
        return;
    }
    if (!dbConfig.user) {
        console.error('seed-janus: IHRMIS_MYSQL_USER is not set; refusing to connect without explicit credentials.');
        process.exit(2);
    }
    const conn = await mysql.createConnection(dbConfig);
    try {
        for (const [table, spec] of Object.entries(ENUM_SEEDS)) {
            for (const [id, name, desc] of spec.rows) {
                await upsert(conn,
                    `INSERT INTO \`${table}\` (\`${spec.key}\`, \`name\`, \`description\`) VALUES (?, ?, ?) ` +
                    `ON DUPLICATE KEY UPDATE \`name\`=VALUES(\`name\`), \`description\`=VALUES(\`description\`)`,
                    [id, name, desc], `${table}:${id}=${name}`);
            }
        }
        for (const [code, name, desc] of ROLE_SEEDS) {
            await upsert(conn,
                'INSERT INTO `Role` (`code`, `name`, `description`) VALUES (?, ?, ?) ' +
                'ON DUPLICATE KEY UPDATE `name`=VALUES(`name`), `description`=VALUES(`description`)',
                [code, name, desc], `Role:${code}`);
        }
        for (const [code, name, desc] of RIGHT_SEEDS) {
            await upsert(conn,
                'INSERT INTO `Right` (`code`, `name`, `description`) VALUES (?, ?, ?) ' +
                'ON DUPLICATE KEY UPDATE `name`=VALUES(`name`), `description`=VALUES(`description`)',
                [code, name, desc], `Right:${code}`);
        }
        // Minimal Role_Right grants: HRMO + SYSTEM_ADMIN hold all four rights;
        // applicant/auxiliary roles hold none until the full catalog lands.
        const [rights] = await conn.execute('SELECT `rightId`, `code` FROM `Right` WHERE `code` IN (?,?,?,?)',
            RIGHT_SEEDS.map((r) => r[0]));
        const [roles] = await conn.execute('SELECT `roleId`, `code` FROM `Role` WHERE `code` IN (?,?)',
            ['HRMO', 'SYSTEM_ADMIN']);
        const roleByCode = Object.fromEntries(roles.map((r) => [r.code, r.roleId]));
        for (const roleCode of ['HRMO', 'SYSTEM_ADMIN']) {
            for (const right of rights) {
                await upsert(conn,
                    'INSERT IGNORE INTO `Role_Right` (`roleId`, `rightId`) VALUES (?, ?)',
                    [roleByCode[roleCode], right.rightId], `Role_Right:${roleCode}+${right.code}`);
            }
        }
        console.log(DRY_RUN ? 'dry-run complete.' : 'JANUS seed complete.');
    } finally {
        await conn.end();
    }
}

main().catch((err) => {
    console.error(`seed-janus: ${err?.message ?? String(err)}`);
    process.exit(1);
});
