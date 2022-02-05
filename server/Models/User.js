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
        "moderator": {
            type: Boolean,
            required: true
        },
        "verification-token": {
            type: String,
            required: true
        },
        "verified": Boolean,
        "name": {
            type:String, 
        },
        "creation-time": Number,
        "pfp-uri": String,
        "bio": String,
        "friends": [String],
        "lastpopupdate": Number
    })

module.exports = mongoose.model('UserModel', UserSchema)