const http = require('http');
const EvenEmitter = require('events');

class Application {

    constructor() {
        this.emitter = new EvenEmitter();
        this.server = this._createSever();
        this.middlewares = [];
    }

    use(middleware) {
        this.middlewares.push(middleware);
    }

    listen(port, callback) {
        this.server.listen(port, callback);
    }

    addRouter(router) {
        Object.keys(router.endpoints).forEach(path => {
            const endpoint = router.endpoints[path];
            Object.keys(endpoint).forEach((method) => {

                this.emitter.on(this._getRouteMask(path, method), (req, res) => {
                    const handler = endpoint[method];
                    
                    handler(req, res);
                })
            })
        })
    }

    _createSever() {
        return http.createServer((req, res) => {
            let body = "";

            req.on('data', (chunk) => {
                body += chunk;
            });

            req.on('end', () => {
                if (body) {
                    req.body = JSON.parse(body);
                }
                this.middlewares.forEach(middleware => middleware(req, res));
                const emitted = this.emitter.emit(this._getRouteMask(req.pathname, req.method), req, res);

                if (!emitted) {
                    res.end('Unknonw page');
                }
            });
        })
    }
    _getRouteMask(path, method) {
        return `[${path}]:[${method}]`;
    }
}

module.exports = new Application();