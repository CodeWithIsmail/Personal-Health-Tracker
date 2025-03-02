const express = require("express");
const router = express.Router();
const connectDB = require("./database");
const e = require("express");

router.post("/addReportAttribute", async (req, res) => {
    const { testName, value, userName, date } = req.body; // Get data from the request

    if (!testName || !value || !userName || !date) {
        return res.status(400).json({ message: "Missing required fields" });
    }

    try {
        const collectionName = 'report_attributes';
        const db = await connectDB();
        const collection = db.collection(collectionName);

        const reportDate = new Date(date);

        const newAttribute = {
            username: userName,
            reportCollectionDate: reportDate,
            testName: testName,
            value: value
        };

        const result = await collection.insertOne(newAttribute);

        res.status(201).json({ message: "Report attribute added", data: result });
    } catch (err) {
        res.status(500).json({ message: "Error adding report attribute", error: err });
    }
});

router.get("/getReportAttributes", async (req, res) => {
    try {
        const { username, testName, startDate, endDate } = req.query; // Get query params

        if (!username || !testName) {
            return res.status(400).json({ message: "Username and Test Name are required" });
        }

        const db = await connectDB();
        const collection = db.collection("report_attributes");

        // Build the query filter
        let query = { username, testName };

        console.log(startDate + endDate);

        if (startDate && endDate) {

            const start = new Date(`${startDate}Z`); // Force UTC by appending 'Z'
            const end = new Date(`${endDate}Z`);     // Force UTC by appending 'Z'

            console.log("Start Date (UTC):", start.toISOString());
            console.log("End Date (UTC):", end.toISOString());

            if (isNaN(start) || isNaN(end)) {
                return res.status(400).json({ message: "Invalid date format" });
            }


            query.reportCollectionDate = {
                $gte: start,
                $lte: end
            };
        }

        // Fetch the results
        const userAttributes = await collection.find(query).toArray();

        res.status(200).json({ message: "Report attributes fetched", data: userAttributes });
    } catch (err) {
        res.status(500).json({ message: "Error fetching report attributes", error: err.message });
    }
});

router.post("/addReportSummary", async (req, res) => {
    console.log("Received request to add report summary");
    
    const { userName , imgLink , summary } = req.body; // Get data from the request

    if (!userName) {
        return res.status(400).json({ message: "Missing required fields" });
    }

    try {
        const collectionName = 'report_summary';
        const db = await connectDB();
        const collection = db.collection(collectionName);

        const newAttribute = {
            'username': userName,
            'date': Date.now(),
            'image': imgLink,
            'summary': summary,
            'viewer': [],
        };

        const result = await collection.insertOne(newAttribute);

        res.status(201).json({ message: "Report summary added", data: result });
    } catch (err) {
        res.status(500).json({ message: "Error adding summary", error: err });
    }
});



module.exports = router;
