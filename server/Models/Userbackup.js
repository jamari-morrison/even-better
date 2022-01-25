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
        "name":{
            type:String,
            // required:true
        },
        companyname:{
            type:String,
            // required:true
        },
        "avatar":{
            type:String,
        },
        following: [
            {
                user:{ 
                    type: Schema.ObjectId, 
                    ref: 'User' 
                },
            }
    
        ],
        followers: [
            {
                user:{ 
                    type: Schema.ObjectId, 
                    ref: 'User' 
                },
            }
        ],
        "verification-token": String,
        "verified": Boolean,
        "creation-time": Number,
        "pfp-uri": String,
        "bio": String,
        "cs":Boolean,
        "se":Boolean,
        "ds":Boolean,
        friends: [String],
    })

// module.exports = mongoose.model('UserModel', UserSchema)
module.exports = mongoose.model("User", UserSchema);