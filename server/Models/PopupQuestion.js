const mongoose = require('mongoose');

//all priority will be set to 9999 when the question's quota has been met
const PopupQuestionschema = mongoose.Schema(
    {

        "question": String,
        "priority": Number,
        "quota": Number,
        "options": [String],
        "optionQuantities": [{"option": String, "count": Number}],
        "currentAnswers": Number
        
    })

module.exports = mongoose.model('PopupQuestionModel', PopupQuestionschema)