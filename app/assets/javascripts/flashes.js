$(document).ready(function() {
  if ($(".alert").length > 0) {
    setTimeout(function() {
      $(".alert").slideUp()
    }, 2000);
  }
});
