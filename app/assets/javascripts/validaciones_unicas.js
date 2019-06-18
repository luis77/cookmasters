$(document).on("turbolinks:load", function() {
	$(".user-validado").validate({
		rules: {
		"user[password]": {minlength: 6},
		"user[password_confirmation]": {minlength: 6,equalTo: "#user_password"},
		"user[email]": {required: true, remote:'user_check2' },
		"user[username]": {required: true, remote:'user_check' }

		}
	});
});




