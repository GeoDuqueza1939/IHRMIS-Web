import path from 'path';

const config = {
    name: 'Integrated Human Resource Management Information System',
    shortname: 'IHRMIS',

    host: process.env.IHRMIS_HOST || 'localhost',

    rootDir: path.dirname(import.meta.dirname),

    baseDir: process.env.IHRMIS_BASE_DIR || '/ihrmis', // Base path URL for the application, e.g., '/ihrmis' if hosted under a subdirectory; should not include the protocol and domain/hostname; no need to end in a slash

    ports: {
        local_http: Number(process.env.IHRMIS_LOCAL_HTTP_PORT) || 3000,
        local_https: Number(process.env.IHRMIS_LOCAL_HTTPS_PORT) || 8443,
    },

    tls: {
        securePath: process.env.IHRMIS_SECURE_PATH ||
            (process.platform === 'win32'
                ? 'C:\\ProgramData\\IHRMIS\\TLS'
                : '/etc/ihrmis/tls'
            ),
    },

    logs: {
        dir: process.env.IHRMIS_LOG_DIR || path.join(path.dirname(import.meta.dirname), 'logs'),
        filename: process.env.IHRMIS_LOG_FILENAME || 'system-%DATE%.log',
        datePattern: process.env.IHRMIS_LOG_DATEPATTERN || 'YYYY-MM-DD',
        maxSize: process.env.IHRMIS_LOG_MAXSIZE || '20m',
        maxFiles: process.env.IHRMIS_LOG_MAXFILES || '14d',
        zippedArchive: true,
        level: process.env.IHRMIS_LOG_LEVEL || 'info',
    },
};

export default config;