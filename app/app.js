const express = require('express');
const mysql = require('mysql');
const session = require('express-session');
const bodyParser = require('body-parser');
const app = express();
const path = require('path');


const db = require('./services/db');


// Set up the view engine to use Pug
app.set('view engine', 'pug');
app.set('views', path.join(__dirname, '../views'));


app.use(express.urlencoded({ extended: true }));
app.use(express.json());


// Serve static files from the static directory
// app.use(express.static('static'));


app.use(bodyParser.urlencoded({ extended: true }));


// Set up session middleware
app.use(session({
 secret: 'my-secret',
 resave: false,
 saveUninitialized: false,
}));


// Render the Pug template for the index page
app.get('/', (req, res) => {
 res.render('index');
});


