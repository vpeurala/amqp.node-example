const amqp = require("amqplib/callback_api");
const util = require("util");

const connection = amqp.connect("amqp://localhost", function (error, connection) {
    const channel = connection.createChannel();
    const queue = channel.assertQueue("bork");

    channel.consume("bork", function (message) {
        console.log("Received message from bork: " + message);
    });
});
