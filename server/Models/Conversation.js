const mongoose = require('mongoose');

const ConversationSchema = mongoose.Schema(
    {
    "users" : [String],
    "messages":
        [
            { 
                "sender" : {type: String, required: true},
                "text" : {type: String, required: true},
                "timestamp" : {type: Number, required: true}
            }
        ]
    }

)

module.exports = mongoose.model('ConversationModel', ConversationSchema);