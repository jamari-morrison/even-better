const Student = require('../Models/Student');
const User = require('../Models/User');

const express = require('express');
const router = express.Router();
var nodemailer = require('nodemailer');



router.get('/all', async (req, res) => {
  try {
    const students = await Student.find();
    console.log("got mail")
    res.json(students);
  } catch (err) {
    res.json({
      message: "Error!"
    })
  }
})

router.get('/list', async (req, res) => {
  try {
    console.log(req.query.year.toString())
    const students = await Student.find({
      year: req.query.year
    });
    console.log(students)
    res.json(students);
  } catch (err) {
    console.log(err)
    res.json({
      message: "Error!"
    })
  }
})

router.post('/studentFromEmail', async (req, res) => {
  try {
    var student = await Student.findOne({
      "rose-username": req.body['rose-username']
    });
    if (student) {
      res.json({
        message: student
      });
    } else {
      res.json({
        message: "user not found"
      });
    }
  } catch (err) {
    console.log(err)
    res.json({
      message: "Error!"
    })
  }
})

router.post('/create', (req, res) => {
  console.log('creating student')
  console.log(req.body)
  const user = new Student({
    "name": req.body['name'],
    "rose-username": req.body['rose-username'],
    "year": req.body['year'],
    "major": req.body['major'],
    "status": "Invite",
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

router.post('/checkExist', async (req, res) => {
  var exists = await Student.find({
    "rose-username": req.body['rose-username']
  });
  var isTaken = await User.find({
    "rose-username": req.body['rose-username'],
    "username": {
      $exists: true
    }
  });
  if (exists.length > 0 && isTaken.length == 0) res.json({
    message: true
  })
  else res.json({
    message: false
  })
})

//create post / get post, create tags / get tags, 
router.post('/invite', async (req, res) => {

  var toUpdate = await Student.find({
    "rose-username": req.body['rose-username']
  });
  toUpdate[0]['status'] = "pending";
  const result = await Student.updateOne({
      "_id": toUpdate[0]['_id']
    }, toUpdate[0])
    .catch(err => {
      res.json({
        message: err
      })
    })
  console.log(result)

  var transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: 'UtsukushiiNee@gmail.com',
      pass: 'ilovekousei123'
    }
  });

  var mailOptions = {
    from: 'Kaori Miyazono',
    to: req.body['rose-username'] + '@rose-hulman.edu',
    subject: req.body['inviter'] + ' Invites you to join Even Better',
    text: 'That was easy!'
  };

  transporter.sendMail(mailOptions, function (error, info) {
    if (error) {
      console.log(error);
      res.json({
        message: error
      });
    } else {
      console.log('Email sent: ' + info.response);
    }
  });


  res.json({
    message: 'Successfully invited user!'
  });

})

module.exports = router;