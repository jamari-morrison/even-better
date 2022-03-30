const mongoose = require('mongoose');

const PostCommentSchema = mongoose.Schema(
    {
        "commenter": String,
        "content": String,
        "timestamp": String,
        "parent-id": String,
        "likes": Number,
        
    })

module.exports = mongoose.model('PostCommentModel', PostCommentSchema)