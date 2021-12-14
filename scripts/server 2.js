const path          = require('path');
const http          = require('http');
const express       = require('express');
const socketIO      = require('socket.io');
const uuid           = require('uuid');
const next           = require('next');
const { createClient } = require('@supabase/supabase-js')
const supabase = createClient('https://xyzcompany.supabase.co', 'public-anon-key')

//login
//supabase


const { Server } = require("socket.io");
const publicPath    = path.join(__dirname, '/public');
const port = process.env.PORT || 3000;
const isDev = process.env.NODE_ENV !== 'production'
const nextApp = next({dev:isDev})
const nextHandler = nextApp.getRequestHandler()

//    console.log('A user just connected.');
//    socket.on('disconnect', () => {
//       console.log('A user has disconnected.');
//    })
//    socket.on('startGame', () => {
//       io.emit('startGame');
//    })

//    socket.on('crazyIsClicked', (data) => {
//       io.emit('crazyIsClicked', data);
//    });
// });

   let app = express();
   let server = http.createServer(app);
   let io = new Server(server);
io.on('connect', socket => {
      socket.emit('now', {
         message:'change msg'
      })

      console.log('A user just connected.');
      // socket.on('disconnect', () => {
      //    console.log('A user has disconnected.');
      // })
      // socket.on('startGame', () => {
      //    io.emit('startGame');
      // })

      // socket.on('crazyIsClicked', (data) => {
      //    io.emit('crazyIsClicked', data);
      // });
   })

nextApp.prepare().then(() => {
   // let app = express();
   // let server = http.createServer(app);
   // let io = new Server(server);
   // app.use(express.static(publicPath));

   app.get('*', (q,s) => {
      return nextHandler(q,s)
   })

   

   // io.listen(port)
   server.listen(port, (e)=> {
      if(e) throw e
      console.log(`Server is up on port ${port}.`)
   });
})
