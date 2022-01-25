const mongoose = require('mongoose');

const PostSchema = mongoose.Schema(
    {

        "title": String,
        "description": String,
        "picture-uri": {
            type: String,
            required: true,
        },
        "likes": Number,
        "poster": String,
        "timestamp": String
    })

module.exports = mongoose.model('PostModel', PostSchema)