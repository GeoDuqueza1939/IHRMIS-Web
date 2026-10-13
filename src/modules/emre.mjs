"use strict";

import config from './config.mjs';

export default class emre {
    app_name = 'IHRMIS';
    module_name = 'Employee Records Engine';
    module_shortname = 'EmRE';

    #ihrmis_app = null;
    #logger = null;
    #controller = null;
    #emre_url = '';

    constructor(ihrmis_app) {
        this.#ihrmis_app = ihrmis_app;
        this.#logger = this.#ihrmis_app.getLogger(this);
        this.#controller = this.#ihrmis_app.getController(this);
        this.#emre_url = `${config.baseDir}/emre`;
        this.#setupRoutes();
    }

    #setupRoutes() {
        if (!this.#controller) return;
        const b = this.#emre_url;
        const renderViewer = (req, res) => {
            this.#logger?.info(`EmRE Viewer page: ${req.method} ${req.url}`);
            res.render('emre', {
                baseDir: config.baseDir,
                employee: req.body?.employee || '',
                password: '',
                error: '',
                warning: '',
            });
        };
        try {
            this.#controller.addCustomRoute('get', `${b}/emp/:empno`, renderViewer);
            this.#controller.addCustomRoute('post', `${b}/emp/:empno`, renderViewer);
        } catch (err) {
            this.#logger?.error(`EmRE route setup failed: ${err?.message ?? String(err)}`);
        }
    }
}