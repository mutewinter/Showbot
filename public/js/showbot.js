$(document).ready(function() {
  jQuery("abbr.timeago").timeago();

  $('.suggestion').click(function(e) {
    e.preventDefault();
    $(this).toggleClass('hover_effect');
  });

  $('.suggestion').bind("mouseout", function(e) {
    $(this).removeClass('hover_effect');
  });
  
});

