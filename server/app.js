const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser')
const Conversation = require('./Models/Conversation');



require('dotenv/config')
const app = express();
app.use(bodyParser.json());

const http = require('http');
const server = http.createServer(app);
const { Server } = require("socket.io");
const io = new Server(server);



//send json object through socket and handle all messaging on the socket, no rest api for posting database objects and stuff


//get/create conversation
//add current message
//that's all

let connections = {};




io.on('connection', (socket) => {
    console.log('a user connected');

    socket.on('init', (msg) => {
        req = msg
       // socket.userID = msg['userID']
       connections[msg['userID']] = socket.id

        console.log('initialized '+socket.id)

    })

    socket.on('fromClient', async (msg) =>  {
        req = msg;//JSON.stringify(msg['text']);
        let conversation = await Conversation.find({$or: [{"users": [req['sender'], req['recipient']]}, {"users": [req['recipient'], req['sender']]}]});
        
        conversation[0]['messages'].push({
            "sender": req['sender'],
            "text": req['text'],
            "timestamp": req['timestamp']
        })

        conversation[0]['messages'].push({
            "sender": req['recipient'],
            "text": 'You said '+JSON.stringify(msg['text']),
            "timestamp": req['timestamp']+1

        })

        conversation[0].save()

        io.to(connections[msg['sender']]).emit('fromServer', 'You said '+JSON.stringify(msg['text']));
      });
 });   


const userRoute = require('./Routes/users');
const postRoute = require('./Routes/posts');
const studentRoute = require('./Routes/students');
const commentsRoute = require('./Routes/comments');
const forumsRoute = require('./Routes/forums');
const messagesRoute = require('./Routes/messages')
const reportsRoute = require('./Routes/reports')
const popupsRoute = require('./Routes/popups')



app.use('/messages', messagesRoute);
app.use('/popups', popupsRoute)
app.use('/users', userRoute);
app.use('/posts', postRoute);
app.use('/students', studentRoute);
app.use('/comments', commentsRoute);
app.use('/forums', forumsRoute);
app.use('/reports', reportsRoute);

app.get('/', (req, res) => {
    res.sendFile(__dirname + '/index.html');
  });


mongoose.connect(process.env.DB_CONNECT, {useNewUrlParser: true}, () => console.log('Connected'));


server.listen(3000, () => {console.log('listening in 3000')});
