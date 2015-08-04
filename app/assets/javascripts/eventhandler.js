$(function(){

  // default sections hidden
  $(".twitter").hide();
  $(".stackoverflow").hide();

  // Buttons - Hiding and Showing
  function buttonSelect(button, select, unselect1, unselect2) {
    $(button).on('click', function(){
      $(select).show();
      $(unselect1).hide();
      $(unselect2).hide();
    });
  }
  // Instantiating buttons
  buttonSelect(".twitter-btn", ".twitter", ".first", ".stackoverflow");
  buttonSelect(".stackoverflow-btn", ".stackoverflow", ".first", ".twitter");


});
