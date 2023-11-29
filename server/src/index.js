require("./db/mongoose");
const express = require("express");
const userRouter = require("./router/user");
const jobRouter = require("./router/job");

// initialize express
const app = express();
// initialize port
const port = process.env.PORT || 3000;

// parse incoming json to object
app.use(express.json());

// use user router
app.use(userRouter);

// use job router
app.use(jobRouter);

// listen to port
app.listen(port, () => {
  console.log(`Server is up on port ${port}`);
});
