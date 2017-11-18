const amqp = require("amqplib/callback_api");
const commons = require("./commons.js");
const util = require("util");

const connection = amqp.connect(commons.AMPQ_URL, function (error, connection) {
    const channel = connection.createChannel();
    const queue = channel.assertQueue(commons.QUEUE_NAME);

    channel.sendToQueue(commons.QUEUE_NAME, new Buffer("Hello cockboys!"));
    setTimeout(function () {
        connection.close();
    }, 1000);
});
