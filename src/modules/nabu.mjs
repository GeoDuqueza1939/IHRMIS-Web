"use strict";

import mysql from 'mysql2/promise';
import config from './config.mjs';

export default class nabu { // Networked Archive and Back-end Utility; MySQL data access layer
    // Fields
    #logger = null;
    #pool = null;

    // Constructor
    constructor({ logger }) {
        this.#logger = logger;
        this.#initPool();
    }

    // Methods
    async checkConnection() {
        if (!this.#pool) {
            this.#logger.error('MySQL connection pool is not initialized.');
            return false;
        }

        try {
            const connection = await this.#pool.getConnection();
            try {
                await connection.ping();
            } finally {
                connection.release();
            }
            this.#logger.info(`MySQL connection is healthy [${config.mysql.host}:${config.mysql.port}/${config.mysql.database}].`);
            return true;
        } catch (err) {
            this.#logger.error(`MySQL connection check failed: ${err.message}`);
            return false;
        }
    }

    async query(sql, params) {
        return this.#requirePool().query(sql, params);
    }

    async execute(sql, params) {
        return this.#requirePool().execute(sql, params);
    }

    async getConnection() {
        return this.#requirePool().getConnection();
    }

    async close() {
        if (!this.#pool) {
            return;
        }
        await this.#pool.end();
        this.#pool = null;
        this.#logger.info('MySQL connection pool closed.');
    }

    // Private methods
    #initPool() {
        try {
            this.#pool = mysql.createPool(config.mysql);
            this.#logger.info(`MySQL connection pool initialized [${config.mysql.host}:${config.mysql.port}/${config.mysql.database}].`);
        } catch (err) {
            this.#logger.error(`Unable to initialize the MySQL connection pool: ${err.message}`);
            this.#pool = null;
        }
    }

    #requirePool() {
        if (!this.#pool) {
            throw new Error('MySQL connection pool is not initialized.');
        }
        return this.#pool;
    }
}