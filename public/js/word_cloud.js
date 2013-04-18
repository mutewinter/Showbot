$(document).ready(function() {
  WebFontConfig = {
      google: { families: [ 'Goudy+Bookletter+1911::latin' ] }, 
      fontactive: function(fontFamily, FontDescription) { make_all_clouds(); }
  };
  (function() {
    var wf = document.createElement('script');
    wf.src = ('https:' == document.location.protocol ? 'https' : 'http') +
      '://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';
    wf.type = 'text/javascript';
    wf.async = 'true';
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(wf, s);
  })();

  var fill = d3.scale.category20b();

  var w = 960,
      h = 600;

  var fontSize;

  var layout = d3.layout.cloud()
      .size([w, h])
      .rotate(function() { return (Math.random() < 0.85) ? 0 : 90; })
      .font("\"Goudy Bookletter 1911\"")
      .fontSize(function(d) { return fontSize(+d.value); })
      .text(function(d) { return d.key; })
      .spiral("archimedean")
      .on("end", draw);

  function draw(words, bounds) {
    scale = bounds ? Math.min(
      w / Math.abs(bounds[1].x - w / 2),
      w / Math.abs(bounds[0].x - w / 2),
      h / Math.abs(bounds[1].y - h / 2),
      h / Math.abs(bounds[0].y - h / 2)) / 2 : 1;
    d3.select("#content")
    .append("svg")
        .attr("width", w)
        .attr("height", h)
      .append("g")
        .attr("transform", "translate(" + [w >> 1, h >> 1] + ")scale(" + scale + ")")
      .selectAll("text")
        .data(words)
      .enter().append("text")
        .style("font-size", function(d) { return d.size + "px"; })
        .style("font-family", "\"Goudy Bookletter 1911\"")
        .style("fill", function(d, i) { return fill(i); })
        .attr("text-anchor", "middle")
        .attr("transform", function(d) {
          return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
        })
        .text(function(d) { return d.text; });
  }

  function make_cloud(show, data) {
    d3.select("#content").append("h2")
      .text(show).attr("class", "show_break");
    layout.words(data).start();
  };

  fontSize = d3.scale.linear().range([5, 55]);

  function make_all_clouds() {
    cloudData = $('#cloud-data').data('cloud-data');
    jQuery.each(cloudData, function(i, cloudDatum) {
      make_cloud(cloudDatum.title, cloudDatum.data);
    });
  };
});
