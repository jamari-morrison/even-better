const PopupQuestion = require('../Models/PopupQuestion');
const PopupAnswer = require('../Models/PopupAnswer');
const User = require('../Models/User')

const express = require('express');
const router = express.Router();

//input: username
//output: object telling you if you should show popup.  If so, then it contains question data
router.get('/nextQuestion', async (req, res) => {
    try{

        console.log('made it to getting next question for ' + req.query['rose-username'] )
        const unstrung = await User.findOne({'rose-username': req.query['rose-username']});
        const user = JSON.parse(JSON.stringify(unstrung))
        console.log(unstrung)
        console.log(user["lastpopupdate"])
        if(Date.now() - user['lastpopupdate'] > 172800000){
            //update the time when the user has most recently seen a popup

            
            console.log( user['_id']);

            //should update to Date.now(), but for testing im using a good number
            const updateResult = await User.updateOne({"_id": unstrung['_id']}, {lastpopupdate:Date.now()}).catch(err => {
                res.json({
                  message: err
                })
              })
            console.log(updateResult)


            //get the popup information and return it
            console.log('actually getting next question')
            const questions = await PopupQuestion.find()
        .sort('priority');
        
        for(q in questions){
            
            if(questions[q].currentAnswers < questions[q].quota)  {
                res.json({message: 'has question', question: questions[q]});
                return;
            }
        }
        
        res.json({message: 'has question', questions: questions});
        return;
        }
        res.json({message: 'no question'});
        
    } catch(err){
        console.log(err)
        res.json({message: "Error!"})
    }
})

//expects answer object that is
/**
 * {answer: [selections], questionID: '', answerer: ''}
 */
router.post('/answer', async (req, res) => {
    try{
        // const updateResult = await PopupQuestion.findOneAndUpdate({"_id": req.aborted.questionID}, {$inc: {'currentAnswers':1}}).catch(err => {
        //     res.json({
        //       message: err
        //     })
        //   })
        // console.log(updateResult)

        const question = await PopupQuestion.findOne({"_id": req.body.questionID}).catch(err => {
            res.json({
              message: err
            })
          })
        console.log(question)

        if(question.quota <= 1+question.currentAnswers){

            //quota is filled
            console.log('filled quota')
            console.log
            const updateResult = await PopupQuestion.updateOne({"_id": req.body.questionID}, {currentAnswers:question.currentAnswers+1, priority:9999}).catch(err => {
                res.json({
                  message: err
                })
              })
            console.log(updateResult)
        }else{

            //quota isn't filled
            console.log('not yet filled quota')
            const updateResult = await PopupQuestion.updateOne({"_id": req.body.questionID}, {currentAnswers:question.currentAnswers+1}).catch(err => {
                res.json({
                  message: err
                })
              })
            console.log(updateResult)
        }

        const newAnswer = new PopupAnswer(
            {questionID: req.body.questionID,
            answerer: req.body.answerer,
            timestamp: Date.now(),
            answer: JSON.parse(req.body.answer)
            }

        );
            console.log(newAnswer)
        newAnswer.save()
        .then(data => {
          res.json(data);
        })
        .catch(err => {
          res.json({
            message: err
          })
        })
    } catch(err){
        console.log(err);
        res.json({message: "Error!"})
    }
})

router.get('/allQuestions', async (req, res) => {
    try{
        console.log('made it to getting all questions')
        const questions = await PopupQuestion.find();

        res.json(questions);
    } catch(err){
        res.json({message: "Error!"})
    }
})

router.get('/allAnswers', async (req, res) => {
    try{
        console.log('made it to getting all answers')
        const answers = await PopupAnswer.find();

        res.json(answers);
    } catch(err){
        res.json({message: "Error!"})
    }
})




module.exports = router;