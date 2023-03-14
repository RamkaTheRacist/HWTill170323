module.exports =  (req, res) => {
    res.writeHead(200, {
        'Content-type': 'appication/json'
    });

    res.send = (data) => {
        res.end(JSON.stringify(data));
    }
}