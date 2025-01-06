import jwt from "jsonwebtoken";
import User from "../model/User.js";

export const verifyToken = async (req, res, next) => {
    const token = req.header("x-auth-token");

    if (!token) {
        return res.status(401).json({ error: "Not authorized, no token provided." });
    }

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = await User.findById(decoded.id).select('-password');

        if (!req.user) {
            return res.status(404).json({ error: "User not found" });
        }

        req.token = token;

        next();
    } catch (err) {
        console.error(err.message);
        res.status(401).json({ error: 'Not authorized, invalid or expired token' });
    }
};