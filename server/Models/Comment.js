const mongoose = require('mongoose');

const CommentSchema = mongoose.Schema(
    {
        "commentername": String,
        "commenter": {type: String, required: true},
        "content": String,
        "timestamp": String,
        "parent-id": String,
        "likes": Number,
        
    })

module.exports = mongoose.model('CommentModel', CommentSchema)