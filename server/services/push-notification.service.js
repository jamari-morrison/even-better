const {ONE_SIGNAL_CONFIG} = require('../config/app.config');

// async function SendNotification(data, callback){
//     var headers = {
//         "Content-Type": "application/json; charset=utf-8",
//         "Authorization": "Basic " + ONE_SIGNAL_CONFIG.API_KEY,
//     };

//     var options = {
//         host: 'onesignal.com',
//         post: 443,
//         path: '/api/v1/notifications',
//         mathod: "POST",
//         headers: headers
//     };

//     var https = require("https");
//     var req = https.request(options, function(res){
//         res.on("data", function(data){
//             console.log("response");
//             console.log(JSON.parse(data));

//             return callback(null, JSON.parse(data))
//         })
//     })

//     req.on('error', function(e){
//         return(callback({message: e}))
//     })

//     req.write(JSON.stringify(data));
//     req.end();

// }
async function SendNotification (data) {
    var headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization": "Basic NDAyMmE3NmYtNGU2Ny00OTdlLTgzMTAtMjkwMTVlYTBhYjky"
    };
    
    var options = {
      host: "onesignal.com",
      port: 443,
      path: "/api/v1/notifications",
      method: "POST",
      headers: headers
    };
    
    var https = require('https');
    var req = https.request(options, function(res) {  
      res.on('data', function(data) {
        console.log("Response:");
        console.log(JSON.parse(data));
      });
    });
    
    req.on('error', function(e) {
      console.log("ERROR:");
      console.log(e);
    });
    
    req.write(JSON.stringify(data));
    req.end();
  };
  
  var message = { 
    app_id: "68f951ef-3a62-4c97-89dc-7ef962b29bc6",
    contents: {"en": "English Message"},
    included_segments: ["All"]
  };
module.exports = {
    SendNotification
}