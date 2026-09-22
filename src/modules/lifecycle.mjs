import readline from 'readline';

export default class lifecycle {
    // Fields
    #logger = null;
    #closeAll = null;
    #consoleInterface = null;
    #isShuttingDown = false;

    // Constructor
    constructor({ logger, closeAll }) {
        this.#logger = logger;
        this.#closeAll = closeAll;
        this.#registerShutdownHandlers();
    }

    // Methods
    startRepl() {
        this.#logger.info('Configuring Console Controls...');

        this.#consoleInterface = readline.createInterface({
            input: process.stdin,
            output: process.stdout
        });

        // add new console commands here
        this.#consoleInterface.on('line', (input) => {
            switch (input.trim().toLowerCase()) {
                case 'status':
                    // do not use #logger to avoid overwriting latest status
                    console.log(`\nLatest server status: ${this.#logger.getLastStatus()}\n`);
                    break;
                case 'help':
                    this.#logger.info("Showing help...");

                    console.log('\nAvailable commands:\n'
                        + '  status - Show the latest server status.\n'
                        + '  help   - Show this help message.\n'
                        + '  exit   - Exit the application.\n');
                    break;
                case 'exit':
                    this.#logger.info('Exiting the application...');
                    this.shutdown(0);
                    break;
                default:
                    this.#logger.warn(`Unknown command: ${input}`);
                    break;
            }
        });
    }

    async shutdown(exitCode = 0) {
        if (this.#isShuttingDown) {
            return;
        }
        this.#isShuttingDown = true;

        if (this.#consoleInterface) {
            this.#consoleInterface.close();
        }

        try {
            if (this.#closeAll) {
                await this.#closeAll();
            }
            this.#logger.info('Server shutting down gracefully.');
            await this.#logger.close();
        } catch (err) {
            this.#logger.error(`Error during shutdown: ${err?.message ?? String(err)}`);
            exitCode = 1;
        }

        // let the event loop drain so pending log writes flush; the process
        // exits on its own with the requested code.
        process.exitCode = exitCode;
    }

    // Private methods
    #registerShutdownHandlers() {
        process.on('SIGINT', () => {
            this.#logger.warn('Received SIGINT - shutting down...');
            this.shutdown(0);
        });

        process.on('SIGTERM', () => {
            this.#logger.warn('Received SIGTERM - shutting down...');
            this.shutdown(0);
        });

        process.on('uncaughtException', (err) => {
            this.#logger.error(`Uncaught exception: ${err?.message ?? String(err)}`);
            this.shutdown(1);
        });

        process.on('unhandledRejection', (reason) => {
            const message = reason instanceof Error ? reason.message : String(reason);
            this.#logger.error(`Unhandled promise rejection: ${message}`);
            this.shutdown(1);
        });
    }
}