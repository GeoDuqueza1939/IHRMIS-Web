import path from 'path';
import express from 'express';
import argus from './argus.mjs';
import config from './config.mjs';
import server from './server.mjs';
import lifecycle from './lifecycle.mjs';
import controller from './controller.mjs';

const __dirname = config.rootDir;

export default class ihrmis_app {
    // Fields
    // #name and #shortname have been moved to src/modules/config.mjs.
    // #name = 'Integrated Human Resource Management Information System';
    // #shortname = 'IHRMIS';

    #logger = null;
    #app = null;
    #server = null;
    #lifecycle = null;
    #controller = null;
    #ready = false;

    // Constructor
    constructor() {
        this.#logger = new argus(config.logs);
        this.#logger.banner(`=== ${config.name} (${config.shortname}) - ARGUS system logging started [directory: ${config.logs.dir}] ===`);

        this.#app = express();

        this.#app.disable('x-powered-by');
        this.#app.set('view engine', 'ejs');
        this.#app.set('views', path.join(__dirname, 'views'));
        this.#app.use(express.urlencoded({ extended: true }));
        this.#app.use(express.json());
        this.#app.use(express.static(path.join(__dirname, 'public')));

        this.#lifecycle = new lifecycle({
            logger: this.#logger,
            closeAll: () => this.#server?.closeAll()
        });

        try {
            this.#server = new server({ logger: this.#logger, app: this.#app });
        } catch (err) {
            this.#logger.error(err.message);
            this.#lifecycle.shutdown(1);
            return;
        }

        this.#controller = new controller({ app: this.#app, logger: this.#logger });

        this.#ready = true;

        this.#logger.info('Server initialized.');
    }

    // Methods
    run() {
        if (!this.#ready) {
            return;
        }

        this.#lifecycle.startRepl();
        this.#server.start();
        this.#logger.info('Server is running.');
    }
}