const User = require('../Models/User')
const Notification = require('../Models/Notification')
const express = require('express');
const router = express.Router();
const pushNotificationController = require('../controllers/push-notification.controllers')

router.post('/send', async (req, res) => {
    console.log('sending '+req.body.messageText)
    pushNotificationController.SendNotification(req.body.messageText)
    res.json({msg: 'did not error'})
});


//need to be able to create a notification and store it in the database
router.post('/create', async (req, res) => {
    console.log('creating notification');
    const notification = new Notification({
        "text": req.body.text,
        "years": req.body.years,
        "timestamp": req.body.timestamp,
        "majors": req.body.majors
    })

    notification.save()
    .then(data => {
        res.json(data);
    })
    .catch(err => {
        res.json({message: err})
    })
})



//whenever a user logs in, check if the timestamp for their most recent notification is not equal to this one.
//if it is, show them a popup and update the date
//if it is not, skip
router.get('/checkForNotification', async (req, res) => {
    console.log('checking for notification');
    try{
        console.log('made it to getting next notification for ' + req.query['rose-username'] )
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



module.exports = router;