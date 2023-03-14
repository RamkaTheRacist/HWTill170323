module.exports = class Router {

    constructor() {
        this.endpoints = {};
    }

    request(method, path, handler) {

        if (!this.endpoints[path]) {
            this.endpoints[path] = {};
        }

        const endpoints = this.endpoints[path];

        if (endpoints[method]) {
            throw new Error(`[${method}] in ${path} is exists already`);
        }

        endpoints[method] = handler;

    }

    get(path, handler) {
        this.request('GET', path, handler);
    }
    post(path, handler) {
        this.request('POST', path, handler);
    }
    put(path, handler) {
        this.request('PUT', path, handler);
    }
    delete(path, handler) {
        this.request('DELETE', path, handler);
    }
}