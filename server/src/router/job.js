const Job = require("../models/job");
const auth = require("../middleware/auth");
const express = require("express");

const router = new express.Router();

// create a new job
router.post("/jobs", auth, async (req, res) => {
  const job = new Job({
    ...req.body,
    owner: req.user._id,
  });
  try {
    await job.save();
    res.status(201).send(job);
  } catch (error) {
    res.status(400).send(error);
  }
});

// get all jobs
router.get("/jobs", async (req, res) => {
  try {
    const jobs = await Job.find({});
    res.send(jobs);
  } catch (error) {
    res.status(500).send();
  }
});

// get job by id
router.get("/jobs/:id", async (req, res) => {
  const _id = req.params.id;
  try {
    const job = await Job.findOne({ _id });
    if (!job) {
      return res.status(404).send();
    }
    res.send(job);
  } catch (error) {
    res.status(500).send();
  }
});

// find user specific job
router.get("/job/me", auth, async (req, res) => {
  try {
    await req.user.populate("jobs");
    res.send(req.user.jobs);
  } catch (error) {
    res.status(500).send();
  }
});

// update job by id
router.patch("/jobs/:id", async (req, res) => {
  const _id = req.params.id;
  try {
    const job = await Job.findOne({ _id });
    if (!job) {
      return res.status(404).send();
    }

    const containApplicant = job.applicants.includes(req.body.applicants);

    if (containApplicant) {
      return res.status(400).send({ error: "Applicant already exists" });
    }

    job.applicants = job.applicants.concat(req.body.applicants);

    await job.save();
    res.send(job);
  } catch (error) {
    res.status(400).send(error);
  }
});

// find job by name
router.get("/jobs/find/:name", async (req, res) => {
  const name = req.params.name;
  try {
    const jobs = await Job.find({
      title: new RegExp("^" + name + "|" + name + "$", "i"),
    });
    if (!jobs) {
      return res.status(404).send();
    }
    res.send(jobs);
  } catch (error) {
    res.status(500).send();
  }
});

// delete job by id
router.delete("/jobs/:id", auth, async (req, res) => {
  const _id = req.params.id;
  try {
    const job = await Job.findOneAndDelete({ _id, owner: req.user._id });
    if (!job) {
      return res.status(404).send();
    }
    res.send(job);
  } catch (error) {
    res.status(500).send();
  }
});

// update job status by id
router.patch("/jobs/status/:id", auth, async (req, res) => {
  const _id = req.params.id;
  try {
    const job = await Job.findOne({ _id, owner: req.user._id });
    if (!job) {
      return res.status(404).send();
    }
    job.closed = req.body.closed;
    await job.save();
    res.send(job);
  } catch (error) {
    res.status(400).send(error);
  }
});

module.exports = router;
