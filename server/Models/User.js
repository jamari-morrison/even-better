const mongoose = require('mongoose');

const UserSchema = mongoose.Schema(
    {
        "username": {
            type: String,
        },
        "rose-username": {
            type: String,
            required: true
        },
        "verification-token": {
            type: String,
            required: true
        },
        "verified": Boolean,
        "name": {
            type:String, 
            required: true
        },
        "creation-time": Number,
        "pfp-uri": String,
        "bio": String,
        "friends": [String],
    })

module.exports = mongoose.model('UserModel', UserSchema)