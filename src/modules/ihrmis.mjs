import http from 'http';
import https from 'https';
import fs from 'fs';
import path from 'path';
import express from 'express';
import readline from 'readline';
import url from 'url';

const __dirname = path.resolve();

export default class ihrmis_app {
    // Fields
    #app = null;
    #name = 'Integrated Human Resource Management Information System';
    #shortname = 'IHRMIS';
    #status = '';
    #port = null;
    #secureServer = null;
    #httpsOptions = null;
    #isUserAuthenticated = false;

    // Constructor
    constructor() {
        this.app = express();

        this.#app.set('view engine', 'ejs');
        this.#app.use(express.urlencoded({ extended: true }));
        this.#app.use(express.static(path.join(__dirname, 'public')));

        this.#port = {
            'local_http': 3000,
            'local_https': 8443,
            'http': 80,
            'https': 443,
        };

        const securePath = process.env.IHRMIS_SECURE_PATH ||
            (process.platform === 'win32'
                ? 'C:\\ProgramData\\IHRMIS\\TLS'
                : '/etc/ihrmis/tls'
            );

        this.#httpsOptions = {
            key: fs.readFileSync(path.join(securePath, 'server.key')),
            cert: fs.readFileSync(path.join(securePath, 'server.crt')),
        };


        this.#setStatus('Server initialized.');
    }

    // Methods
    run() {
        this.#consoleControl();

        // redirect HTTP to HTTPS
        http.createServer((req, res) => {
            const location = `https://${req.headers.host}${req.url || '/'}`;

            this.#setStatus('Redirecting to secure server...');

            res.writeHead(301, { Location: location });

            res.end();
        }).listen(this.#port.local_http, () => {
            this.#setStatus('HTTP redirect server running.');
        }).addListener('error', (err) => {
            this.#setStatus(`HTTP redirect server error: ${err.message}`);
        });

        this.#secureServer = https.createServer(this.#httpsOptions, (req, res) => {
            res.writeHead(200, { 'Content-Type': 'text/plain' });

            res.end('Hello, World! This is the IHRMIS secure server running.');

            this.#setStatus(`Secure server received request: ${req.method} ${req.url}`);
        });

        this.#secureServer.listen(this.#port.local_https || this.#port.https, () => {
            this.#setStatus('Secure server running.');
        }).addListener('error', (err) => {
            this.#setStatus(`Secure server error: ${err.message}`);
        });

        this.#setStatus('Server is running.');
    }

    async #consoleControl() {
        this.#setStatus('Configuring Console Controls...');

        const rl = readline.createInterface({
            input: process.stdin,
            output: process.stdout
        });

        // add new console commands here
        rl.on('line', (input) => {
            switch (input.trim().toLowerCase()) {
                case 'status':
                    console.log(`\nCurrent server status: ${this.#status}\n`);
                    break;
                case 'help':
                    console.log('\nAvailable commands:');
                    console.log('  status - Show the server status.');
                    console.log('  help   - Show this help message.');
                    console.log('  exit   - Exit the application.\n');
                    break;
                case 'exit':
                    console.log('\nExiting the application...\n');
                    process.exit(0);
                    break;
                default:
                    console.log(`\nUnknown command: ${input}\n`);
            }
        });
    }

    #setStatus(statusMsg) {
        this.#status = statusMsg;
        console.log(`${this.#status}`);
    }
}
