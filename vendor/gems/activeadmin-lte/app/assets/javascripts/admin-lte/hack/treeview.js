$(document).ready(function() {
  $('.has_nested > a').click(function(event) {
    if ($(this).parent().hasClass('active')) {
      console.log('hide');
      $(this).find('.main-menu-dropdown-caret')
      .removeClass('fa-caret-down')
      .addClass('fa-caret-left')
    }else{
      $(this).find('.main-menu-dropdown-caret')
      .removeClass('fa-caret-left')
      .addClass('fa-caret-down')
      console.log('show');
    }
  });
});
