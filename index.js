const amqp = require("amqplib");
const util = require("util");

amqp.connect("amqp://localhost").then(function (connection) {
    console.log("util.inspect(connection): " + util.inspect(connection));
    console.log("Object.getOwnPropertyNames(connection): " + Object.getOwnPropertyNames(connection));
    return connection.createChannel();
}, function (error) {
    console.log("error: " + util.inspect(error));
}).then(function (channel) {
    console.log("util.inspect(channel): " + util.inspect(channel));
    return channel.assertQueue("bork");
}).then(function (queue) {
    console.log("util.inspect(queue): " + util.inspect(queue));
});