const mongoose = require('mongoose');

const ReportAttributeSchema = new mongoose.Schema({
  username: { type: String, required: true },
  reportCollectionDate: { type: Date, required: true },
  tests: [{
    testName: { type: String, required: true },
    value: { type: Number, required: true }
  }]
});

module.exports = mongoose.model('ReportAttribute', ReportAttributeSchema);
