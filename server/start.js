const server = require('./testAp');
server.listen(3306, (req, res) => {
    console.log("listen at 3306!");
});