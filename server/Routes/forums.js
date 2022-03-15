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
        res.statusCode = 500;
        res.json({message: "Error!"})
    }
})

router.get('/getById/:id', async (req, res) => {
    try{
        //currently only supports single tag queries
        console.log('obtaining forum by id')
        const forum = await Forum.findById(req.params.id);
        if (forum == null){
            res.statusCode = 500;
            res.json({message: "no post with that id"});
        }
        else {
            res.json({message: forum});
        }
    } catch(err){
        res.statusCode = 500;
        res.json({message: "Error!"})
    }

})

router.get('/deleteByKey/:id', async (req, res) => {
    try{
        //currently only supports single tag queries
        const forums = await Forum.findByIdAndDelete(req.params.id);
        
        res.json({message : "Successfully deleted post"});
    } catch(err){
        res.statusCode = 500;
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
        "tags": req.body.tags,
        "comments": req.body.comments
    });

    forum.save()
    .then(data => {
        res.json(data);
    })
    .catch(err => {
        res.json({message: err})
    })
})

router.post('/update', async (req, res) => {
    console.log('updating forum')
    console.log(req.body)
    var toUpdate = await Forum.updateOne({
        "_id": req.body['id'],
      },{
        "content": req.body.content,
        "timestamp": req.body.timestamp,
        "title": req.body.title
    })

    // toUpdate.save()
    // .then(data => {
    //     res.json(data);
    // })
    // .catch(err => {
    //     res.json({message: err})
    // })
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

// this is for updating current list of comment string
router.post('/updateCommentListWithID', async (req, res) => {
    console.log('updating forum')
    console.log(req.body)
    var toUpdate = await Forum.InsertOne({
        "_id": req.body['id'],
      },{
        "comments": req.body.comments
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