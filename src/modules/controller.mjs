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

        this.#app.use(this.#router);
        
        this.#setupTestRoutes();

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

    // TEMPORARY TEST ROUTES : BEGIN
    #setupTestRoutes() {
        const urlTest = `${config.baseDir}/test`;
        const urlSample = {
            login: `${config.baseDir}/test/login`,
            ssp: `${config.baseDir}/test/ssp`,
            main: `${config.baseDir}/test/main`,
        };

        // login sample layouts
        const loginDesigns = [1, 2, 3, 4];

        const renderLogin = (req, res) => {
            if (loginDesigns.includes(parseInt(req.params.id))) {
                res.render(`login${req.params.id}`, { baseDir: config.baseDir, username: req.body?.username || '', password: req.body?.password || '' });
            }
            else {
                res.status(404).render('error', { baseDir: config.baseDir, message: 'Login page not found.', statusCode: 404, app_name: config.shortname });
                return;
            }
        }

        this.#router.get(`${urlSample.login}/:id`, renderLogin);
        this.#router.post(`${urlSample.login}/:id`, renderLogin);
        this.#router.get(urlSample.login, this.#sampleLayoutViewer("Login", loginDesigns, urlSample.login));

        // SSP sample layouts
        const sspDesigns = [1, 2, 3];

        const renderSSP = (req, res) => {
            if (sspDesigns.includes(parseInt(req.params.id))) {
                res.render(`ssp${req.params.id}`, { baseDir: config.baseDir });
            }
            else {
                res.status(404).render('error', { baseDir: config.baseDir, message: 'Self-Service Portal page not found.', statusCode: 404, app_name: config.shortname });
                return;
            }
        };

        this.#router.get(`${urlSample.ssp}/:id`, renderSSP);
        this.#router.post(`${urlSample.ssp}/:id`, renderSSP);
        this.#router.get(urlSample.ssp, this.#sampleLayoutViewer("SSP", sspDesigns, urlSample.ssp));

        // main sample layouts
        const mainDesigns = [1, 2, 3];

        const renderMainById = (req, res) => {
            if (mainDesigns.includes(parseInt(req.params.id))) {
                res.render(`main${req.params.id}`, { baseDir: config.baseDir });
            }
            else {
                res.status(404).render('error', { baseDir: config.baseDir, message: 'HRMO main page not found.', statusCode: 404, app_name: config.shortname });
                return;
            }
        };

        this.#router.get(`${urlSample.main}/:id`, renderMainById);
        this.#router.post(`${urlSample.main}/:id`, renderMainById);
        this.#router.get(urlSample.main, this.#sampleLayoutViewer("Main", mainDesigns, urlSample.main));

        // test page
        const renderTest = (req, res) => {
            res.render('test', { baseDir: config.baseDir, testdata: req, urls: JSON.stringify(urlSample), });
        }
        this.#router.get(urlTest, renderTest);
        this.#router.post(urlTest, renderTest);
    }
    // TEMPORARY TEST ROUTES : END

    #showErrorPage(err, friendlyErrorMessage, consoleErrorMessage, res, statusCode = 0) {
        statusCode = (statusCode === 0 ? ((err && err.statusCode) || 500) : statusCode);
        this.#logger.error(consoleErrorMessage);
        res.status(statusCode).render('error', { baseDir: config.baseDir, message: friendlyErrorMessage, statusCode, app_name: config.shortname });
    }

    #sampleLayoutViewer(sampleLayoutName, sampleLayoutIds, url) {
        return (req, res) => {
            res.render('testsample', { sampleLayoutName, sampleLayoutIds, url });
        };
    }
}