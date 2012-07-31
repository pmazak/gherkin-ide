step_definition_dir = "../features/step_definitions"
steps = []
Dir.glob(File.join(step_definition_dir,'**/*.rb')).each do |step_file|
  File.new(step_file).read.each_line do |line|
    next unless line =~ /^\s*(?:Given|When|Then)\s+\//
    matches = /(Given|When|Then)\s*\/(.*)\/([imxo]*)\s*do\s*(?:$|\|(.*)\|)/.match(line).captures
    type = matches[0]
    matches[1] = Regexp.new(matches[1])
    step = matches[1].inspect
    step = step[2..step.length-3]
    steps << type + " " + step
    end
end
listData = ""
writerData = ""
steps.sort{ |a,b| a.downcase <=> b.downcase }.each do |it|
    listData << it+"<br/>"
    writerData << it+"|"
end
html = "
<html>
<head>
  <script src=\"https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js\"></script>
  <script src=\"https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.18/jquery-ui.min.js\"></script>
  <link rel=\"stylesheet\" href=\"https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.18/themes/base/jquery-ui.css\" type=\"text/css\" media=\"all\" />
  <script>
  var data = \"Given|When|Then|And|#{writerData}\".split('|');
  function resetRows() {
    var numLines = $('#gherkin').val().split(\"\\n\").length;
    $('#gherkin').attr(\"rows\", numLines);
  }
  $(document).ready(function(){
    $(window).bind('beforeunload', function(){
      return 'WARNING: YOU WILL LOSE YOUR CHANGES!!!';
    });
  
    $('#statement').autocomplete({source: data, autoFocus: true});
    resetRows();
    $('#statement').focus();
    $('#statement').keypress(function(e) {
        if(e.which == 13) {
            var oldVal = $('#gherkin').val();
            if (oldVal) {
                oldVal += \"\\n\";
            }
            var newVal = $('#statement').val();
            if (data.indexOf(newVal) < 0) {
                data.push(newVal);
                $('#statement').autocomplete(\"option\", \"source\", data);
            }
            $('#gherkin').val(oldVal+newVal);
            resetRows();
            $('#statement').val(\"\");
        }
    });    
  });
  </script>  
</head>
<body>
    <center>
       <br>
       <table>
         <tr>
          <td style='vertical-align: top'>
           <textarea wrap=\"off\" style=\"border: 2px solid black; background-color: #FFFFDD\" id=\"gherkin\" cols=\"90\" ></textarea>
           <input type=\"text\" id=\"statement\" name=\"statement\" size=\"120\">          
          </td>
          <td>
            #{listData}
          </td>
        </tr>
       </table>     
    </center>
</body>
</html>"
output = File.new("gherkin-ide.html", "w")
output.write(html)
output.close
puts "Created gherkin-ide.html"