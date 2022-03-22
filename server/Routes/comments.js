const Comment = require('../Models/Comment');
const express = require('express');
const router = express.Router();

// create need to update forum field comments, and create the comment itself.
router.post('/create', (req, res) => {
    console.log('creating comment')
    console.log(req.body)
    const comment = new Comment({
        "content": req.body.content,
        "likes": req.body.likes || 0,
        "commenter": req.body.commenterid,
        "commentername": req.body.commentername,
        "timestamp": req.body.timestamp,
        "parent-id": req.body['parent-id']
    });
    comment.save()
    .then(data => {
        res.json(data);
    })
    .catch(err => {
        res.json({message: err})
    })
})

router.get('/all', async (req, res) => {
    // console.log("At least here");
    try{
        // console.log('made it to getting all comments')
        const comments = await Comment.find();
        res.json(comments);
    } catch(err){
        res.statusCode = 500;
        res.json({message: "Error!"})
    }
})

router.get('/get/:forumid', async (req, res) => {
    try{
        // console.log('made it to getting specific comments')
        const comments = await Comment.find({"parent-id": req.params.forumid});
        res.json(comments);
    } catch(err){
        res.statusCode = 500;
        res.json({message: "Error!"})
    }
})

router.get('/deleteByKey/:id', async (req, res) => {
    try{
        //currently only supports single tag queries
        console.log("deleting comment with id " + req.params.id);
        const comments = await Comment.findByIdAndDelete(req.params.id);
        
        res.json({message : "Successfully deleted comment"});
    } catch(err){
        res.statusCode = 500;
        res.json({message: "Error!"})
    }
})

module.exports = router;