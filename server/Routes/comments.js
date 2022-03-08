const Comment = require('../Models/Comment');
const express = require('express');
const router = express.Router();

router.get('/all', async (req, res) => {
    try{
        console.log('made it to getting all comments')
        const comments = await Comment.find();

        res.json(comments);
    } catch(err){
        res.statusCode = 500;
        res.json({message: "Error!"})
    }
})

router.post('/get', async (req, res) => {
    try{
        console.log('made it to getting specific comments')
        const comments = await Comment.find({"parent-id": req['parent-id']});
        res.json(comments);
    } catch(err){
        res.json({message: "Error!"})
    }
})

router.get('/getById/:id', async (req, res) => {
    try{
        //currently only supports single tag queries
        console.log('obtaining forum by id')
        const comment = await Comment.findById(req.params.id);
        if (comment == null){
            res.statusCode = 500;
            res.json({message: "no comment with that id"});
        }
        else {
            res.json({message: comment});
        }
    } catch(err){
        res.statusCode = 500;
        res.json({message: "Error!"})
    }
})
// create need to update forum field comments, and create the comment itself.
router.post('/create', (req, res) => {
    console.log('creating comment')
    console.log(req.body)
    const comment = new Comment({
        "content": req.body.content || "",
        "likes": req.body.likes || 0,
        "commenter": req.body.commenter,
        "timestamp": req.body.timestamp,
        "parent-id": req.body['parent-id']
    });

    post.save()
    .then(data => {
        res.json(data);
    })
    .catch(err => {
        res.json({message: err})
    })
})



module.exports = router;