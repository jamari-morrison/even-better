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
        "name": {
            type: String,
            // required:true
        },
        "companyname": {
            type: String,
            // required:true
            default: "N/A"
        },
        "avatar": {
            type: String,
            default: "N/A"
        },
        "verification-token": {
            type: String,
            required: true
        },
        "verified": Boolean,
        "creation-time": Number,
        "pfp-uri": String,
        "bio": {
            type: String,
            default: "N/A"
        },
        "friends": [String],
        // "friendscount":Int32Array,
        "lastpopupdate": Number,
        "cs": {
            type: Boolean,
            default: false
        },

        "se": {
            type: Boolean,
            default: false
        },


        "ds": {
            type: Boolean,
            default: false
        },

    })

module.exports = mongoose.model('UserModel', UserSchema)