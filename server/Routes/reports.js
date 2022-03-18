const Report = require('../Models/Report');
const Forum = require('../Models/Forum');
const nodemailer = require('nodemailer');
const express = require('express');
const router = express.Router();

router.get('/all', async (req, res) => {
    try {
        console.log('made it to getting all forums')
        const reports = await Report.find();

        res.json(reports);
    } catch (err) {
        res.json({
            message: "Error!"
        })
    }
})

router.post('/submit', async (req, res) => {
    //save the report to the reports collection
    console.log('submitting report')
    console.log(req.body)
    const reason = req.body.reason;
    const contentType = req.body['content-type'];
    const report = new Report({
        "reason": reason,
        "content-type": contentType,
        "content-id" : req.body["content-id"],
        "timestamp": Date.now(),
    });
    report.save()
        .then(data => {
        })
        .catch(err => {
            res.json({
                message: err
            })
            return;
        })
    //obtain the content reported on:
    let content;
    if (contentType == "forums") {
        content = await Forum.findById(req.body['content-id']);
    }
    else if (contentType == "posts") {
        content = await Post.findById(req.body['content-id']);
    }
    //email the content to the admin account

    var transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            //made a fake gmail account for this. replace it later probably
            user: 'rosebot94@gmail.com',
            pass: 'Password1?'
        }
    });
    var mailOptions = {
        from: 'rosebot94',
        //send to seth's rose email for now
        to: 'lakstise' + '@rose-hulman.edu',
        subject: "Content Reported by User",
        html: `<h1>Reason for Report:</h1><p>${reason}</p><h1>Content Reported On:</h1><p>${content}</p>
        <h2><a href='https://api.even-better-api.com/${contentType}/deleteByKey/${req.body['content-id']}'>click here to delete content</a></h2>`
        //<h2><a href='http://localhost:3000/${contentType}/deleteByKey/${req.body['content-id']}'>click here to delete content</a></h2>`
    };
    transporter.sendMail(mailOptions, function (error, info) {
        if (error) {
            console.log(error);
            res.status = 500;
            res.json({
                message: error
            });
        } else {
            console.log('Email sent: ' + info.response);
            res.status = 200;
            res.json({
                message: 'Successfully sent user verification link!'
            });
        }
    });


})

module.exports = router;