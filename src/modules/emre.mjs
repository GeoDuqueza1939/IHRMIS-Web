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

        // Layout 1 (tabbed) is the default view; layout 2 is the dossier and
        // layout 3 the card deck.
        const views = { 1: 'emre1', 2: 'emre2', 3: 'emre3' };

        const renderViewer = (view) => (req, res) => {
            this.#logger?.info(`EmRE Viewer page (${view}): ${req.method} ${req.url}`);
            res.render(view, {
                baseDir: config.baseDir,
                employee: req.body?.employee || '',
                password: '',
                error: '',
                warning: '',
            });
        };

        try {
            this.#controller.addCustomRoute('get', `${b}/emp/:empno`, renderViewer(views[1]));
            this.#controller.addCustomRoute('post', `${b}/emp/:empno`, renderViewer(views[1]));
            this.#controller.addCustomRoute('get', `${b}/emp/:empno/dossier`, renderViewer(views[2]));
            this.#controller.addCustomRoute('post', `${b}/emp/:empno/dossier`, renderViewer(views[2]));
            this.#controller.addCustomRoute('get', `${b}/emp/:empno/deck`, renderViewer(views[3]));
            this.#controller.addCustomRoute('post', `${b}/emp/:empno/deck`, renderViewer(views[3]));
        } catch (err) {
            this.#logger?.error(`EmRE route setup failed: ${err?.message ?? String(err)}`);
        }
    }
}