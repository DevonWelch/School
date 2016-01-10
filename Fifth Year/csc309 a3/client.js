$(document).ready(function(){
	$("#all-button").click(function(){
	    $.ajax({url: "all-tweets", success: function(result){
	    	$("#ret-list").empty();
	    	temp_var = JSON.parse(result);
	    	for (i=0; i < temp_var.length; i++) {
	    		$("#ret-list").append($(document.createElement('li')).text(temp_var[i]));
	    	}
	    }});
	});
});

$(document).ready(function(){
	$("#users-button").click(function(){
	    $.ajax({url: "all-users", success: function(result){
	    	$("#ret-list").empty();
	    	temp_var = JSON.parse(result);
	    	for (i=0; i < temp_var.length; i++) {
	    		$("#ret-list").append($(document.createElement('li')).text(temp_var[i]));
	    	}
	    }});
	});
});

$(document).ready(function(){
	$("#links-button").click(function(){
	    $.ajax({url: "links", success: function(result){
	    	$("#ret-list").empty();
	    	temp_var = JSON.parse(result);
	    	for (i=0; i < temp_var.length; i++) {
	    		$("#ret-list").append($(document.createElement('li')).text(temp_var[i]));
	    	}
	    }});
	});
});

$(document).ready(function(){
	$("#info-button").click(function(){
	    $.ajax({url: "tweet/id=" + $("#tweet-id").val(), success: function(result){
	    	$("#ret-list").empty();
	    	temp_var = JSON.parse(result);
	    	for (i=0; i < temp_var.length; i++) {
	    		for (j = 0; j < Object.keys(temp_var[i]).length; j ++) {
	    			$("#ret-list").append($(document.createElement('li')).text(Object.keys(temp_var[i])[j] + " : " + temp_var[i][Object.keys(temp_var[i])[j]]));
	    		}
	    	}
	    }});
	});
});

$(document).ready(function(){
	$("#user-button").click(function(){
	    $.ajax({url: "user/id=" + $("#user-id").val(), success: function(result){
	    	$("#ret-list").empty();
	    	temp_var = JSON.parse(result);
	    	for (i=0; i < temp_var.length; i++) {
	    		for (j = 0; j < Object.keys(temp_var[i]).length; j ++) {
	    			$("#ret-list").append($(document.createElement('li')).text(Object.keys(temp_var[i])[j] + " : " + temp_var[i][Object.keys(temp_var[i])[j]]));
	    		}
	    	}
	    }});
	});
});

$(document).ready(function(){
	$("#interesting-button").click(function(){
	    $.ajax({url: "user-popularity", success: function(result){
	    	$("#ret-list").empty();
	    	temp_var = JSON.parse(result);
	    	for (i=0; i < temp_var.length; i++) {
	    		$("#ret-list").append($(document.createElement('li')).text(temp_var[i]));
	    	}
	    }});
	});
});