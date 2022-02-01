const mongoose = require('mongoose');

const PopupAnswerSchema = mongoose.Schema(
    {

        "questionID": String,
        "answerer": String,
        "timestamp": String,
        "answer": [String]
        
    })

module.exports = mongoose.model('PopupAnswerModel', PopupAnswerSchema)