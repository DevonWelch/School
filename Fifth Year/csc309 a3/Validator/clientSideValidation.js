var express = require('express')
var app = express()

// set views path, template engine and default layout
app.engine('.html', require('ejs').__express);
app.set('views', __dirname)
app.set('view engine', 'html')

//Allow to access the page fields easily.
var bodyParser = require('body-parser')
app.use( bodyParser.json() );       // to support JSON-encoded bodies
app.use(bodyParser.urlencoded({     // to support URL-encoded bodies
  extended: true
})); 


//get the index page
app.get('/', function(req, res){
   res.render('clientSideValidation', { 
            errors: ''
        });
});


//getting the value from a Form input
app.post('/signup', function(req, res){
  
    res.send('Username '+ req.body.userName+ '\n password '+ req.body.userPass);
});

var server = app.listen(3000, function () {

  var port = server.address().port

  console.log('Running on 127.0.0.1:%s', port)

})
