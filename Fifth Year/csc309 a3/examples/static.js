http = require('http');
fs = require('fs');
path = require('path');
url = require("url");

PORT = 4321;

STATIC_PREFIX = '/static/';

MIME_TYPES = {
  '.html': 'text/html',
  '.css': 'text/css',
  '.js': 'text/javascript',
  '.txt': 'text/plain'
};

http.createServer(function(request, response) {
	var uri = url.parse(request.url).pathname
    , filename = path.join(process.cwd(), uri);
  console.log('Request: ' + request.url);
  console.log('here');
  if (request.url == '/') {
    console.log('yes2');
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
  
  } else if (request.url.indexOf(STATIC_PREFIX) == 0) {
    console.log('yes1');
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
  } else {
    console.log('yes');
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
  }
  console.log('end');
}).listen(PORT);

console.log('Server running at http://127.0.0.1:' + PORT + '/');