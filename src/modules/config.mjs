import path from 'path';

const config = {
    name: 'Integrated Human Resource Management Information System',
    shortname: 'IHRMIS',

    host: process.env.IHRMIS_HOST || 'localhost',

    rootDir: path.dirname(import.meta.dirname),

    baseDir: process.env.IHRMIS_BASE_DIR || '/ihrmis', // Base path URL for the application, e.g., '/ihrmis' if hosted under a subdirectory; should not include the protocol and domain/hostname; no need to end in a slash

    ports: {
        local_http: Number(process.env.IHRMIS_LOCAL_HTTP_PORT) || 3000,
        local_https: Number(process.env.IHRMIS_LOCAL_HTTPS_PORT) || 8443,
    },

    tls: {
        securePath: process.env.IHRMIS_SECURE_PATH ||
            (process.platform === 'win32'
                ? 'C:\\ProgramData\\IHRMIS\\TLS'
                : '/etc/ihrmis/tls'
            ),
    },

    logs: {
        dir: process.env.IHRMIS_LOG_DIR || path.join(path.dirname(import.meta.dirname), 'logs'),
        filename: process.env.IHRMIS_LOG_FILENAME || 'system-%DATE%.log',
        datePattern: process.env.IHRMIS_LOG_DATEPATTERN || 'YYYY-MM-DD',
        maxSize: process.env.IHRMIS_LOG_MAXSIZE || '20m',
        maxFiles: process.env.IHRMIS_LOG_MAXFILES || '14d',
        zippedArchive: true,
        level: process.env.IHRMIS_LOG_LEVEL || 'info',
    },

    mysql: {
        host: process.env.IHRMIS_MYSQL_HOST || 'localhost',
        port: Number(process.env.IHRMIS_MYSQL_PORT) || 3306,
        user: process.env.IHRMIS_MYSQL_USER,
        password: process.env.IHRMIS_MYSQL_PASSWORD,
        database: process.env.IHRMIS_MYSQL_DATABASE || 'ihrmis',
        waitForConnections: true,
        connectionLimit: Number(process.env.IHRMIS_MYSQL_CONNECTION_LIMIT) || 10,
        queueLimit: 0,
    },

    janus: {
        depedDomain: process.env.IHRMIS_DEPED_DOMAIN || 'deped.gov.ph',
        maxAltLogins: Number(process.env.IHRMIS_MAX_ALT_LOGINS) || 3, // primary + up to 3 alt local emails
        sessionMaxAgeMs: Number(process.env.IHRMIS_SESSION_MAX_AGE_MS) || 12 * 60 * 60 * 1000,
        lockoutThreshold: Number(process.env.IHRMIS_LOCKOUT_THRESHOLD) || 5,
        lockoutMinutes: Number(process.env.IHRMIS_LOCKOUT_MINUTES) || 15,
    },

    oidc: {
        google: {
            clientId: process.env.IHRMIS_GOOGLE_CLIENT_ID || '',
            clientSecret: process.env.IHRMIS_GOOGLE_CLIENT_SECRET || '',
            hd: process.env.IHRMIS_GOOGLE_HD || 'deped.gov.ph',
        },
        ms365: {
            clientId: process.env.IHRMIS_MS_CLIENT_ID || '',
            clientSecret: process.env.IHRMIS_MS_CLIENT_SECRET || '',
            tenant: process.env.IHRMIS_MS_TENANT || 'common',
        },
    },

    smtp: {
        host: process.env.IHRMIS_SMTP_HOST || '',
        port: Number(process.env.IHRMIS_SMTP_PORT) || 587,
        user: process.env.IHRMIS_SMTP_USER || '',
        password: process.env.IHRMIS_SMTP_PASSWORD || '',
        from: process.env.IHRMIS_SMTP_FROM || 'IHRMIS <no-reply@deped.gov.ph>',
    },
};

export default config;