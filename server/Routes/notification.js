const User = require('../Models/User')
const express = require('express');
const router = express.Router();


//need to be able to create a notification and store it in the database
router.post('/create', async (req, res) => {
    
})

//whenever a user logs in, check if the timestamp for their most recent notification is not equal to this one.
//if it is, show them a popup and update the date
//if it is not, skip
router.get('/checkForNotification', async (req, res) => {
    
})



module.exports = router;