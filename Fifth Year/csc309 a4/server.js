var http = require('http');  // Imports the http module.
var fs = require('fs');
var path = require('path');
var url = require("url");
var querystring = require('querystring');

MIME_TYPES = {
  '.html': 'text/html',
  '.css': 'text/css',
  '.js': 'text/javascript',
  '.txt': 'text/plain'
};

var PORT = 3000;  // Change it to your reserved port.

var express = require('express');

var mongoose = require('mongoose');

mongoose.connect('mongodb://localhost:27017/data');

var Schema = mongoose.Schema;

var userSchema = new Schema({
  email:  String,
  pass: String,
  description: String,
  image: String,
  display: String,
  role: String
});

var User = mongoose.model('User', userSchema);

var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function callback () {
  console.log('Connected to MongoDB');
});

var default_image = url.parse("/default.png").pathname;

http.createServer(function(request, response) {  // Creates a HTTP server.
  // Writes response header.
  	var uri = url.parse(request.url).pathname
    , filename = path.join(process.cwd(), uri);
    console.log(uri);
  console.log('Request: ' + request.url);
  console.log(filename);
    if (request.url == '/') { //index file is requested
    if (fs.statSync(filename).isDirectory()) filename += '/index.html';
 
    fs.readFile(filename, "binary", function(err, file) {
      if(err) {        
        response.writeHead(500, {"Content-Type": "text/plain"});
        response.write(err + "\n");
        response.end();
        return;
      }
 
      response.writeHead(200);
      response.write(file, "binary");
      response.end();
    });

	} else if (uri == "/style.css" || uri == "/signup.js" || uri == "/login.js" || uri == "/profile-page.js" || uri == "/edit-page.js" || uri == "/edit-page.html" || uri == "/jquery-1.11.3.min.js" || uri == "/client.js" || uri == "/index.html" || uri == "/login-screen.html" || uri == "/signup-screen.html" || uri == "/home-page.html" || uri == "/profile-page.html") { //any other expected file
       fs.readFile(filename, "binary", function(err, file) {
      if(err) {     
        response.writeHead(500, {"Content-Type": "text/plain"});
        response.write(err + "\n");
        response.end();
        return;
      }
      console.log(uri);   
 	
      if (uri == "/style.css") {
      	  response.writeHead(200, {"Content-Type":"text/css"});
	      response.write(file, "binary");
	      response.end();
      } else {
	      response.writeHead(200);
	      response.write(file, "binary");
	      response.end();
	  }
    });
  	} else if (request.url.indexOf("signup-action") != -1) {
	  	var user = request.url.split("user=")[1].split("?")[0];
	  	var pass = request.url.split("pass=")[1].split("?")[0];
	  	var confPass = request.url.split("confpass=")[request.url.split("confpass=").length-1];
	  	if (confPass != pass) {
	  		response.writeHead(200);
	  		response.write("1");
	  		response.end();
	  	} else {
	  		User.findOne({email:user}, 'email', function(err, userExists) {
			if (err) return handleError(err);
			if (userExists == null) {
				User.findOne({}, function(err, otherUsers) {
					if (otherUsers == null) {
						var userVar = new User({ email: user, pass:pass, role:"super-admin", image: default_image});
					} else {
						var userVar = new User({ email: user, pass:pass, role:"standard", image: default_image});
					}
					userVar.save(function (err) {
	  					if (err) return handleError(err);
					});
					fs.readFile(path.join(process.cwd(), "/home-page.html"), "binary", function(err, file) {
			      		if(err) {        
			        		response.writeHead(500, {"Content-Type": "text/plain"});
			        		response.write(err + "\n");
			        		response.end();
			        		return;
			      		}
		  				response.writeHead(200);
		  				response.write(file, "binary");
		  				response.end();
		  			});
				});
			} else {
				response.writeHead(200);
	  			response.write("2");
	  			response.end();
				}
			});
	  	}
	} else if (request.url.indexOf("login-action") != -1) {
	  	var user = request.url.split("user=")[1].split("?")[0];
	  	var pass = request.url.split("pass=")[1].split("?")[0];
	  	User.findOne({email:user, pass:pass}, 'email', function(err, userExists) {
			if (err) return handleError(err);
			if (userExists == null) {
				response.writeHead(200);
	  			response.write("1");
	  			response.end();
			} else {
				fs.readFile(path.join(process.cwd(), "/home-page.html"), "binary", function(err, file) {
		      		if(err) {        
		        		response.writeHead(500, {"Content-Type": "text/plain"});
		        		response.write(err + "\n");
		        		response.end();
		        		return;
		      		}
	  				response.writeHead(200);
	  				response.write(file, "binary");
	  				response.end();
	  			});
			}
		});
	} else if (request.url.indexOf("all-users") != -1) {
		User.find({}, 'email display', function(err, userExists) {
			if (err) return handleError(err);
			if (userExists == null) {
				response.writeHead(200);
				response.write([]);
				response.end();
			} else {
				console.log(userExists);
				response.writeHead(200);
				response.write(JSON.stringify(userExists));
				response.end();
			}
		});
	} else if (request.url.indexOf("get-user") != -1) {
		usr = request.url.split("get-user=")[1]
		User.findOne({email : usr}, function(err, userExists) {
			if (err) return handleError(err);
			if (userExists == null) {
				response.writeHead(200);
				response.write('');
				response.end();
			} else {
				console.log(userExists);
				response.writeHead(200);
				response.write(JSON.stringify(userExists));
				response.end();
			}
		});
	} else if (request.url.indexOf("change-password") != -1) {
	  	var user = request.url.split("user=")[1].split("?")[0];
	  	var oldpass = request.url.split("oldpass=")[1].split("?")[0];
	  	var newpass = request.url.split("newpass=")[1].split("?")[0];
	  	var confPass = request.url.split("confpass=")[request.url.split("confpass=").length-1];
	  	if (confPass != newpass) {
	  		response.writeHead(200);
	  		response.write("1");
	  		response.end();
	  	} else {
	  		User.findOne({email:user}, function(err, userExists) {
			if (err) return handleError(err);
			if (userExists == null) {
				response.writeHead(200);
	  			response.write("3");
	  			response.end();
			} else if (userExists.pass == oldpass) {
				userExists.pass = newpass;
				userExists.save(function (err) {
  					if (err) return handleError(err);
				});
	  			response.writeHead(200);
	  			response.write("0");
	  			response.end();
			} else {
				response.writeHead(200);
	  			response.write("2");
	  			response.end();
				}
			});
	  	}
	} else if (request.url.indexOf("update-info") != -1) {
	  	var user = request.url.split("user=")[1].split("?")[0];
	  	var disp = request.url.split("display-name=")[1].split("?")[0];
	  	var desc = request.url.split("desc=")[1].split("?")[0];
	  	User.findOne({email:user}, function(err, userExists) {
			if (err) return handleError(err);
			if (userExists == null) {
				response.writeHead(200);
	  			response.write("1");
	  			response.end();
			} else {
				userExists.display = disp;
				userExists.description = desc;
				//console.log(request.data);
				userExists.save(function (err) {
	  				if (err) return handleError(err);
				});
		  		response.writeHead(200);
		  		response.write("0");
		  		response.end();
		  	}
		});
	} else if (request.url.indexOf('remove-user') != -1) {
		var user = request.url.split("remove-user=")[1];
		User.findOneAndRemove({email:user}, function(err, usr) {
			response.writeHead(200);
	  		response.write("0");
	  		response.end();
		});
	} else if (request.url.indexOf('change-admin') != -1) {
		var user = request.url.split("change-admin=")[1];
		User.findOne({email:user}, function(err, usr) {
			if (usr.role == "standard") {
				usr.role = "admin";
				usr.save(function (err) {
  					if (err) return handleError(err);
				});
				response.writeHead(200);
	  			response.write("0");
	  			response.end();
			} else {
				usr.role = "standard";
				usr.save(function (err) {
  					if (err) return handleError(err);
				});
				response.writeHead(200);
	  			response.write("1");
	  			response.end();
			}
		});
	} else if (request.url.indexOf("png") != -1) {
		if (request.url == "/logo.png") {
			fs.readFile(path.join(process.cwd(), uri), "binary", function(err, file) {
		    	if(err) {        
		        	response.writeHead(500, {"Content-Type": "text/plain"});
		        	response.write(err + "\n");
		        	response.end();
		        	return;
		      	}
	  			response.writeHead(200);
	  			response.write(file, "binary");
	  			response.end();
	  		});
		} else {
			User.findOne({image:request.url}, "image", function(err, img) {
				if (img != null) {
					fs.readFile(path.join(process.cwd(), uri), "binary", function(err, file) {
			    		if(err) {        
			        		response.writeHead(500, {"Content-Type": "text/plain"});
			        		response.write(err + "\n");
			        		response.end();
			        		return;
			      		}
		  				response.writeHead(200);
		  				response.write(file, "binary");
		  				response.end();
		  			});
				}
			});
		}
	} else { //unexpected file
	  	console.log("here");
	  	response.writeHead(404, {"Content-Type": "text/plain"});
	  	response.write("Page not found\n");
	  	response.end();
	  	return;
	}
}).listen(PORT);
