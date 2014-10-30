$(document).ready( function() {

  if ($(".alert-bookstore").text().trim().length > 0) {
    var height = parseInt($(".center-window").css("height"));
//    if (window.location.pathname == '/users/sign_in' || window.location.pathname == '/users/sign_up') {
      height += parseInt($("#end-of-header").css('height'));
//    }
    $(".center-window").css("height", height).toString();
    $(".alert-bookstore").show("slow");
  }
});