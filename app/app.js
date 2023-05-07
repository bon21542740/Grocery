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

// Render the Pug template for the login page
app.get('/login', (req, res) => {
  res.render('login');
});

// Handle login form submission
app.post('/login', async (req, res) => {
  const email = req.body.email;
  const password = req.body.password;

  // Query the database to see if the user exists
  const rows = await db.query('SELECT * FROM USERS WHERE email = ? AND password = ?', [email, password]);

  if (rows.length > 0) {
    // User is authenticated
    req.session.user = rows[0];
    res.redirect('/');
  } else {
    // User is not authenticated
    res.render('login', { error: 'Invalid email or password' });
  }
});

// Render the Pug template for the signup page
app.get('/signup', (req, res) => {
  res.render('signup');
});

// Handle signup form submission
app.post('/signup', async (req, res) => {
  const name = req.body.name;
  const email = req.body.email;
  const password = req.body.password;

  // Insert the user into the database
  await db.query('INSERT INTO USERS (name, email, password, role) VALUES (?, ?, ?, ?)', [name, email, password, 'customer']);

  // Redirect the user to the login page
  res.redirect('/login');
});

// Get all stores
app.get('/store', async (req, res) => {
  const stores = await db.query('SELECT * FROM STORES');
  res.render('store', { stores });
});

// Create a new store
app.post('/store', async (req, res) => {
  const { name, location } = req.body;
  await db.query('INSERT INTO STORES (name, location) VALUES (?, ?)', [name, location]);
  res.redirect('/store');
});

// Get a store by ID
app.get('/store/:id', async (req, res) => {
  const store = await db.query('SELECT * FROM STORES WHERE id = ?', [req.params.id]);
  res.render('store-edit', { store });
});

// Update a store by ID
app.put('/store/:id', async (req, res) => {
  const { name, location } = req.body;
  await db.query('UPDATE STORES SET name = ?, location = ? WHERE id = ?', [name, location, req.params.id]);
  res.redirect('/store');
});

// Delete a store by ID
app.delete('/store/:id', async (req, res) => {
  await db.query('DELETE FROM STORES WHERE id = ?', [req.params.id]);
  res.redirect('/store');
});

app.listen(3000,function(){
  console.log(`Server running at http://127.0.0.1:3000/`);
});
