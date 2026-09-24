"use strict";

export default class janus {
    app_name = 'IHRMIS';
    module_name = 'Joint Authentication and Navigation for Unified Services';
    module_shortname = 'JANUS';
    
    #ihrmis_app = null;
    #logger = null;
    #controller = null;
    #janus_url = '';

    constructor(ihrmis_app) {
        this.#ihrmis_app = ihrmis_app;
        this.#logger = this.#ihrmis_app.getLogger(this);
        this.#controller = this.#ihrmis_app.getController(this);
        this.#janus_url = `${config.baseDir}/janus`;
    }

    #setupRoutes() {
        const urls = {
            login: `${this.#janus_url}/login`,
            logout: `${this.#janus_url}/logout`,
            signup: `${this.#janus_url}/signup`,
        };
    }

    login(username, signInMethod) {

    }

    verifyPassword(username, password) { // for email logins only

    }

    verifyToken(username, token) { // for DepEd login only

    }

    logout() {

    }

    // User Management methods; username should be an email address

    signup(username) { // for email sign-ups only; sends email to specified email address with verification link

    }

    addUser(username) { // for user management by System Admin; sends email to specified email address with verification link

    }

    verifyUser(username, token, newPassword) { // token is identified in the URL

    }

    verifyOAuthUser(username, token, provider) { // token from identity provider

    }

    changePassword(username, oldPassword, newPassword) { // for email logins only

    }

    addLogin(username) { // add alternative email for login use

    }

    addRole(username, role) {

    }

    removeRole(username, role) {

    }
    
    mergeUsers(username1, username2, mergedData = {}) { // USE WITH CAUTION

    }
 
    setUserStatus(username, status) { // set to active, inactive, or separated.

    }

    deleteUser(username) { // USE WITH CAUTION

    }
}