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
    const newReport = new ReportAttribute({
      username: userId,
      reportCollectionDate,
      tests,
    });

    await newReport.save();
    res.status(200).send('Report data stored successfully');
  } catch (error) {
    console.error('Error storing report data:', error);
    res.status(500).send('Error storing report data');
  }
});


// GET endpoint to fetch report data (use query parameters to filter by username, date range, etc.)
router.get('/fetch-report', async (req, res) => {
  const { username, testName, startDate, endDate } = req.query;
  
  let query = { username };

  // Build the query based on other params
  if (testName) query.testName = testName;
  if (startDate && endDate) {
    query.date = { $gte: new Date(startDate), $lte: new Date(endDate) };
  }

  try {
    const reports = await ReportAttribute.find(query);
    res.status(200).json(reports);
  } catch (error) {
    console.error('Error fetching report data:', error);
    res.status(500).send('Error fetching report data');
  }
});

module.exports = router;
