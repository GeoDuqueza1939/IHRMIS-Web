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
    status = '';
    port = null;

    // Constructor
    constructor() {
        this.app = express();

        this.port = {
            'local_http': 3000,
            'local_https': 8443,
            'https': 443,
        };

        this.setStatus('Server initialized.');
    }

    // Methods
    run() {
        this.consoleControl();
        
        console.log(url);

        // redirect HTTP to HTTPS
        http.createServer((req, res) => {
            const location = `https://${req.headers.host}${req.url || '/'}`;
            res.writeHead(301, { Location: location });
            res.end();
        }).listen(this.port.local_http, () => {
            this.setStatus('HTTP redirect server running.');
        }).addListener('error', (err) => {
            this.setStatus(`HTTP redirect server error: ${err.message}`);
        });

        const securePath = process.env.IHRMIS_SECURE_PATH ||
            (process.platform === 'win32' 
                ? 'C:\\ProgramData\\IHRMIS\\TLS'
                : '/etc/ihrmis/tls'
            );
            
        const options = {
            key: fs.readFileSync(path.join(securePath, 'server.key')),
            cert: fs.readFileSync(path.join(securePath, 'server.crt')),
        };

        // const options = null;

        const secureserver = https.createServer(options, (req, res) => {
            res.writeHead(200, { 'Content-Type': 'text/plain' });
            res.end('Hello, World! This is the IHRMIS secure server running.');

            this.setStatus(`Secure server received request: ${req.method} ${req.url}`);
        });

        secureserver.listen(this.port.local_https || this.port.https, () => {
            this.status = 'Secure server running.';
            console.log(this.status);
        }).addListener('error', (err) => {
            this.setStatus(`Secure server error: ${err.message}`);
        });

        this.status = 'Server is running.';
        console.log(this.status);
    }

    async consoleControl() {
        this.status = 'Configuring Console Controls...';

        const rl = readline.createInterface({
            input: process.stdin,
            output: process.stdout
        });

        rl.on('line', (input) => {
            switch (input.trim().toLowerCase()) {
                case 'status':
                    console.log(this.status);
                    break;
                case 'help':
                    console.log('Available commands:');
                    console.log('  help - Show this help message');
                    console.log('  exit - Exit the application');
                    break;
                case 'exit':
                    console.log('Exiting the application...');
                    process.exit(0);
                    break;
                default:
                    console.log(`Unknown command: ${input}`);
            }
        });
    }

    setStatus(statusMsg) {
        this.status = statusMsg;
        console.log(`${this.status}`);
    }   
}