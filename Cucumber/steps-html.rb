step_definition_dir = "../features/step_definitions"
steps = []
Dir.glob(File.join(step_definition_dir,'**/*.rb')).each do |step_file|
  File.new(step_file).read.each_line do |line|
    next unless line =~ /^\s*(?:Given|When|Then)\s+\//
    matches = /(?:Given|When|Then)\s*\/(.*)\/([imxo]*)\s*do\s*(?:$|\|(.*)\|)/.match(line).captures
    matches[0] = Regexp.new(matches[0])
    step = matches[0].inspect
    steps << step[2..step.length-3]
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
  <script src='http://code.jquery.com/jquery-latest.js'></script>
  <script type='text/javascript' src='http://imankulov.github.com/js/jquery.a-tools-1.4.1.js'></script>
  <script type='text/javascript' src='http://imankulov.github.com/js/jquery.asuggest.js'></script>  
  <script>
  $(document).ready(function(){
    var data = \"Given|When|Then|And|#{writerData}\".split('|');
    $('#gherkin').asuggest(data);
    $('#gherkin').focus();
  });
  </script>  
</head>
<body>
    <center>
       <br>
       <table>
         <tr>
          <td style='vertical-align: top'>
           <textarea style='border: 2px solid black; background-color: #FFFFDD' id='gherkin' cols=80 rows=40 ></textarea>
          </td>
          <td>
            #{listData}
          </td>
        </tr>
       </table>     
    </center>
</body>
</html>"
puts html