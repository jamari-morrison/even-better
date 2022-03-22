const Post = require('../Models/Post');
const express = require('express');
const router = express.Router();

router.get('/all', async (req, res) => {
    try{
        console.log('made it to all')
        const posts = await Post.find();

        res.json(posts);
    } catch(err){
        res.json({message: "Error!"})
    }
})

router.get('/getById/:username', async (req, res) => {
    try{
        //currently only supports single tag queries
        const forum = await Post.findById(req.params.username);
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

router.post('/deleteByKey/:id', async (req, res) => {
    try{
        //currently only supports single tag queries
        const post = await Post.findByIdAndDelete(req.params.id);
        Post.deleteMany({"_id": ObjectId(req.params.id)});
        res.json({message : "Successfully deleted post"});
    } catch(err){
        res.statusCode = 500;
        res.json({message: "Error!"})
    }
})


router.get('/getUserPost/:username', async (req, res) => {
    console.log('getting user posts')
    console.log(req.params.username)
    try {
      var posts = await Post.find({
        "poster": req.params.username
      });
      console.log(res.statusCode);
      // console.log(user.friend);
     console.log(posts);
      if (posts != null) {
        res.status = 200;
        res.json( posts );
      }
    } catch (err) {
      console.log(err)
      res.json({
        message: "Error!"
      })
    }
  })


router.post('/create', (req, res) => {
    console.log('creating post')
    console.log(req.body)
    const post = new Post({
        "title": req.body.title,
        "description": req.body.description || "",
        "picture-uri": req.body['picture-uri'] || "",
        "likes": req.body.likes || 0,
        "timestamp": req.body.timestamp,
        "poster": req.body.poster
    });

    post.save()
    .then(data => {
        res.json(data);
    })
    .catch(err => {
        res.json({message: err})
    })
})

router.post('/updatelike/:id', async (req, res) => {
    console.log(req.params.id);
    console.log(req.body.likes);
    var toUpdate = await Post.updateOne({
        "_id": req.params.id,
      },{
        "likes": req.body.likes,
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

router.post('/update/:id', async (req, res) => {
    console.log(req.params.id);
    var toUpdate = await Post.updateOne({
        "_id": req.params.id,
      },{
        "title": req.body.title,
        "description": req.body.description,
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