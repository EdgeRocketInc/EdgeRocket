$(document).ready(function(){

  $('#next-page-assigned-completed').click(function(){

    var formContainer = $('.assigned-vs-completed');
    var pageNum = parseInt(formContainer.attr('data-page'));
    var newPage = pageNum + 1;

    $.ajax({
      url: 'dashboard/assigned_vs_completed/' + newPage,
      success: function(){
        console.log("Successfully rendered next page.");
        formContainer.attr('data-page', newPage);
      }
    })

  });

  $('#previous-page-assigned-completed').click(function(){

    var formContainer = $('.assigned-vs-completed');
    var pageNum = parseInt(formContainer.attr('data-page'));

    if (pageNum > 1) {
      var newPage = pageNum - 1;

      $.ajax({
        url: 'dashboard/assigned_vs_completed/' + newPage,
        success: function () {
          console.log("Successfully rendered next page.");
          formContainer.attr('data-page', newPage);
        }
      })
    }

  });
});