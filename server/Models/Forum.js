const mongoose = require('mongoose');

const ForumSchema = mongoose.Schema(
    {

        "poster": String,
        "title": String,
        "content": String,
        "timestamp": String,
        "likes": Number,
        "tags": [String]
        
    })

module.exports = mongoose.model('ForumModel', ForumSchema)