const mongoose = require('mongoose');

const ForumSchema = mongoose.Schema(
    {

        "poster": String,
        "posterID": String,
        "title": String,
        "content": String,
        "timestamp": String,
        "likes": Number,
        "tags": [String]
        
    })

module.exports = mongoose.model('ForumModel', ForumSchema)