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

router.get('/getById/:id', async (req, res) => {
    try{
        //currently only supports single tag queries
        const forum = await Post.findById(req.params.id);
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



module.exports = router;