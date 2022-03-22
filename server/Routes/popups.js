const PopupQuestion = require('../Models/PopupQuestion');
const PopupAnswer = require('../Models/PopupAnswer');
const User = require('../Models/User')

const express = require('express');
const router = express.Router();

//input: username
//output: object telling you if you should show popup.  If so, then it contains question data
router.get('/shouldQuestion', async (req, res) => {
  try{
    console.log('made it to getting next question for ' + req.query['rose-username'] )
    const unstrung = await User.findOne({'rose-username': req.query['rose-username']});
    const user = JSON.parse(JSON.stringify(unstrung))
    console.log(unstrung)
    console.log(user["lastpopupdate"])
    if(Date.now() - user['lastpopupdate'] > 172800000){
        res.json({message: 'true'})
    }else{
      res.json({message: 'false'})
    }

  }
  catch(err){
    console.log(err)
    res.json({message: "Error!"})
}
})

router.get('/nextQuestion', async (req, res) => {
    try{

        console.log('made it to getting next question for ' + req.query['rose-username'] )
        const unstrung = await User.findOne({'rose-username': req.query['rose-username']});
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
        const selections = req.body.answer;
        const newAnswer = new PopupAnswer(
            {questionID: req.body.questionID,
            answerer: req.body.answerer,
            timestamp: Date.now(),
            answer: selections
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
        console.log('start new logic -------');
        
      const questionToUpdate = await PopupQuestion.findOne({"_id": req.body.questionID});
      for(i in questionToUpdate.optionQuantities){
        if(selections.includes(questionToUpdate.optionQuantities[i].option)) questionToUpdate.optionQuantities[i].count++;
      }
      console.log(questionToUpdate);

      const updatedQuestion = await PopupQuestion.updateOne({"_id": req.body.questionID}, questionToUpdate);
      console.log(updatedQuestion);


    } catch(err){
        console.log(err);
        res.json({message: "Error!"})
    }
})

router.get('/allQuestions', async (req, res) => {
    try{
        console.log('made it to getting all questions')
        const questions = await PopupQuestion.find();
        const questionsParsed = JSON.parse(JSON.stringify(questions));
        for(i in questions){
          var tempObj = {};
          for(j in questions[i].optionQuantities){
            tempObj[questions[i].optionQuantities[j].option] = questions[i].optionQuantities[j].count;
          }
          console.log(tempObj)
          questionsParsed[i].optionQuantities = tempObj;
        }
        console.log(questions);
        res.json(questionsParsed);
    } catch(err){
      console.log(err)
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


router.post('/create', async (req, res) => {
  console.log('creating popup');
  const optionQuantities = [];
  const newOptions = JSON.parse(req.body.options);
  
  for(input in newOptions){
    console.log(input);
    var newObj = {};
    newObj['option'] = newOptions[input];
    newObj['count'] = 0;
    optionQuantities.push(newObj);
  }
  console.log(optionQuantities)

  const popup = new PopupQuestion({
      "question": req.body.question,
      "priority": parseInt(req.body.priority),
      "quota": parseInt(req.body.quota),
      "options": newOptions,
      "optionQuantities": optionQuantities,
      "currentAnswers": 0,
  })

  popup.save()
  .then(data => {
      res.json(data);
  })
  .catch(err => {
      res.json({message: err})
  })
})

router.post('/edit', async (req, res) => {
  const newOptions = JSON.parse(req.body.options)
  //const newOptions = req.body.options;
  const toUpdate =  await PopupQuestion.findOne({"_id": req.body['_id']});
  const oldOptions = [];
  for(i in toUpdate.optionQuantities){
    //create list of old options
    oldOptions.push(toUpdate.optionQuantities[i].option)

  }

  //add new options to the list and delete old ones
  for(i in newOptions){
    if(!oldOptions.includes(newOptions[i])){
      const newObj = {
        "option": newOptions[i],
        "count": 0
      }
      toUpdate.optionQuantities.push(newObj);
    }
  }



  //update the rest of the new question's vals
  toUpdate.question = req.body.question;
  toUpdate.priority = req.body.priority;
  toUpdate.quota = req.body.quota;
  toUpdate.options = newOptions;


const updateResult = await PopupQuestion.updateOne({"_id": req.body['_id']}, 
toUpdate
).then(sol =>{
  res.json({
    message: sol
  })
})
.catch(err => {
  res.json({
    message: err
  })
})
console.log(updateResult)



})

router.post('/delete', async (req, res) => {
  console.log('deleting '+req.body['_id']);
  const deleteResult = await PopupQuestion.deleteOne({"_id": req.body['_id']})
  .then(msg =>{
    res.json({
      message: msg
    })
  })
  .catch(err => {
    res.json({
      message: err
    })
  })
  console.log(deleteResult);
})

//not needed right now
// router.post('/specific', async (req, res) => {

// })



module.exports = router;