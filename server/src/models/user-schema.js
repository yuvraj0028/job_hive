const validator = require("validator");
const mongoose = require("mongoose");

// initialize user schema
const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
  },
  email: {
    type: String,
    unique: true,
    required: true,
    trim: true,
    lowercase: true,
    validate(value) {
      if (!validator.isEmail(value)) {
        throw new Error("Email is invalid");
      }
    },
  },
  age: {
    type: Number,
    default: 0,
    validate(value) {
      if (value < 0) {
        throw new Error("Age must be a positive number");
      }
    },
  },
  about: {
    type: String,
    trim: true,
    default: "",
  },
  profession: {
    type: String,
    trim: true,
    default: "",
  },
  experience: {
    type: [
      {
        company: {
          type: String,
          required: true,
          trim: true,
        },
        position: {
          type: String,
          required: true,
          trim: true,
        },
        description: {
          type: String,
          required: true,
          trim: true,
        },
      },
    ],
  },
  education: {
    type: [
      {
        institute: {
          type: String,
          required: true,
          trim: true,
        },
        degree: {
          type: String,
          required: true,
          trim: true,
        },
      },
    ],
  },
  achievement: {
    type: [
      {
        title: {
          type: String,
          required: true,
          trim: true,
        },
        description: {
          type: String,
          required: true,
          trim: true,
        },
      },
    ],
  },
  skills: {
    type: [],
  },
  project: {
    type: [
      {
        title: {
          type: String,
          required: true,
          trim: true,
        },
        description: {
          type: String,
          required: true,
          trim: true,
        },
      },
    ],
  },
  languages: {
    type: [String],
  },
  password: {
    type: String,
    required: true,
    trim: true,
    minlength: 8,
    validate(value) {
      const regex = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$/gm;
      if (!regex.test(value)) {
        throw new Error(
          "Password must contain at least 8 characters, 1 uppercase letter, 1 lowercase letter and 1 number"
        );
      }

      if (value.toLowerCase().includes("password")) {
        throw new Error("Password cannot contain 'password'");
      }

      if (value.toLowerCase().includes("12345678")) {
        throw new Error("Password cannot contain '12345678'");
      }
    },
  },
  tokens: [
    {
      token: {
        type: String,
        required: true,
      },
    },
  ],
});

module.exports = userSchema;
