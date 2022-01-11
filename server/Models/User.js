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
        "verification-token": String,
        "verified": Boolean,
        "creation-time": Number,
        "pfp-uri": String,
        "bio": String,
        "friends": [String],
    })

module.exports = mongoose.model('UserModel', UserSchema)