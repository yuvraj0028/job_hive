require("../db/mongoose");
const express = require("express");
const User = require("../models/user-schema-methods");
const auth = require("../middleware/auth");

const router = new express.Router();

// create a new user
router.post("/users", async (req, res) => {
  const user = new User(req.body);
  try {
    // generate auth token
    const token = await user.generateAuthToken();
    // save user to database
    await user.save();
    res.send({ user, token });
  } catch (error) {
    console.log(error);
    // send error response
    res.status(400).send({
      error: error.message,
    });
  }
});

// login user with credentials
router.post("/users/login", async (req, res) => {
  try {
    const user = await User.findByCredentials(
      req.body.email,
      req.body.password
    );
    // generate auth token
    const token = await user.generateAuthToken();
    return res.send({ user, token });
  } catch (error) {
    // send error response
    res.status(400).send({ error: error.message });
  }
});

// get current logged in user details
router.get("/users/me", auth, async (req, res) => {
  res.send(req.user);
});

// update user details
router.patch("/users/me", auth, async (req, res) => {
  const updates = Object.keys(req.body);
  const allowedUpdates = [
    "name",
    "age",
    "about",
    "profession",
    "experience",
    "education",
    "achievement",
    "skills",
    "project",
    "languages",
  ];

  const isValidOperation = updates.every((update) =>
    allowedUpdates.includes(update)
  );

  if (!isValidOperation) {
    return res.status(400).send({ error: "Invalid updates!" });
  }

  try {
    updates.forEach((update) => {
      if (
        update === "experience" ||
        update === "education" ||
        update === "achievement" ||
        update === "project" ||
        update === "languages" ||
        update === "skills"
      ) {
        req.user[update].push(req.body[update]);
      } else {
        req.user[update] = req.body[update];
      }
    });
    await req.user.save();
    res.send(req.user);
  } catch (error) {
    res.status(400).send(error);
  }
});

// delete user details
router.delete("/users/me", auth, async (req, res) => {
  const deletedData = Object.keys(req.body);
  const allowedDeletion = [
    "experience",
    "education",
    "achievement",
    "project",
    "languages",
    "skills",
    "about",
    "profession",
  ];

  const isValidOperation = deletedData.every((data) =>
    allowedDeletion.includes(data)
  );

  if (!isValidOperation) {
    return res.status(400).send({ error: "Invalid deletion!" });
  }

  try {
    deletedData.forEach((data) => {
      if (
        data === "experience" ||
        data === "education" ||
        data === "achievement" ||
        data === "project"
      ) {
        req.user[data] = req.user[data].filter(
          (item) => item._id.toString() !== req.body[data]._id.toString()
        );
      } else if (data === "languages" || data === "skills") {
        req.user[data] = req.user[data].filter(
          (item) => item.toString() !== req.body[data].toString()
        );
      } else {
        req.user[data] = "";
      }
    });
    await req.user.save();
    res.send(req.user);
  } catch (error) {
    res.status(400).send(error);
  }
});

// find user by id
router.get("/users/:id", async (req, res) => {
  const _id = req.params.id;

  try {
    const user = await User.findById(_id);

    if (!user) {
      return res.status(404).send();
    }

    res.send(user);
  } catch (error) {
    res.status(500).send(error);
  }
});

module.exports = router;
