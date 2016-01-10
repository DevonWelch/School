http = require('http');  // Imports the http module.

var PORT = 8080;  // Change it to your reserved port.

http.createServer(function(request, response) {  // Creates a HTTP server.
  // Writes response header.
  response.writeHead(200,  // 200 is the HTTP code for successs.
                     {'Content-Type': 'text/plain'});  // This is the MIME-type.
  // It writes "Hello World\n" and closes the connection.
  response.end('Hello World!\n');
}).listen(PORT);  // Server starts to listen on port 8080.

// Writes info on Node's console.
console.log('Server running at http://127.0.0.1:' + PORT + '/');