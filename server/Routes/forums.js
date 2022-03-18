const Forum = require('../Models/Forum');
const Report = require('../Models/Report');
const express = require('express');
const router = express.Router();

router.get('/all', async (req, res) => {
    try{
        const forums = await Forum.find();

        res.json(forums);
    } catch(err){
        res.json({message: "Error!"})
    }
})

router.post('/get', async (req, res) => {
    try{
        //currently only supports single tag queries
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
        Report.deleteMany({"content-id": req.params.id});
        
        res.json({message : "Successfully deleted post"});
    } catch(err){
        res.statusCode = 500;
        res.json({message: "Error!"})
    }
})

router.post('/create', (req, res) => {
    // console.log(req.body)
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
    // console.log(req.body)
    var toUpdate = await Forum.updateOne({
        "_id": req.body['id'],
      },{
        "content": req.body.content,
        "timestamp": req.body.timestamp,
        "title": req.body.title
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