const express = require("express");
const bodyParser = require("body-parser");
const reportRoutes = require("./reportRoutes");

const app = express();
app.use(bodyParser.json());

app.use("/api/reports", reportRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT,'0.0.0.0', () => console.log(`Server running on port ${PORT}`));
