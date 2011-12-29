jQuery(document).ready(->
  # Cosmetic
  $("abbr.timeago").timeago()
  if (Modernizr.touch)
    # Remove hover events for Touch devices since they screw up rendering
    $(".hover").removeClass("hover")
  $('.heart').show()

  # Table Sorting
  $("table.sortable").tablesorter()
)
