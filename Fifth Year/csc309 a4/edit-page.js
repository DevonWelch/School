
$(document).ready(function(){
	$("#change-pwd-button").click(function(){
    	$.ajax({url: "change-password/user=" + $("#email-input").val() + "?oldpass=" + $("#old-pwd-input").val() + "?newpass=" + $("#new-pwd-input").val() + "?confpass=" + $("#conf-pwd-input").val(), type: 'POST', success: function(result){
    		if (result == "1"){
    			$("#error").text("Passwords don't match.");
    		} else if (result == "2") {
    			$("#error").text("Incorrect current password.");
    		} else if (result == "3") {
				localStorage.userName = '';
		    	localStorage.email = '';
				window.location.replace("/index.html");
    		} else {
    			$("#error").text("Password changed successfully.")
    		}
    	}});
    });
});

$(document).ready(function(){
	$("#update-button").click(function(){
    	$.ajax({url: "update-info/user=" + $("#email-input").val() + "?display-name=" + $("#display-input").val() + "?desc=" + $("#description-input").val(), type: 'POST', success: function(result){
    		if (result == "1") {
    			localStorage.userName = '';
		    	localStorage.email = '';
				window.location.replace("/index.html");
    		} else {
				$("#error").text("Information updated.");
				localStorage.userName = $("#display-input").val();
				$("#username").text($("#display-input").val());
			}
    	}});
    });
});

$(document).ready(function(){
	$("#cancel-button").click(function(){
		if (localStorage.userName != '') {
		    $.ajax({url: "/profile-page.html", type: 'POST', success: function(result){
				$.ajax({url:"get-user=" + $("#email-input").val(), type: 'POST', success: function(res) {
					if (res == '') {
						localStorage.userName = '';
		    			localStorage.email = '';
						window.location.replace("/index.html");
					} else {
	    				userName = JSON.parse(res);
	    				$('#content').html(result);
	    				$("#email").text(userName["email"]);
	    				$("#big-pic").attr("src", userName["image"]);
	    				if ("display" in userName) {
	    					$("#display-name").text(userName["display"]);
	    				} 
	    				if ("description" in userName) {
	    					$("#description").text(userName["description"]);
	    				} 
	    				$.ajax({url:"get-user=" + localStorage.email, type: 'POST', success: function(res2) {
							usrName = JSON.parse(res2);
							if (localStorage.email != userName["email"] && usrName["role"] != "super-admin" && (userName["role"] != "standard" && usrName["role"] != "admin")) {
		    					$("#edit-button").text('');
		    				} 
							if (((usrName["role"] != "standard" && userName["role"] == "standard") || ((usrName["role"] == "super-admin" && userName["role"] == "admin"))) && usrName["email"] != userName["email"]) {
								$("#button-div").append('<button id="delete-button">Delete User</button>');
							}
							if (usrName["role"] == "super-admin") {
								if (userName["role"] == "standard") {
									$("#button-div").append('<button id="admin-button">Make Admin</button>');
								} else if (userName["role"] == "admin") {
									$("#button-div").append('<button id="admin-button">Remove Admin</button>');
								}
							}
						}});
	    			}
	    		}});
		    }});
		}
	});
});

$(document).ready(function(){
	$("#edit-button").click(function(){
		if (localStorage.userName != '') {
			
		    $.ajax({url: "/profile-page.html", type: 'POST', success: function(result){
				$.ajax({url:"get-user=" + $("#email-input").val(), type: 'POST', success: function(res) {
					if (res == '') {
						localStorage.userName = '';
		    			localStorage.email = '';
						window.location.replace("/index.html");
					} else {
						$('#content').html(result);
	    				userName = JSON.parse(res);
	    				$("#email").text(userName["email"]);
	    				$("#big-pic").attr("src", userName["image"]);
	    				if ("display" in userName) {
	    					$("#display-name").text(userName["display"]);
	    				} 
	    				if ("description" in userName) {
	    					$("#description").text(userName["description"]);
	    				} 
	    				$.ajax({url:"get-user=" + localStorage.email, type: 'POST', success: function(res2) {
							usrName = JSON.parse(res2);
							if (localStorage.email != userName["email"] && usrName["role"] != "super-admin" && !(userName["role"] == "standard" && usrName["role"] == "admin")) {
		    					$("#edit-button").text('');
		    				} 
							if (((usrName["role"] != "standard" && userName["role"] == "standard") || ((usrName["role"] == "super-admin" && userName["role"] == "admin"))) && usrName["email"] != userName["email"]) {
								$("#button-div").append('<button id="delete-button">Delete User</button>');
							}
							if (usrName["role"] == "super-admin") {
								if (userName["role"] == "standard") {
									$("#button-div").append('<button id="admin-button">Make Admin</button>');
								} else if (userName["role"] == "admin") {
									$("#button-div").append('<button id="admin-button">Remove Admin</button>');
								}
							}
							$("#delete-button").click(function(){
								$.ajax({url:"remove-user=" + $("#email").text(), type: 'POST', success:function(result) {
									$.ajax({url: "/home-page.html", type: 'POST', success: function(result) {
										var userName;
		    							$.ajax({url:"get-user=" + localStorage.email, type: 'POST', success: function(res) {
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
			    						}});
									}});
								}});
							});
							$("#admin-button").click(function(){
	    						$.ajax({url: "change-admin=" + $("#email").text(), type: 'POST', success: function(result){
	    							if (result == "0") {
										$("#error").text("Administrator priviliges granted.");
										$("#admin-button").text("Remove Admin");
									} else {
										$("#error").text("Administrator priviliges revoked.");
										$("#admin-button").text("Make Admin");
									}
	    						}});
	    					});
						}});
					}
	    		}});
		    }});
		}
	});
});
