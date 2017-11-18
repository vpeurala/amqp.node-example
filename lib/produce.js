const amqp = require("amqplib/callback_api");
const util = require("util");

const connection = amqp.connect("amqp://localhost", function (error, connection) {
    const channel = connection.createChannel();
    const queue = channel.assertQueue("bork");

    channel.sendToQueue("bork", new Buffer("Hello cockboys!"));
    // connection.close();
});
