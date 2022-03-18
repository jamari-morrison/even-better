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
  }).catch(err => {
    console.log("error with  deleting incomplete accounts");
  });


  //remove the verification token fields from any users who still have one
  User.updateMany({
    "creation-time": {
      $lt: Date.now() - deletionTimeMs
    },
    "verification-token": {
      $exists: true
    }
  }, {
    $unset: {
      "verification-token": null
    }

  })



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
    "name": req.body.name
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
  console.log('deleting user ' + req.body['username']);

  //delete all of the users stuff
  //Ensure poster is acutally username and not the name of the user.
  Post.deleteMany({"poster": req.body['username']});



  //delete the actual user
  const deleted = await User.deleteOne({
    'username': req.body['username']
  }).catch(err => {
    res.json({
      message: err
    })
  })
  if (deleted['deletedCount'] == 1) res.json({
    message: 'successfully deleted ' + req.body['username']
  })
  else {
    res.status = 500;
    res.json({
      message: 'could not find user ' + req.body['username']
    })
  }


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
    }, {
      "verified": false,
      "verification-token": key,
      "moderator": false,   //could set this based on graduation year if we want to differentiate between alums and students
      "creation-time": Date.now()
    })

    if (updateStats.modifiedCount == 0) {
      const user = new User({
        "rose-username": req.body['rose-username'],
        'verification-token': key,
        'verified': false,
        'creation-time': Date.now(),
        'moderator': true
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
        html: `<p><a href='https://api.even-better-api.com/users/validateEmail/${key}'>click here to verify email</a></p>`
        // html: `<p><a href='https://api.even-better-api.com/users/validateEmail/${key}'>click here to verify email</a></p>`
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

    });
    if (updateStats.matchedCount >= 1) {
      res.sendFile('/Webpages/emailValidate/success.html', { root: "./" });
    } else {
      res.sendFile('/Webpages/emailValidate/failure.html', { root: "./" });
    }
  }
});

router.get('/emailValidated/:username', async (req, res) => {

  console.log(req.params.token);

  var user = await User.findOne({
    "rose-username": req.params.username,
    "verified": true
  });

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




router.post('/update/', async (req, res) => {
  console.log('updating user')
  console.log(req.body)

  //add the username to the placeholder accnt to "create" the accnt
  var toUpdate = await User.updateOne({
    "username": req.body['username'],
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



router.get('/getUser/:username', async (req, res) => {
  console.log('getting user')
  console.log(req.params.username)
  try {
    var user = await User.findOne({
      "username": req.params.username,
      "verified": true
    });
    console.log(res.statusCode);
    console.log(user);
    if (user != null) {
      res.status = 200;
      res.json({ user });
    }
  } catch (err) {
    console.log(err)
    res.json({
      message: "Error!"
    })
  }
})

router.get('/getUser/:ebuid', async (req, res) => {
  console.log('getting user')
  console.log(req.params.username)
  try {
    var user = await User.findOne({
      "_id": req.params.ebuid
    });
    if (user != null) {
      res.status = 200;
      res.json({ user });
    }
  } catch (err) {
    console.log(err)
    res.json({
      message: "Error!"
    })
  }
})



router.post('/updatestring/:username', async (req, res) => {
  console.log('updating user')
  console.log(req.body)

  var toUpdate = await User.updateOne({
    "username": req.params.username,
  }, {
    "name": req.body.name,
    "companyname": req.body.companyname,
    "bio": req.body.bio,
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


router.post('/updatebool/:username', async (req, res) => {
  console.log('updating bool')
  console.log(req.body)
  console.log(req.params.username)
  var toUpdate = await User.updateOne({
    "username": req.params.username,
  },
    {
      cs: req.body.cs,
      se: req.body.se,
      ds: req.body.ds,
    }
  )
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

  //   User.findOneAndUpdate({ "username": req.body['username'], }, {
  //     "$set": {
  //       "cs": req.body.cs.bo,
  //       "se": req.body.se,
  //       "ds": req.body.ds,
  //     }
  //   }).exec(function (err, user) {
  //     if (err) {
  //       console.log(err);
  //       res.status(500).send(err);
  //     } else {
  //       res.status(200).send(user);
  //     }
  //   });
})


//   if (toUpdate.modifiedCount == 0) {
//     res.status = 400;
//     res.json({
//       message: "user account deleted or does not exist"
//     })
//   } else {
//     res.json({
//       message: "success"
//     })
//   }
// })

router.post('/updateava/:username', async (req, res) => {
  console.log('updating ava')
  console.log(req.body)
  console.log(req.body.avatar)
  console.log(req.params.username)

  var toUpdate = await User.findOneAndUpdate({
    "username": req.params.username,
  }, {
    "avatar": req.body.avatar,
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

router.post('/addfriend/:username', async (req, res) => {
  console.log("adding friend")
  console.log(req.body)
  console.log(req.params.username)
  var toUpdate1 = await User.update(
    {  "username": req.params.username },
    { $addToSet:{ "friends": req.body.friend } }
  );
  var toUpdate2 = await User.update(
    {  "username": req.body.friend },
    { $addToSet:{ "friends": req.params.username } }
  );
  if (toUpdate1.modifiedCount == 0||toUpdate2.modifiedCount == 0) {
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


router.get('/getUserFriends/:username', async (req, res) => {
  console.log('getting user friends')
  console.log(req.params.username)
  try {
    var user = await User.findOne({
      "username": req.params.username,
      "verified": true
    });
    console.log(res.statusCode);
    // console.log(user.friend);
    console.log(user.friends);
    if (user.friends != null) {
      res.status = 200;
      res.json( user.friends );
    }
  } catch (err) {
    console.log(err)
    res.json({
      message: "Error!"
    })
  }
})

module.exports = router;