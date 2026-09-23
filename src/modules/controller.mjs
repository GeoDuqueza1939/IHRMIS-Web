import express from 'express';
import config from './config.mjs';

export default class controller {
    // Fields
    #logger = null;
    #app = null;
    #router = null;

    // Constructor
    constructor({ app, logger }) {
        this.#logger = logger;
        this.#app = app;
        this.#setupRoutes();
    }

    // Private methods
    #setupRoutes() {
        // create a router for handling routes
        this.#router = express.Router();

        // define routes
        this.#router.get(config.baseDir, (req, res) => {
            this.#logger.info(`${req.method} ${req.url}`);
            res.render('index', { baseDir: config.baseDir, name: '' });
        });

        this.#router.get(`${config.baseDir}/login`, (req, res) => {
            res.render('login1', { baseDir: config.baseDir, username: '', password: '' });
        });

        this.#router.post(`${config.baseDir}/login`, (req, res) => {
            res.render('login1', { baseDir: config.baseDir, username: req.body.username || '', password: req.body.password || '' });
        });

        const loginDesigns = [1, 2, 3, 4];
        // for (const design of loginDesigns) {
        //     this.#router.get(`${config.baseURL}/login/${design}`, (req, res) => {
        //         res.render(`login${design}`, { baseDir: config.baseDir, username: '', password: '' });
        //     });

        //     this.#router.post(`${config.baseURL}/login/${design}`, (req, res) => {
        //         res.render(`login${design}`, { baseDir: config.baseDir, username: req.body.username || '', password: req.body.password || '' });
        //     });
        // }

        this.#router.get(`${config.baseDir}/login/:id`, (req, res) => {
            if (loginDesigns.includes(parseInt(req.params.id))) {
                res.render(`login${req.params.id}`, { baseDir: config.baseDir, username: '', password: '' });
            }
            else {
                res.status(404).render('error', { baseDir: config.baseDir, message: 'Login page not found.', statusCode: 404, app_name: config.shortname });
                return;
            }
        });

        this.#router.post(`${config.baseDir}/login/:id`, (req, res) => {
            if (loginDesigns.includes(parseInt(req.params.id))) {
                res.render(`login${req.params.id}`, { baseDir: config.baseDir, username: req.body.username || '', password: req.body.password || '' });
            }
            else {
                res.status(404).render('error', { baseDir: config.baseDir, message: 'Login page not found.', statusCode: 404, app_name: config.shortname });
                return;
            }
        });

        const sspDesigns = [1, 2, 3];

        this.#router.get(`${config.baseDir}/ssp/:id`, (req, res) => {
            if (sspDesigns.includes(parseInt(req.params.id))) {
                res.render(`ssp${req.params.id}`, { baseDir: config.baseDir });
            }
            else {
                res.status(404).render('error', { baseDir: config.baseDir, message: 'Self-Service Portal page not found.', statusCode: 404, app_name: config.shortname });
                return;
            }
        });


        const mainDesigns = [1, 2, 3];

        const renderMain = (req, res) => {
            res.render(`main1`, { baseDir: config.baseDir });
        };

        const renderMainById = (req, res) => {
            if (mainDesigns.includes(parseInt(req.params.id))) {
                res.render(`main${req.params.id}`, { baseDir: config.baseDir });
            }
            else {
                res.status(404).render('error', { baseDir: config.baseDir, message: 'HRMO main page not found.', statusCode: 404, app_name: config.shortname });
                return;
            }
        };

        this.#router.get(`${config.baseDir}/main`, renderMain);
        this.#router.get(`${config.baseDir}/main/:id`, renderMainById);

        // TEMPORARY TEST ROUTES
        const renderTest = (req, res) => {
            res.render('test', { baseDir: config.baseDir, testdata: req });
        }

        this.#router.get(`${config.baseDir}/test`, renderTest);

        this.#router.post(`${config.baseDir}/test`, renderTest);

        this.#app.use(this.#router);

        // 404 handler
        this.#app.use((req, res) => {
            const friendlyErrorMessage = 'The page you are looking for could not be found.';
            res.status(404).render('error', { baseDir: config.baseDir, message: friendlyErrorMessage, statusCode: 404, app_name: config.shortname });
            this.#logger.warn(`404 Not Found: ${req.method} ${req.url}`);
        });

        // Error handling middleware
        this.#app.use((err, req, res, next) => {
            const statusCode = err?.statusCode ?? err?.status ?? 500;
            const errorMessage = `Unhandled error: ${err?.message ?? String(err)}`;
            const friendlyErrorMessage = 'An unexpected error occurred.';
            this.#showErrorPage(err, friendlyErrorMessage, errorMessage, res, statusCode);
        });
    }

    #showErrorPage(err, friendlyErrorMessage, consoleErrorMessage, res, statusCode = 0) {
        statusCode = (statusCode === 0 ? ((err && err.statusCode) || 500) : statusCode);
        this.#logger.error(consoleErrorMessage);
        res.status(statusCode).render('error', { baseDir: config.baseDir, message: friendlyErrorMessage, statusCode, app_name: config.shortname });
    }
}