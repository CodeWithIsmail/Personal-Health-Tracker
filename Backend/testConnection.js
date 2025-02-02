require("dotenv").config();
const mongoose = require("mongoose");

async function testConnection() {
  try {
    await mongoose.connect(process.env.MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });
    console.log("✅ MongoDB Connected Successfully!");
    mongoose.connection.close(); // Close connection after testing
  } catch (error) {
    console.error("❌ MongoDB Connection Error:", error);
  }
}

testConnection();
