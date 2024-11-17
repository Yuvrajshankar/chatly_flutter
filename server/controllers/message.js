import Message from "../model/Message.js";

export const allMessages = async (req, res, next) => {
    try {
        const sender = req.user;
        const receiver = req.params.friendId;

        const messagesSentBySender = await Message.find({ sender, receiver });

        const messagesReceivedBySender = await Message.find({ sender: receiver, receiver: sender });

        const allMessages = messagesSentBySender.concat(messagesReceivedBySender).sort((a, b) => a.createdAt - b.createdAt);

        res.status(200).json(allMessages);
    } catch (error) {
        next(error);
    }
};

export const sendMessages = async (req, res, next) => {
    try {
        const sender = req.user;
        // console.log("sender: ", sender);
        const receiver = req.params.friendId;
        // console.log("receiver: ", receiver);
        const { message } = req.body;

        const newMessage = new Message({
            sender,
            receiver,
            message,
        });

        await newMessage.save();
        res.status(201).json(newMessage);
    } catch (error) {
        next(error);
    }
};