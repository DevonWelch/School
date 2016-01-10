$(document).ready(function(){
	$("#signup-action").click(function(){
    	$.ajax({url: "signup-action/user=" + $("#email").val() + "?pass=" + $("#pwd").val() + "?confpass=" + $("#confirm-pwd").val(), type: 'POST', success: function(result){
    		if (result == "1"){
    			$("#error").text("Passwords don't match.");
    		} else if (result == "2") {
    			$("#error").text("Email already in use.");
    		} else {
    			var userName;
    			$.ajax({url:"get-user=" + $("#email").val(), type: 'POST', success: function(res) {
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
					if (typeof(Storage) !== "undefined") {
						localStorage.userName = displayName;
						localStorage.email = userName["email"];
						$("#logout-button").text("Logout");
					} else {
						alert("no storage");
					}
	    		}});
			}
    	}});
	});
});