const mongoose = require('mongoose');

const CommentSchema = mongoose.Schema(
    {
        "commentername": String,
<<<<<<< HEAD
        "commenter": {
            type: String,
            required: true
        },
=======
        "commenter": {type: String, required: true},
>>>>>>> fcf0858b83e49b66356741bdf7619cd738123e9d
        "content": String,
        "timestamp": String,
        "parent-id": String,
        "likes": Number,
        
    })

module.exports = mongoose.model('CommentModel', CommentSchema)