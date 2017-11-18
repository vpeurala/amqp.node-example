const amqp = require("amqplib/callback_api");
const commons = require("./commons.js");
const util = require("util");

const connection = amqp.connect(commons.AMPQ_URL, function (error, connection) {
    const channel = connection.createChannel();
    const queue = channel.assertQueue(commons.QUEUE_NAME);

    channel.consume(commons.QUEUE_NAME, function (message) {
        console.log("Received message from bork: " + message);
    });
});
