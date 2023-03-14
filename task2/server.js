const app = require('./src/Application');
const ownRouters = require('./src/ownRouters');
const jsonParse = require('./src/parseJson');
const parseUrl = require('./src/parseUrl');

const PORT = 80;
const callback = () => console.log('server started');

app.use(jsonParse);
app.use(parseUrl('http://localhost:80'));
app.addRouter(ownRouters);

const start = async () => {
    try {
        app.listen(PORT, callback);
    } catch (error) {
        console.log(error);
    }
}

start();