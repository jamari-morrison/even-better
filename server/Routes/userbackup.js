const User = require('../Models/User');
const express = require('express');
const router = express.Router();
const student = require('../Models/Student');
const nodemailer = require('nodemailer');
const rtg = require('random-token-generator');


//runs periodically
function deleteIncompleteAccounts() {
  //should delete those without a username added. Since adding username
  //is the final step in accnt creation, this should remove all incomplete
  //accounts.
  //use creation-time here
  //if the user's account has been created but not verified for more than 
  //30 min, delete it
  // 30 minutes = 1800000 ms
  let deletionTimeMs = 1800000;

  console.log("deleting incomplete accounts");
  User.deleteMany({
    "username": null,
    "creation-time": {
      $lt: Date.now() - deletionTimeMs
    }
  }).then((result) => {
    console.log(result);

  });
}

//every hour
//note that if we do this more often, we should use setTimout recursively
//instead of setInterval , but then the period between calls will not be
//exactly an hour
setInterval(deleteIncompleteAccounts, 3600000);


router.get('/all', async (req, res) => {
  try {
    const users = await User.find();
    res.json(users);
  } catch (err) {
    res.json({
      message: "Error!"
    })
  }
})


router.post('/signup', async (req, res) => {
  console.log('creating user')
  console.log(req.body)

  //add the username to the placeholder accnt to "create" the accnt
  var toUpdate = await User.updateOne({
    "rose-username": req.body['rose-username'],
  }, {
    "username": req.body.username,
  })

  if (toUpdate.modifiedCount == 0) {
    res.status = 400;
    res.json({
      message: "user account deleted or does not exist"
    })
  } else {
    res.json({
      message: "success"
    })
  }


})

router.post('/delete', async (req, res) => {
  console.log('deleting user ' + req.body['rose-username']);
  const deleted = await User.deleteOne({
    'rose-username': req.body['rose-username']
  }).catch(err => {
    res.json({
      message: err
    })
  })
  if (deleted['deletedCount'] == 1) res.json({
    message: 'successfully deleted ' + req.body['rose-username']
  })
  else res.json({
    message: 'could not find user ' + req.body['rose-username']
  })


})

router.post('/sendValidationEmail', async (req, res) => {
  // not responsible for if an account has already been created with this rose email,
  // but is responsible if there is one in progress
  var transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      //made a fake gmail account for this. replace it later probably
      user: 'rosebot94@gmail.com',
      pass: 'Password1?'
    }
  });



  rtg.generateKey({
    len: 16,
    string: true,
    strong: false,
    retry: true
  }, async (err, key) => {

    //could check to see if the key is already in use. Extremely unlikely to generate the same one twice though

    //check if there is already an account creation in progress.
    //if there is, update veriification-token for it and don't create a new user
    //note that verified might already be true here depending on when they backed out. Set
    //it to false to ensure the account isn't stolen after being verified

    const updateStats = await User.updateOne({
      "rose-username": req.body['rose-username'],
      "username": null
    }, {"verified": false, "verification-token": key, "creation-time": Date.now()})

    if (updateStats.modifiedCount == 0) {
      const user = new User({
        "rose-username": req.body['rose-username'],
        'verification-token': key,
        'verified': false,
        'creation-time': Date.now()
      });

      //create a placeholder account for verification
      user.save()
        .then(data => {
          res.json(data);
        })
        .catch(err => {
          res.json({
            message: err
          })
        })


    }


    // var toUpdate = await User.updateOne({
    //   "rose-username": req.body['rose-username']
    // }, {
    // });

    if (err) {
      res.json({
        message: error
      });
    } else {
      var mailOptions = {
        from: 'rosebot94',
        to: req.body['rose-username'] + '@rose-hulman.edu',
        subject: "Verify Your Even Better Account",
        //TODO: change to be the actual server and not local host
        // html: `<p><a href='https://load-balancer-937536547.us-east-2.elb.amazonaws.com:443/users/validateEmail/${key}'>click here to verify email</a></p>`
        html: `<p><a href='https://api.even-better-api.com:443/users/validateEmail/${key}'>click here to verify email</a></p>`
      };
      transporter.sendMail(mailOptions, function (error, info) {
        if (error) {
          console.log(error);
          res.json({
            message: error
          });
        } else {
          console.log('Email sent: ' + info.response);
          res.json({
            message: 'Successfully sent user verification link!'
          });
        }
      });

    }
  });


})


router.get('/validateEmail/:token', async (req, res) => {

  console.log(req.params.token);
  if (!req.params.token) {
    res.json({
      message: 'no user to verify for the given token'
    });
  } else {

    var updateStats = await User.updateOne({
      "verification-token": req.params.token
    }, {
      verified: true,
      $unset: {
        "verification-token": null
      }
    });
    if (updateStats.modifiedCount == 1) {
      res.json({
        message: 'Successfully verified user'
      });

    } else {
      res.json({
        message: 'no user to verify for the given token'
      });


    }
  }
})
router.get('/emailValidated/:username', async (req, res) => {

  console.log(req.params.token);

  var user = await User.findOne({
    "rose-username": req.params.username,
    "verified": true
  }, );

  if (user) {
    res.json({
      message: true
    });
  } else {
    res.json({
      message: false
    });


  }


})

//https://stackoverflow.com/questions/53069041/nodejs-mongodb-follow-unfollow-request
router.post("/:user_id/follow-user",  passport.authenticate("jwt", { session:false}), (req,res) => {

  // check if the requested user and :user_id is same if same then 

  if (req.user.id === req.params.user_id) {
      return res.status(400).json({ alreadyfollow : "You cannot follow yourself"})
  } 

  User.findById(req.params.user_id)
      .then(user => {

          // check if the requested user is already in follower list of other user then 

          if(user.followers.filter(follower => 
              follower.user.toString() === req.user.id ).length > 0){
              return res.status(400).json({ alreadyfollow : "You already followed the user"})
          }

          user.followers.unshift({user:req.user.id});
          user.save()
          User.findOne({ "rose-username": req.params.username })
              .then(user => {
                  user.following.unshift({user:req.params.user_id});
                  user.save().then(user => res.json(user))
              })
              .catch(err => res.status(404).json({alradyfollow:"you already followed the user"}))
      })
})



// const express = require('express');
// const router = express.Router();
// const { ensureAuthenticated } = require('../config/auth');
// const mongoose = require('mongoose');
const User=require('../models/User');

router.post('/', (req, res) => {
  updateRecord(req,res);
  res.redirect('/profile');

});

function updateRecord(req, res) {
User.findOne({"rose-username": req.body['rose-username']},(err,doc)=>{
//this will give you the document what you want to update.. then 
doc.name = req.body.name;
doc.save(function(err,doc){

});

});}


router.post('/update', async (req, res) => {
  console.log('updating user')
  console.log(req.body)

  //add the username to the placeholder accnt to "create" the accnt
  var toUpdate = await User.updateOne({
    "rose-username": req.body['rose-username'],
  }, {
    "name": req.body.name,
  })

  if (toUpdate.modifiedCount == 0) {
    res.status = 400;
    res.json({
      message: "user account deleted or does not exist"
    })
  } else {
    res.json({
      message: "success"
    })
  }
})

module.exports = router;