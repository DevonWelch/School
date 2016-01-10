$(document).ready(function(){
	$("#edit-button").click(function(){
		if (localStorage.userName != '') {
		    $.ajax({url: "/edit-page.html", type: 'POST', success: function(result){
		    	email = $("#email").text();
		    	disp = $("#display-name").text();
		    	desc = $("#description").text();
		    	picSrc = $("#big-pic").attr("src");
				$('#content').html(result);
				$("#email-input").val(email);
				$("#display-input").val(disp);
				$("#description-input").val(desc);
				$("#big-pic").attr("src", picSrc);
		    }});
		}
	});
});