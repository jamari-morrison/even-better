const User = require('../Models/User');
const express = require('express');
const router = express.Router();
const student = require('../Models/Student');
const nodemailer = require('nodemailer');
const rtg = require('random-token-generator');


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

router.post('/signup', (req, res) => {
  console.log('creating user')
  console.log(req.body)
  const user = new User({
    "username": req.body.username,
    "rose-username": req.body['rose-username'],
  });

  user.save()
    .then(data => {
      res.json(data);
    })
    .catch(err => {
      res.json({
        message: err
      })
    })
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

router.post('/addFriend', async (req, res) => {
  //database operation to add friend

  // const deleted = await User.deleteOne({
  //   'rose-username': req.body['rose-username']
  // }).catch(err => {
  //   res.json({
  //     message: err
  //   })
  // })

  res.json({
    message: 'could not find user ' + req.body['rose-username']
  })
})

router.post('/sendValidationEmail', async (req, res) => {

  let testAccount = await nodemailer.createTestAccount();

  var transporter = nodemailer.createTransport({
    //TODO: get a temporary gmail account, don't use personal one
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

    // upload the code to the database for the user ...
    //could check to see if the key is already in use. Extremely unlikely to generate the same one twice though

    var toUpdate = await User.updateOne({
      "rose-username": req.body['rose-username']
    }, {
      'verification-token': key,
      'verified': false
    });

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
        html: `<p><a href='https://load-balancer-937536547.us-east-2.elb.amazonaws.com:443/users/validateEmail/${key}'>click here to verify email</a></p>`
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
})
router.get('/emailValidated/:username', async (req, res) => {

  console.log(req.params.token);

  var user = await User.findOne({
    "rose-username": req.params.username,
    "verified": true
  }, );

  if (user){
  res.json({
    message: true
  });
} else {
  res.json({
    message: false
  });
}


})
module.exports = router;