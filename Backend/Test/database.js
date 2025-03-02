const { MongoClient } = require("mongodb");

const uri = "mongodb url";
const client = new MongoClient(uri);

async function connectDB() {
    try {
        await client.connect();
        console.log("Connected to MongoDB");
        return client.db("health_tracker_database"); // Return the database object
    } catch (err) {
        console.error("Error connecting to MongoDB:", err);
    }
}

module.exports = connectDB;
