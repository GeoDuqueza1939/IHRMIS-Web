"use strict";

import config from './config.mjs';

export default class aurora { // Self-Service Portal
    app_name = 'IHRMIS';
    module_name = 'Agency Unified Resources, Operations, and Related Applications';
    module_shortname = 'AURORA';
    
    #ihrmis_app = null;
    #logger = null;
    #controller = null;
    #aurora_url = '';

    constructor(ihrmis_app) {
        this.#ihrmis_app = ihrmis_app;
        this.#logger = this.#ihrmis_app.getLogger(this);
        this.#controller = this.#ihrmis_app.getController(this);
        this.#aurora_url = `${config.baseDir}/aurora`;

        this.#logger.banner(`=== ${config.name} (${config.shortname}) - AURORA initialized ===`);
    }

    #setupRoutes() {
        const renderSSP = (req, res) => {
            this.#logger.info('Loading the self-service portal...');

            res.render('aurora', {});
        };

        this.#controller.addCustomRoute('get', this.#aurora_url, renderSSP);
    }
}