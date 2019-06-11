$(document).on("ready page:load", function() {

$(".user-validado").validate({
debug: true,
rules: {
"user[password_confirmation]": {minlength: 5,equalTo: "#user_password"},
"user[email]": {required: true, remote:'user_check2' },
"user[username]": {required: true, remote:'user_check' }

}
});


});




