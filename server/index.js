// IMPORTS
import express from "express";
import dotenv from "dotenv";
import cors from "cors";
import { createServer } from "http";
import { Server } from "socket.io";
import connectDB from "./db/Connection.js";
import { errorHandler } from "./middleware/errorHandler.js";
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
    console.log(`Server started on ${PORT}`);
    connectDB();
});