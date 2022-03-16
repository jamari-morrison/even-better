const mongoose = require('mongoose');

const NotificationSchema = mongoose.Schema(
    {

        "text": String,
        "years": [Number],
        "timestamp": String,
        "majors": [String]
        
    })

module.exports = mongoose.model('NotificationModel', NotificationSchema)