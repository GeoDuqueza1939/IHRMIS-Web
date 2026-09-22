import http from 'http';
import https from 'https';
import fs from 'fs';
import path from 'path';
import config from './config.mjs';

export default class server {
    // Fields
    #logger = null;
    #app = null;
    #httpsOptions = null;
    #secureServer = null;
    #httpRedirectServer = null;

    // Constructor
    constructor({ logger, app }) {
        this.#logger = logger;
        this.#app = app;

        try {
            this.#httpsOptions = {
                key: fs.readFileSync(path.join(config.tls.securePath, 'server.key')),
                cert: fs.readFileSync(path.join(config.tls.securePath, 'server.crt')),
                minVersion: 'TLSv1.2',
            }
        } catch (err) {
            throw new Error(`Unable to load TLS certificate from "${config.tls.securePath}": ${err.message}. ` +
                `Make sure server.key and server.crt exist at that location, or set the ` +
                `IHRMIS_SECURE_PATH environment variable to the directory containing them.`);
        }
    }

    // Methods
    start() {
        // redirect HTTP to HTTPS
        this.#httpRedirectServer = http.createServer((req, res) => {
            const location = `https://${config.host}:${config.ports.local_https}${req.url || '/'}`;
            this.#logger.info(`Redirecting HTTP to ${location}`);
            res.writeHead(301, { Location: location });
            res.end();
        }).listen(config.ports.local_http, () => {
            this.#logger.info('HTTP redirect server is running.');
        }).addListener('error', (err) => {
            this.#logger.error(`HTTP redirect server error: ${err.message}`);
        });

        this.#secureServer = https.createServer(this.#httpsOptions, this.#app);

        this.#secureServer.listen(config.ports.local_https, () => {
            this.#logger.info('Secure server is running.');
        }).addListener('error', (err) => {
            this.#logger.error(`Secure server error: ${err.message}`);
        });
    }

    closeAll() {
        const closing = [];

        if (this.#httpRedirectServer && this.#httpRedirectServer.listening) {
            closing.push(this.#closeServer(this.#httpRedirectServer));
        }
        if (this.#secureServer && this.#secureServer.listening) {
            closing.push(this.#closeServer(this.#secureServer));
        }

        return Promise.all(closing);
    }

    // Private methods
    #closeServer(server) {
        return new Promise((resolve) => {
            server.closeIdleConnections?.();
            server.close(() => resolve());
        });
    }
}