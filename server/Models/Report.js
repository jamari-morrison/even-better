const mongoose = require('mongoose');

const ReportSchema = mongoose.Schema(
    {

        "content-type": {
            type: String,
            required: true,
        },
        "reason": String,
        "timestamp": {
            type: String,
            required: true
        },
        "reporter": {
            type: String
        }
    })

module.exports = mongoose.model('ReportModel', ReportSchema)