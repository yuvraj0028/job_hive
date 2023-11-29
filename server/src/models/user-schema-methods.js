const mongoose = require("mongoose");
const validator = require("validator");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const userSchema = require("./user-schema");

// generate auth token
userSchema.methods.generateAuthToken = async function () {
  const user = this;

  const token = jwt.sign({ _id: user._id.toString() }, "jobhive");

  user.tokens = user.tokens.concat({ token });

  await user.save();

  return token;
};

// hash user password
userSchema.pre("save", async function (next) {
  const user = this;

  if (user.isModified("password")) {
    user.password = await bcrypt.hash(user.password, 8);
  }
  next();
});

// find user by credentials
userSchema.statics.findByCredentials = async (email, password) => {
  const user = await User.findOne({ email });

  if (!user) {
    throw new Error("No user found");
  }

  const isMatch = await bcrypt.compare(password, user.password);

  if (!isMatch) {
    throw new Error("Incorrect password");
  }

  return user;
};

// return user object without password and tokens
userSchema.methods.toJSON = function () {
  const user = this;

  const userObj = user.toObject();

  delete userObj.tokens;
  delete userObj.password;

  return userObj;
};

userSchema.virtual("jobs", {
  ref: "Job",
  localField: "_id",
  foreignField: "owner",
});

// initialize user model for mongoose
const User = mongoose.model("User", userSchema);

module.exports = User;
