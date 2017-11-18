const amqp = require("amqplib");
const util = require("util");

amqp.connect("amqp://localhost").then(function(connection) {
    console.log("util.inspect(connection): " + util.inspect(connection));
    console.log("Object.getOwnPropertyNames(connection): " + Object.getOwnPropertyNames(connection));
    connection.close()
}, function(error) {
    console.log("error: " + util.inspect(error));
});
