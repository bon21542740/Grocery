const express = require('express');
const mysql = require('mysql');
const session = require('express-session');
const bodyParser = require('body-parser');
const app = express();

const db = require('./services/db');

function query(sql, args) {
    return new Promise((resolve, reject) => {
        pool.query(sql, args, (err, rows) => {
            if (err) {
                return reject(err);
            }
            resolve(rows);
        });
    });
}

app.use(session({
    secret: 'secret',
    resave: true,
    saveUninitialized: true
}));

app.use(bodyParser.urlencoded({extended : true}));
app.use(bodyParser.json());
app.use(express.static('static')); // add this line to serve static files

app.get('/', function(request, response) {
    response.sendFile(__dirname + '/index.html');
});

app.post('/auth', function(request, response) {
    const email = request.body.email;
    const password = request.body.password;
    if (email && password) {
        db.query('SELECT * FROM USERS WHERE email = ? AND password = ?', [email, password], function(error, results, fields) {
            if (results.length > 0) {
                request.session.loggedin = true;
                request.session.email = email;
                response.redirect('/home');
            } else {
                response.send('Incorrect Email and/or Password!');
            }           
            response.end();
        });
    } else {
        response.send('Please enter Email and Password!');
        response.end();
    }
});

app.get('/home', function(request, response) {
    if (request.session.loggedin) {
        response.send(`
            <h1>Welcome back, ${request.session.email}!</h1>
            <p>Thank you for logging in.</p>
            <form action="/logout" method="post">
                <button type="submit">Logout</button>
            </form>
        `);
    } else {
        response.send(`
            <h1>Please login to view this page!</h1>
            <p>You must be logged in to access the content on this page.</p>
            <form action="/" method="get">
                <button type="submit">Login</button>
            </form>
        `);
    }
    response.end();
});


app.get('/logout', function(request, response) {
    request.session.destroy(function(error) {
        if (error) {
            console.log(error);
        } else {
            response.redirect('/');
        }
    });
});

app.get('/store', function(request, response) {
    // const sql = 'SELECT * FROM STORES';
    // const stores = await query(sql);

    db.query(sql, function(error, results, fields) {
      if (error) throw error;
  
      const stores = results;
  
      response.sendFile(__dirname + '/static/store.html', function(error) {
        if (error) throw error;
  
        // Send stores data to the client-side JavaScript
        response.send(`<script>const stores = ${JSON.stringify(stores)};</script>`);
      });
    });
  });
  

app.listen(3000,function(){
    console.log(`Server running at http://127.0.0.1:3000/`);
});
