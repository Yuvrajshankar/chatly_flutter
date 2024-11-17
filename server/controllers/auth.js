import User from "../model/User.js";
import jwt from "jsonwebtoken";
import bcrypt from "bcryptjs";
import { ObjectId } from "mongodb";

// REGISTER
export const register = async (req, res, next) => {
    try {
        const { profileImage, userName, email, password } = req.body;

        if (!profileImage || !userName || !email || !password) {
            res.status(400);
            throw new Error("All fields are required.");
        }

        // Check if email or username already exists
        const emailExists = await User.findOne({ email });
        const nameExists = await User.findOne({ userName });

        if (emailExists) {
            res.status(400);
            throw new Error("Email already exists");
        }
        if (nameExists) {
            res.status(400);
            throw new Error("Username already exists");
        }

        // Secure password
        const salt = await bcrypt.genSalt();
        const passwordHash = await bcrypt.hash(password, salt);

        // Create a new user with the profile image URL
        const user = await User.create({
            userName,
            email,
            password: passwordHash,
            profileImage,
        });

        const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET);

        res.json({
            token,
            _id: user._id,
            profileImage: user.profileImage,
            userName: user.userName,
            email: user.email,
            password: user.password,
            friends: user.friends,
        });
    } catch (error) {
        next(error);
    }
};

// LOGIN
export const login = async (req, res, next) => {
    try {
        const { email, password } = req.body;

        const user = await User.findOne({ email: email });
        if (!user) {
            return res.status(400).json({ msg: "User does not exist." });
        }

        const isPasswordValid = await bcrypt.compare(password, user.password);
        if (!isPasswordValid) {
            return res.status(400).json({ msg: "Invalid Password." });
        }

        const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET);
        res.json({ token, ...user._doc });
    } catch (error) {
        next(error);
    }
};

// UPDATE
export const update = async (req, res, next) => {
    try {
        const user = await User.findById(req.user);
        const { profileImage, userName, email, password } = req.body;

        if (!user) {
            return res.status(400).json({ msg: "User not found." });
        }

        user.userName = userName || user.userName;
        user.email = email || user.email;
        user.profileImage = profileImage || user.profileImage;

        if (password) {
            const salt = await bcrypt.genSalt();
            const passwordHash = await bcrypt.hash(password, salt);
            user.password = passwordHash
        }

        await user.save();

        res.status(200).json({ msg: 'profile updated successfully', user });
    } catch (error) {
        next(error);
    }
};

// AUTH-CHECK
export const authCheck = async (req, res, next) => {
    try {
        const token = req.header("x-auth-token");
        if (!token) return res.json(false);

        const verified = jwt.verify(token, process.env.JWT_SECRET);
        if (!verified) return res.json(false);

        const user = await User.findById(verified.id);
        if (!user) return res.json(false);
        res.json(true);
    } catch (error) {
        next(error);
    }
};

// GET USER DETAILS
export const getUserDetails = async (req, res, next) => {
    try {
        const user = await User.findById(req.user);
        res.json({ ...user._doc, token: req.token });
    } catch (error) {
        next(error);
    }
};

// ADD-REMOVE FRIEND
export const addRemoveFriend = async (req, res, next) => {
    try {
        const user = await User.findById(req.user);
        const friend = await User.findById(req.params.friendId);

        if (!user || !friend) {
            return res.status(400).json({ message: "User or friend not found" });
        }

        //convert friendId to ObjectId if it's not already
        const friendObjectId = ObjectId.isValid(friend) ? new ObjectId(friend) : friend;

        if (user.friends.includes(friendObjectId.toString())) {
            user.friends = user.friends.filter(id => id.toString() !== friendObjectId.toString());
            friend.friends = friend.friends.filter(id => id.toString() !== user._id.toString());
        } else {
            user.friends.push(friendObjectId);
            friend.friends.push(user._id);
        }

        await user.save();
        await friend.save();

        const friendDetails = {
            _id: friend._id,
            userName: friend.userName,
            profileImage: friend.profileImage,
            email: friend.email,
        };

        res.status(200).json({ friendDetails });
    } catch (error) {
        next(error);
    }
};

// GET ALL FRIENDS
export const getAllFriends = async (req, res, next) => {
    try {
        const user = await User.findById(req.user);

        const friends = await Promise.all(
            user.friends.map((id) => User.findById(id))
        );

        const formattedFriends = friends.map(
            ({ _id, userName, profileImage, email }) => {
                return { _id, userName, profileImage, email };
            }
        );

        res.status(200).json(formattedFriends);
    } catch (error) {
        next(error);
    }
};

// SEARCH FOR FRIEND
export const searchUser = async (req, res, next) => {
    try {
        const { userName: searchUserName } = req.query;

        if (!searchUserName) {
            return res.status(400).json({ msg: "Please provide a userName to search for." });
        }

        // Get the current user and populate their friends
        const currentUser = await User.findById(req.user).populate('friends', '_id userName');
        // console.log("currentUser: ", currentUser);

        // Can't search for yourself
        if (currentUser.userName === searchUserName) {
            return res.status(400).json({ msg: "It's you!" });
        }

        // user not found
        const user = await User.findOne({ userName: searchUserName });
        if (!user) {
            return res.status(404).json({ msg: "User not found." });
        }


        // Check if the searched user is already a friend
        const isAlreadyFriend = currentUser.friends.some(friend => friend._id.toString() === user._id.toString());
        // console.log("isAlreadyFriend: ", isAlreadyFriend);
        if (isAlreadyFriend) {
            return res.status(400).json({ msg: "This user is already your friend." });
        }

        // Return the searched user's details
        const { _id, userName, email, profileImage } = user;
        res.status(200).json({ _id, userName, email, profileImage });
    } catch (error) {
        next(error);
    }
};