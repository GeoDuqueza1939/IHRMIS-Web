// import morgan from 'morgan';
// import * as winston from 'winston';
// import nodemailer from 'nodemailer';

import ihrmis_app from './modules/ihrmis.mjs';

let app = new ihrmis_app();
app.run();