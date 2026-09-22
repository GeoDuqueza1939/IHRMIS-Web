import fs from 'fs';
import path from 'path';
import winston from 'winston';
import DailyRotateFile from 'winston-daily-rotate-file';

export default class argus { // Audit, Recording, and Governance for Usage of the System (ARGUS)
    // Fields
    #logger = null;
    #config = null;
    #lastStatus = '';
    #lastLevel = 'info';

    // Constructor
    constructor(options) {
        const config = {
            dir: options?.dir || './logs',
            filename: options?.filename || 'system-%DATE%.log',
            datePattern: options?.datePattern || 'YYYY-MM-DD',
            maxSize: options?.maxSize || '20m',
            maxFiles: options?.maxFiles || '14d',
            zippedArchive: options?.zippedArchive ?? true,
            level: options?.level || 'info',
        };

        this.#config = config;

        try {
            fs.mkdirSync(config.dir, { recursive: true });
        } catch (err) {
            console.error(`[ARGUS] Could not create log directory "${config.dir}": ${err.message}`);
        }

        const logFormat = winston.format.combine(
            winston.format.timestamp({ format: () => this.#timestamp() }),
            winston.format.printf(({ timestamp, level, message }) => {
                return `[${timestamp}]-[${level.toUpperCase()}] ${message}`;
            })
        );

        const transports = [
            new winston.transports.Console({ format: logFormat }),
        ];

        try {
            const fileTransport = new DailyRotateFile({
                dirname: config.dir,
                filename: config.filename,
                datePattern: config.datePattern,
                maxSize: config.maxSize,
                maxFiles: config.maxFiles,
                zippedArchive: config.zippedArchive,
                format: logFormat,
            });
            fileTransport.on('error', (err) => {
                console.error(`[ARGUS] File transport error: ${err.message}`);
            });
            transports.push(fileTransport);
        } catch (err) {
            console.error(`[ARGUS] Could not initialize the file transport: ${err.message}; console logging only.`);
        }

        this.#logger = winston.createLogger({
            level: config.level,
            format: logFormat,
            transports,
        });
    }

    // Methods
    banner(message) {
        this.#lastLevel = 'info';
        this.#lastStatus = message;

        const line = `[${this.#timestamp()}]-[INFO] ${message}`;
        console.log(line);

        try {
            fs.appendFileSync(
                path.join(this.#config.dir, this.#datedFilename()),
                `${line}\n`
            );
        } catch (err) {
            console.error(`[ARGUS] Could not write the startup banner to the log file: ${err.message}`);
        }
    }

    info(message) {
        this.#record('info', message);
    }

    warn(message) {
        this.#record('warn', message);
    }

    error(message) {
        this.#record('error', message);
    }

    getLastStatus() {
        return this.#lastStatus;
    }

    getLastLevel() {
        return this.#lastLevel;
    }

    async close() {
        const transports = this.#logger ? this.#logger.transports.slice() : [];

        if (transports.length === 0) {
            return;
        }

        await new Promise((resolve) => {
            const done = () => {
                let remaining = transports.length;
                for (const transport of transports) {
                    if (transport.writableFinished) {
                        remaining -= 1;
                        continue;
                    }
                    transport.once('finish', () => {
                        remaining -= 1;
                        if (remaining <= 0) {
                            resolve();
                        }
                    });
                    transport.end();
                }
                if (remaining <= 0) {
                    resolve();
                }
            };

            // the winston pipe hands each entry to a transport on a later
            // event-loop turn, so give pending writes time to propagate
            // before ending the transports (otherwise the tail of the log
            // can be lost).
            let ticks = 3;
            const flush = () => {
                ticks -= 1;
                if (ticks > 0) {
                    setImmediate(flush);
                } else {
                    done();
                }
            };
            setImmediate(flush);
        });
    }

    // Private methods
    #record(level, message) {
        this.#lastLevel = level;
        this.#lastStatus = message;

        if (!this.#logger) {
            console.log(`${level.toUpperCase()}: ${message}`);
            return;
        }

        this.#logger.log(level, message);
    }

    #datedFilename() {
        const now = new Date();
        const date = String(now.getFullYear()).padStart(4, '0') + '-' +
            String(now.getMonth() + 1).padStart(2, '0') + '-' +
            String(now.getDate()).padStart(2, '0');
        return this.#config.filename.replace('%DATE%', date);
    }

    #timestamp() {
        const timestamp = new Date();
        return String(timestamp.getFullYear()).padStart(4, '0') +
            String(timestamp.getMonth() + 1).padStart(2, '0') +
            String(timestamp.getDate()).padStart(2, '0') + '-' +
            String(timestamp.getHours()).padStart(2, '0') + ':' +
            String(timestamp.getMinutes()).padStart(2, '0') + ':' +
            String(timestamp.getSeconds()).padStart(2, '0');
    }
}