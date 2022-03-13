// const mongoose = require('mongoose');

// const UserSchema = mongoose.Schema(
//     {
//         "username": {
//             type: String,
//         },
//         "rose-username": {
//             type: String,
//             required: true
//         },
//         "moderator": {
//             type: Boolean,
//             required: true
//         },
//         "name":{
//             type:String,
//             // required:true
//         },
//         "companyname":{
//             type:String,
//             // required:true
//             default: "N/A"
//         },
//         "avatar":{
//             type:String,
//         },
//         following: [
//             {
//                 user:{ 
//                     type: mongoose.Schema.ObjectId, 
//                     ref: 'User' 
//                 },
//             }
    
//         ],
//         followers: [
//             {
//                 user:{ 
//                     type: mongoose.Schema.ObjectId, 
//                     ref: 'User' 
//                 },
//             }
//         ],
//         "verification-token": {
//             type: String,
//             required: true
//         },
//         "verified": Boolean,
//         "creation-time": Number,
//         "pfp-uri": String,
//         "bio": String,
//         "friends": [String],
//         "lastpopupdate": Number,
//         "cs":Boolean,

//         "se":Boolean,

//         "ds":Boolean,
//     })

// module.exports = mongoose.model('UserModel', UserSchema)