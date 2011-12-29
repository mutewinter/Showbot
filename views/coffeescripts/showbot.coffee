jQuery(document).ready(->
  # Cosmetic
  $("abbr.timeago").timeago()
  if (Modernizr.touch)
    # Remove hover events for Touch devices since they screw up rendering
    $(".hover").removeClass("hover")
  $('.heart').show()

  # Table Sorting
  $("table.sortable").tablesorter(
    textExtraction: table_text_extraction
    sortList: [[2,1]]
  )
)

table_text_extraction = (element) ->
  $element = $(element)
  text = $element.html()
  $abbr = $element.find('abbr')
  
  # If this is a date column, extract the text for sorting
  if $abbr.length
    text = $abbr.attr('title')

  text

