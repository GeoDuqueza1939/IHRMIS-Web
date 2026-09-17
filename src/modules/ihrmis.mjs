import http from 'http';
import https from 'https';
import fs from 'fs';
import path from 'path';
import express from 'express';
import readline from 'readline';
import url from 'url';
import ejs from 'ejs';

const __dirname = path.resolve();

export default class ihrmis_app {
    // Fields
    #name = 'Integrated Human Resource Management Information System';
    #shortname = 'IHRMIS';

    #app = null;
    #router = null;

    #secureServer = null;
    #httpsOptions = null;
    #port = {
        'local_http': 3000,
        'local_https': 8443,
        'http': 80,
        'https': 443,
    };
    
    #status = '';
    #statusMsgType = {
        info: 'INFO',
        warn: 'WARN',
        error: 'ERROR',
    };
    #isUserAuthenticated = false;

    // Constructor
    constructor() {
        this.#app = express();

        this.#app.set('view engine', 'ejs');
        this.#app.use(express.urlencoded({ extended: true }));
        this.#app.use(express.static(path.join(__dirname, 'public')));

        const securePath = process.env.IHRMIS_SECURE_PATH ||
            (process.platform === 'win32'
                ? 'C:\\ProgramData\\IHRMIS\\TLS'
                : '/etc/ihrmis/tls'
            );

        this.#httpsOptions = {
            key: fs.readFileSync(path.join(securePath, 'server.key')),
            cert: fs.readFileSync(path.join(securePath, 'server.crt')),
        }

        this.#setupRoutes();

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

        this.#secureServer = https.createServer(this.#httpsOptions, this.#app);

        this.#secureServer.listen(this.#port.local_https || this.#port.https, () => {
            this.#setStatus('Secure server running.');
        }).addListener('error', (err) => {
            this.#setStatus(`Secure server error: ${err.message}`);
        });

        this.#setStatus('Server is running.');
    }

    #setupRoutes() {
        // create a router for handling routes
        this.#router = express.Router();

        // define routes
        this.#router.get('/', (req, res) => {
            this.#setStatus(req.method + ' ' + req.url);
            res.render('index', { name: '' });
        });

        this.#router.get('/login', (req, res) => {
            res.render('login1', { username: '', password: '' });
        });

        this.#router.post('/login', (req, res) => {
            res.render('login1', { username: req.body.username || '', password: req.body.password || '' });
        });

        const loginDesigns = [1, 2, 3, 4];
        for (const design of loginDesigns) {
            this.#router.get(`/login/${design}`, (req, res) => {
                res.render(`login${design}`, { username: '', password: '' });
            });

            this.#router.post(`/login/${design}`, (req, res) => {
                res.render(`login${design}`, { username: req.body.username || '', password: req.body.password || '' });
            });
        }

        // TEMPORARY TEST ROUTES
        this.#router.get('/test', (req, res) => {
            res.render('test', { testdata: req });
        });

        this.#router.post('/test', (req, res) => {
            res.render('test', { testdata: req });
        });

        this.#app.use(this.#router);

        // Error handling middleware
        this.#app.use((err, req, res, next) => {
            const errorMessage = `Unhandled error: ${err.message}`;
            const friendlyErrorMessage = 'An unexpected error occurred.';
            this.#showErrorPage(err, friendlyErrorMessage, errorMessage, res, 500);
        });
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
                    console.log(`\nLatest server status: ${this.#status}\n`);
                    break;
                case 'help':
                    console.log('\nAvailable commands:');
                    console.log('  status - Show the latest server status.');
                    console.log('  help   - Show this help message.');
                    console.log('  exit   - Exit the application.\n');
                    break;
                case 'exit':
                    console.log('\nExiting the application...\n');
                    process.exit(0);
                    break;
                default:
                    console.log(`\nUnknown command: ${input}\n`);
                    break;
            }
        });
    }

    #setStatus(statusMsg, statusType = this.#statusMsgType.info) {
        this.#status = statusMsg;
        let timestamp = new Date();
        timestamp = String(timestamp.getFullYear()).padStart(4, '0') +
            String(timestamp.getMonth() + 1).padStart(2, '0') +
            String(timestamp.getDate()).padStart(2, '0') + '-' +
            String(timestamp.getHours()).padStart(2, '0') + ':' +
            String(timestamp.getMinutes()).padStart(2, '0') + ':' +
            String(timestamp.getSeconds()).padStart(2, '0');
        switch (statusType) {
            case this.#statusMsgType.info:
                console.log(`[${timestamp}]-[INFO] ${statusMsg}`);
                break;
            case this.#statusMsgType.warn:
                console.warn(`[${timestamp}]-[WARN] ${statusMsg}`);
                break;
            case this.#statusMsgType.error:
                console.error(`[${timestamp}]-[ERROR] ${statusMsg}`);
                break;
            default:
                console.log(`[${timestamp}]-[UNKNOWN] ${statusMsg}`);
                break;
        }
    }

    #showErrorPage(err, friendlyErrorMessage, consoleErrorMessage, res, statusCode = 0) {
        statusCode = (statusCode === 0 ? err.statusCode ?? 500 : statusCode);
        this.#setStatus(consoleErrorMessage, this.#statusMsgType.error);
        res.status(statusCode).render('error', { message: friendlyErrorMessage, statusCode, app_name: this.#shortname });
    }
}
