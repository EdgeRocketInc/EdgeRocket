$(document).ready(function(){

  var formContainer = $('.assigned-vs-completed');
  var totalUsers = parseInt(formContainer.attr('data-total-users'));
  var pageNum = parseInt(formContainer.attr('data-page'));

  $('#next-page-assigned-completed').click(function(){
    var totalUsers = parseInt(formContainer.attr('data-total-users'));
    var pageNum = parseInt(formContainer.attr('data-page'));
    var newPage = pageNum + 1;

    $.ajax({
      url: 'dashboard/assigned_vs_completed/' + newPage,
      success: function(){
        console.log("Successfully rendered next page.");
        formContainer.attr('data-page', newPage);
        setPaginationInfo(newPage, totalUsers);
      }
    })

  });

  $('#previous-page-assigned-completed').click(function(){
    var totalUsers = parseInt(formContainer.attr('data-total-users'));
    var pageNum = parseInt(formContainer.attr('data-page'));

    if (pageNum > 1) {
      var newPage = pageNum - 1;

      $.ajax({
        url: 'dashboard/assigned_vs_completed/' + newPage,
        success: function () {
          console.log("Successfully rendered next page.");
          formContainer.attr('data-page', newPage);
          setPaginationInfo(newPage, totalUsers);
        }
      })
    }

  });

  var setPaginationInfo = function(currentPage, totalUsers){
    console.log("SETTING PAGINATION");

    var pageStart = (currentPage - 1) * 20 + 1;
    var pageEnd = currentPage * 19 + 1;

    if (pageEnd > totalUsers){
      pageEnd = totalUsers;
      if (pageStart - 20 < 1){
        pageStart = 1;
      }
    }

    $('#current-page-info').html(
     "Displaying " + pageStart + " - " + pageEnd + " of " + totalUsers + " Total Employees"
    )
  };

  setPaginationInfo(pageNum, totalUsers);
});