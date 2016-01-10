$(document).ready(function(){
	$("#login-button").click(function(){
	    $.ajax({url: "login-screen.html", type: 'POST', success: function(result){
	    	$('#content').html(result);
	    }});
	});
});

$(document).ready(function(){
	$("#signup-button").click(function(){
	    $.ajax({url: "signup-screen.html", type: 'POST', success: function(result){
			$('#content').html(result);
	    }});
	});
});

$(document).ready(function(){
	$("#username").click(function(){
		if (localStorage.userName != '') {
		    $.ajax({url: "/profile-page.html", type: 'POST', success: function(result){
				$('#content').html(result);
				$.ajax({url:"get-user=" + localStorage.email, success: function(res) {
					if (res == '') {
						localStorage.userName = '';
		    			localStorage.email = '';
						window.location.replace("/index.html");
					} else {
	    				userName = JSON.parse(res);
	    				$("#email").text(userName["email"]);
	    				$("#big-pic").attr("src", userName["image"]);
	    				if ("display" in userName) {
	    					$("#display-name").text(userName["display"]);
	    				} 
	    				if ("description" in userName) {
	    					$("#description").text(userName["description"]);
	    				} 
	    			}
	    		}});
		    }});
		}
	});
});

$(document).ready(function(){
	$("#profile-pic").click(function(){
		if (localStorage.userName != '') {
		    $.ajax({url: "/profile-page.html", type: 'POST', success: function(result){
				$('#content').html(result);
				$.ajax({url:"get-user=" + localStorage.email, success: function(res) {
					if (res == '') {
						localStorage.userName = '';
		    			localStorage.email = '';
						window.location.replace("/index.html");
					} else {
	    				userName = JSON.parse(res);
	    				$("#email").text(userName["email"]);
	    				$("#big-pic").attr("src", userName["image"]);
	    				if ("display" in userName) {
	    					$("#display-name").text(userName["display"]);
	    				} 
	    				if ("description" in userName) {
	    					$("#description").text(userName["description"]);
	    				} 
	    			}
	    		}});
		    }});
		}
	});
});

$(document).ready(function(){
	$("#logo").click(function(){
		if (localStorage.email != '' && localStorage.email != null) {
		    $.ajax({url: "/home-page.html", type: 'POST', success: function(result) {
				var userName;
	    		$.ajax({url:"get-user=" + localStorage.email, success: function(res) {
	    			if (res == '') {
						localStorage.userName = '';
		    			localStorage.email = '';
						window.location.replace("/index.html");
					} else {
	    				userName = JSON.parse(res);
		    			if ("display" in userName) {
		    				displayName = userName["display"];
		    			} else {
		    				displayName = userName["email"];
		    			}
		    			$('#username').text(displayName);
						$("#profile-pic").attr("src", userName["image"]);
		    			$('#content').html(result);
						$("#welcome").text("Welcome " + displayName + "!");
					}
		    	}});
			}});
		} else {
			$.ajax({url: "/index.html", success: function(result){
				window.location.replace("/index.html");
		    }});
		}
	});
});

$(document).ready(function(){
	$("#logout-button").click(function(){
		if (localStorage.userName != '') {
		    $.ajax({url: "/index.html", type: 'POST', success: function(result){
		    	localStorage.userName = '';
		    	localStorage.email = '';
				window.location.replace("/index.html");
		    }});
		}
	});
});

$(document).ready(function() {
	if (typeof(Storage) !== "undefined") {
		if (localStorage.email != null && localStorage.email != '') {
			$.ajax({url: "/home-page.html", type: 'POST', success: function(result) {
				var userName;
	    		$.ajax({url:"get-user=" + localStorage.email, success: function(res) {
	    			if (res == '') {
						localStorage.userName = '';
		    			localStorage.email = '';
						window.location.replace("/index.html");
					} else {
	    				userName = JSON.parse(res);
		    			if ("display" in userName) {
		    				displayName = userName["display"];
		    			} else {
		    				displayName = userName["email"];
		    			}
		    			$('#username').text(displayName);
		    			$("#profile-pic").attr("src", userName["image"]);
		    			$('#content').html(result);
						$("#welcome").text("Welcome " + displayName + "!");
						$("#logout-button").text("Logout");
					}
		    	}});
			}});
		} else {
			userName = ''
			localStorage.userName = '';
			localStorage.email = '';
		}
	} else {
		alert("no storage");
	}
});