const Forum = require('../Models/Forum');
const express = require('express');
const router = express.Router();

router.get('/all', async (req, res) => {
    try{
        console.log('made it to getting all forums')
        const forums = await Forum.find();

        res.json(forums);
    } catch(err){
        res.json({message: "Error!"})
    }
})

router.post('/get', async (req, res) => {
    try{
        //currently only supports single tag queries
        console.log('made it to getting specific Forum by tag')
        const forums = await Forum.find({"tag": req['tag']});
        res.json(forums);
    } catch(err){
        res.json({message: "Error!"})
    }
})


router.post('/create', (req, res) => {
    console.log('creating forum')
    console.log(req.body)
    const forum = new Forum({
        "content": req.body.content || "",
        "likes": req.body.likes || 0,
        "poster": req.body.poster,
        "timestamp": req.body.timestamp,
        "title": req.body.title,
        "tags": req.body.tags
    });

    forum.save()
    .then(data => {
        res.json(data);
    })
    .catch(err => {
        res.json({message: err})
    })
})



module.exports = router;