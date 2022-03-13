const mongoose = require('mongoose');

const ForumSchema = mongoose.Schema(
    {

        "poster": String,
        "title": String,
        "content": String,
        "timestamp": String,
        "likes": Number,
        "comments": [String],
        "tags": [String]
        
    })

module.exports = mongoose.model('ForumModel', ForumSchema)