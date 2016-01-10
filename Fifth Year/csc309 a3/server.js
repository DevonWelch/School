http = require('http');  // Imports the http module.
fs = require('fs');
path = require('path');
url = require("url");

MIME_TYPES = {
  '.html': 'text/html',
  '.css': 'text/css',
  '.js': 'text/javascript',
  '.txt': 'text/plain'
};

var PORT = 3000;  // Change it to your reserved port.

var json_file = JSON.parse(fs.readFileSync("./favs.json"));

http.createServer(function(request, response) {  // Creates a HTTP server.
  // Writes response header.
  	var uri = url.parse(request.url).pathname
    , filename = path.join(process.cwd(), uri);
  console.log('Request: ' + request.url);
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

} else if (request.url.indexOf("all-tweets") != -1) { //all tweets are requested

	ret_list = []; //a list of all tweets, in ID: ###, Text: ssss form.

	for (i=0; i < json_file.length; i++){
		ret_list.push("ID: " + json_file[i]["id_str"] + ", Text: " + json_file[i]["text"]); 
	}

	response.writeHead(200);
	response.write(JSON.stringify(ret_list));
	response.end();

} else if (request.url.indexOf("all-users") != -1) { //all users are requested

	ret_list = []; //a list of all users, in ID: ###, Name: nnnn form.

	for (i=0; i < json_file.length; i++){
		ret_list.push("ID: " + json_file[i]["user"]["id_str"] + ", Name: " + json_file[i]["user"]["name"]);
	}

	response.writeHead(200);
	response.write(JSON.stringify(ret_list));
	response.end();

} else if (request.url.indexOf("links") != -1) { //all external links are requested

	ret_list = []; //a list of all external links

	for (i=0; i < json_file.length; i++){

		if ("urls" in json_file[i]["entities"]) {

			for (j=0; j < json_file[i]["entities"]["urls"].length; j++) {
				ret_list.push(json_file[i]["entities"]["urls"][j]["expanded_url"]);
			}

		}

		if ("media" in json_file[i]["entities"]) {

			for (j=0; j < json_file[i]["entities"]["media"].length; j++) {
				ret_list.push(json_file[i]["entities"]["media"][j]["media_url"]);
			}

		}
	}

	response.writeHead(200);
	response.write(JSON.stringify(ret_list));
	response.end();

} else if (request.url.indexOf("tweet/id") != -1) { //get features of the given tweet

	tweet_id = request.url.match(/id=\d*/)[0].slice(3);
	ret_list = []; //a list of all the features I have deemed useful of the given tweet

	for (i=0; i < json_file.length; i++){ //iterating through all tweets

		if (json_file[i]["id_str"] == tweet_id) { //get features of the tweet once it has been found

				for (j=0; j < Object.keys(json_file[i]).length; j++) { //iterating through tweet's features

					if (json_file[i][Object.keys(json_file[i])[j]] != null) { //only get features that are not null

						temp_obj = {};

						if (Object.keys(json_file[i])[j] == "user") { //only get the user's name and id
							temp_obj["user"] = json_file[i][Object.keys(json_file[i])[j]]["name"];
							temp_obj["user_id"] = json_file[i][Object.keys(json_file[i])[j]]["id_str"];
						} 

						else if (Object.keys(json_file[i])[j] == "entities") {

							if ("urls" in json_file[i]["entities"]) { //get all urls mentioned in tweet
								url_list = [];

								for (k=0; k < json_file[i]["entities"]["urls"].length; k++) {
									url_list.push(json_file[i]["entities"]["urls"][k]["expanded_url"]);
								}

								temp_obj["urls"] = url_list;
							}

							if ("media" in json_file[i]["entities"]) { //get all media urls mentioned in tweet
								media_list = [];

								for (k=0; k < json_file[i]["entities"]["media"].length; k++) {
									media_list.push(json_file[i]["entities"]["media"][k]["media_url"]);
								}

								temp_obj["media_urls"] = media_list;
							}

							if ("user_mentions" in json_file[i]["entities"]) { //get all user mentions in tweet
								user_list = [];

								for (k=0; k < json_file[i]["entities"]["user_mentions"].length; k++) {
									user_list.push(json_file[i]["entities"]["user_mentions"][k]["name"]);
								}

								temp_obj["user_list"] = user_list;
							}

							if ("hashtags" in json_file[i]["entities"]) { //get all hashtags in tweet
								hashtags = [];

								for (k=0; k < json_file[i]["entities"]["hashtags"].length; k++) {
									hashtags.push(json_file[i]["entities"]["hashtags"][k]["text"]);
								}

								temp_obj["hashtags"] = hashtags;
							}

						} 

						else if (Object.keys(json_file[i])[j] == "place") {
							temp_obj["place id"] = json_file[i][Object.keys(json_file[i])[j]]["id"];
							temp_obj["place url"] = json_file[i][Object.keys(json_file[i])[j]]["url"];
							temp_obj["place name"] = json_file[i][Object.keys(json_file[i])[j]]["full_name"];
							temp_obj["place country"] = json_file[i][Object.keys(json_file[i])[j]]["country"];
						} 

						else if (Object.keys(json_file[i])[j] == "coordinates") {
							temp_obj[Object.keys(json_file[i])[j]] = json_file[i][Object.keys(json_file[i])[j]]["coordinates"][0] + ', ' + json_file[i][Object.keys(json_file[i])[j]]["coordinates"][1];
						} 

						else if (Object.keys(json_file[i])[j] != "geo") { //all other features; geo is excluded because it has the same information as coordinates
							temp_obj[Object.keys(json_file[i])[j]] = json_file[i][Object.keys(json_file[i])[j]];
						}

						ret_list.push(temp_obj);
					}

				}

			i = json_file.length; //escape iteration through tweets once the correct one has been found

		}

	}

	response.writeHead(200);
	response.write(JSON.stringify(ret_list));
	response.end();

} else if (request.url.indexOf("user/id") != -1) {

	user_id = request.url.match(/id=\d*/)[0].slice(3);
	ret_list = []; //list of features of the user that I have deemed worthwhile

	for (i=0; i < json_file.length; i++){ //iterate through tweets

		if (json_file[i]["user"]["id_str"] == user_id) { //find correct user

				for (j=0; j < Object.keys(json_file[i]["user"]).length; j++) { //iterate through user's features

					if (json_file[i]["user"][Object.keys(json_file[i]["user"])[j]] != null) { //ignore null features

						temp_obj = {};

						if (Object.keys(json_file[i]["user"])[j] == "entities") {

							if ("urls" in json_file[i]["user"]["entities"]) {
								url_list = [];

								for (k=0; k < json_file[i]["entities"]["user"]["urls"].length; k++) {
									url_list.push(json_file[i]["entities"]["user"]["urls"][k]["expanded_url"]);
								}

								temp_obj["urls"] = url_list;
							}

							if ("media" in json_file[i]["user"]["entities"]) {
								media_list = [];

								for (k=0; k < json_file[i]["user"]["entities"]["media"].length; k++) {
									media_list.push(json_file[i]["user"]["entities"]["media"][k]["media_url"]);
								}

								temp_obj["media_urls"] = media_list;
							}

							if ("user_mentions" in json_file[i]["user"]["entities"]) {
								user_list = [];

								for (k=0; k < json_file[i]["user"]["entities"]["user_mentions"].length; k++) {
									user_list.push(json_file[i]["user"]["entities"]["user_mentions"][k]["name"]);
								}

								temp_obj["user_list"] = user_list;
							}

							if ("hashtags" in json_file[i]["user"]["entities"]) {
								hashtags = [];

								for (k=0; k < json_file[i]["user"]["entities"]["hashtags"].length; k++) {
									hashtags.push(json_file[i]["user"]["entities"]["hashtags"][k]["text"]);
								}

								temp_obj["hashtags"] = hashtags;
							}
						} 

						else {
							temp_obj[Object.keys(json_file[i]["user"])[j]] = json_file[i]["user"][Object.keys(json_file[i]["user"])[j]];
						}

						ret_list.push(temp_obj);

					}

				}

			i = json_file.length;

		}

	}

	response.writeHead(200);
	response.write(JSON.stringify(ret_list));
	response.end();

} else if (request.url.indexOf("user-popularity") != -1) { //find the user with the most followers

	ret_list = [];
	most = 0;

	for (i=0; i < json_file.length; i++){

		if (json_file[i]["user"]["followers_count"] >= most) {
			ret_list = [(json_file[i]["user"]["name"] + " is the most popular with " + json_file[i]["user"]["followers_count"] + ' followers.')];
			most = json_file[i]["user"]["followers_count"];
		}

	}

	response.writeHead(200);
	response.write(JSON.stringify(ret_list));
	response.end();

} else if (request.url == "/style.css" || request.url == "/jquery-1.11.3.min.js" || request.url == "/client.js" || request.url == "/index.html") { //any other expected file
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
  } else { //unexpected file
  	response.writeHead(404, {"Content-Type": "text/plain"});
  	response.write("Page not found\n");
  	response.end();
  	return;
  }
}).listen(PORT);  // Server starts to listen on port 8080.

// Writes info on Node's console.
console.log('Server running at http://127.0.0.1:' + PORT + '/');