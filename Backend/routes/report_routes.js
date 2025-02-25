// routes/report_routes.js
const express = require('express');
const ReportAttribute = require('../model/report_attribute');  // Adjust path as needed

const router = express.Router();

// POST endpoint to store report data
router.post('/store-report', async (req, res) => {
  const { userId, reportCollectionDate, tests } = req.body;

  if (!userId || !reportCollectionDate || !tests || tests.length === 0) {
    return res.status(400).send('Missing required fields');
  }

  try {
    // Iterate through the tests array and store each test as a separate document
    for (const test of tests) {
      const newReport = new ReportAttribute({
        username: userId,
        reportCollectionDate,
        testName: test.testName,
        value: test.value,
      });

      await newReport.save();  // Save each test as a separate document
    }

    res.status(200).send('Report data stored successfully');
  } catch (error) {
    console.error('Error storing report data:', error);
    res.status(500).send('Error storing report data');
  }
});

module.exports = router;
