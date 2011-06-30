$(document).ready(function() {
  jQuery("abbr.timeago").timeago();

  // votes
  $('a.up').live('click', function() {
      var $link = $(this),
          url = $link.attr('href');
      $.get(url, function(response) {
          // the response is just the votes.
          if (!isNaN(parseInt(response))) {
              $link.next('.votes').html(response);
          } else {
              alert(response);
          }
      });
      $link.addClass('voted');
      return false;
  });
});

