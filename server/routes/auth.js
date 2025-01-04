import express from "express";
import { addRemoveFriend, authCheck, getAllFriends, getUserDetails, login, register, searchForFriends, update } from "../controllers/auth.js";
import { verifyToken } from "../middlewares/verifyToken.js";

const router = express.Router();

router.post("/register", register);
router.post("/login", login);
router.patch("/update", verifyToken, update);
router.get("/already", verifyToken, authCheck);
router.get("/user", verifyToken, getUserDetails);
router.get("/friends", verifyToken, getAllFriends);
router.patch("/:friendId", verifyToken, addRemoveFriend);
router.get("/search", verifyToken, searchForFriends);

export default router;