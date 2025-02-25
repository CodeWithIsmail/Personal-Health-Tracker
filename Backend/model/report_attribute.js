const mongoose = require('mongoose');

// const ReportAttributeSchema = new mongoose.Schema({
//   username: { type: String, required: true },
//   reportCollectionDate: { type: Date, required: true },
//   tests: [{
//     testName: { type: String, required: true },
//     value: { type: Number, required: true }
//   }]
// });

const ReportAttributeSchema = new mongoose.Schema({
  username: { type: String, required: true },
  reportCollectionDate: { type: Date, required: true },
  testName: { type: String, required: true },  // Add testName field
  value: { type: Number, required: true },  // Add value field
});

module.exports = mongoose.model('ReportAttribute', ReportAttributeSchema);
