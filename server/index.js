// IMPORTS
import express from "express";
import dotenv from "dotenv";
import cors from "cors";
import { createServer } from "http";
import { Server } from "socket.io";
import connectDB from "./db/Connection.js";
import { errorHandler } from "./middlewares/errorHandler.js";
import authRoutes from "./routes/auth.js";
import messageRoutes from "./routes/message.js";

// CONFIGURATION
dotenv.config();
const app = express();
const httpServer = createServer(app);
const io = new Server(httpServer);

// MIDDLEWARES
app.use(express.json());
app.use(cors());

// ROUTES
app.use(errorHandler);

/* auth */
app.use("/auth", authRoutes);

/* message */
app.use("/message", messageRoutes);

// LISTEN
const PORT = process.env.PORT || 5846;

httpServer.listen(PORT, () => {
    console.log(`Server Started on ${PORT}`);
    connectDB();
});

// Socket.Io
io.on("connection", (socket) => {
    console.log("Connected to socket.io");
    socket.on("setup", (user) => {
        socket.join(user._id);
        socket.emit("connected");
        console.log("Connected: +", user._id);
    });

    socket.on("receiver user", (room) => {
        socket.join(room);
        console.log("Receiver User: " + room);
    });


    socket.on("new message", async (newMessageReceived) => {
        try {
            const sender = newMessageReceived.sender;
            const receiver = newMessageReceived.receiver;
            const messageContent = newMessageReceived.message;

            // Emit the new message to both sender and receiver rooms
            io.to(sender).emit("message received", newMessageReceived);
            io.to(receiver).emit("message received", newMessageReceived);

            // console.log("New message sent:", newMessageReceived);
        } catch (error) {
            console.error("Error sending new message:", error);
        }
    });


    socket.off("setup", () => {
        console.log("USER DISCONNECTED");
        socket.leave(user._id);
    });
});