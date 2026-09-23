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
        this.#router.get(config.basePath, (req, res) => {
            this.#logger.info(`${req.method} ${req.url}`);
            res.render('index', { name: '' });
        });

        this.#router.get(`${config.basePath}/login`, (req, res) => {
            res.render('login1', { username: '', password: '' });
        });

        this.#router.post(`${config.basePath}/login`, (req, res) => {
            res.render('login1', { username: req.body.username || '', password: req.body.password || '' });
        });

        const loginDesigns = [1, 2, 3, 4];
        // for (const design of loginDesigns) {
        //     this.#router.get(`${config.baseURL}/login/${design}`, (req, res) => {
        //         res.render(`login${design}`, { username: '', password: '' });
        //     });

        //     this.#router.post(`${config.baseURL}/login/${design}`, (req, res) => {
        //         res.render(`login${design}`, { username: req.body.username || '', password: req.body.password || '' });
        //     });
        // }

        this.#router.get(`${config.basePath}/login/:id`, (req, res) => {
            if (loginDesigns.includes(parseInt(req.params.id))) {
                res.render(`login${req.params.id}`, { username: '', password: '' });
            }
            else {
                res.status(404).render('error', { message: 'Login page not found.', statusCode: 404, app_name: config.shortname });
                return;
            }
        });

        this.#router.post(`${config.basePath}/login/:id`, (req, res) => {
            if (loginDesigns.includes(parseInt(req.params.id))) {
                res.render(`login${req.params.id}`, { username: req.body.username || '', password: req.body.password || '' });
            }
            else {
                res.status(404).render('error', { message: 'Login page not found.', statusCode: 404, app_name: config.shortname });
                return;
            }
        });

        const sspDesigns = [1, 2, 3];

        this.#router.get(`${config.basePath}/ssp/:id`, (req, res) => {
            if (sspDesigns.includes(parseInt(req.params.id))) {
                res.render(`ssp${req.params.id}`, {});
            }
            else {
                res.status(404).render('error', { message: 'Self-Service Portal page not found.', statusCode: 404, app_name: config.shortname });
                return;
            }
        });


        const mainDesigns = [1, 2, 3];

        const renderMain = (req, res) => {
            res.render(`main1`, {});
        };

        const renderMainById = (req, res) => {
            if (mainDesigns.includes(parseInt(req.params.id))) {
                res.render(`main${req.params.id}`, {});
            }
            else {
                res.status(404).render('error', { message: 'HRMO main page not found.', statusCode: 404, app_name: config.shortname });
                return;
            }
        };

        this.#router.get(`/main`, renderMain);
        this.#router.get(`/main/:id`, renderMainById);

        // Legacy alias - /dashboard still serves the main interface
        this.#router.get(`/dashboard`, renderMain);
        this.#router.get(`/dashboard/:id`, renderMainById);


        // TEMPORARY TEST ROUTES
        this.#router.get(`${config.basePath}/test`, (req, res) => {
            res.render('test', { testdata: req });
        });

        this.#router.post(`${config.basePath}/test`, (req, res) => {
            res.render('test', { testdata: req });
        });

        this.#app.use(this.#router);

        // 404 handler
        this.#app.use((req, res) => {
            const friendlyErrorMessage = 'The page you are looking for could not be found.';
            res.status(404).render('error', { message: friendlyErrorMessage, statusCode: 404, app_name: config.shortname });
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
        res.status(statusCode).render('error', { message: friendlyErrorMessage, statusCode, app_name: config.shortname });
    }
}