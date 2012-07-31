def step_definition_dir = "../features/step_definitions"
def steps = []
new File(step_definition_dir).eachFileRecurse {
    if (it.isFile() && it.name.endsWith(".java")) {	
        it.eachLine {
            def matches = it =~ /(@)([Given|When|Then])(.*)(\(.*\"\^)(.*)(\".*\))/
            if (matches) {
                type = matches[0][2]+matches[0][3]
                step = matches[0][5].trim()
                if (step.endsWith("\$")) {
                  step = step[0..step.length()-2]
                }
                steps << type + " " + step
                if ("Given" == type) {
                   steps << "And" + " " + step
                }
            }
        }
    }
}
def writerData = ""
def listData = ""
steps.sort{ it.toLowerCase() }.each {
    listData += it+"<br/>"
    writerData += it+"|"		
}

def html = """
<html>
<head>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
  <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.18/jquery-ui.min.js"></script>
  <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.18/themes/base/jquery-ui.css" type="text/css" media="all" />
  <script>
  var data = "Given|When|Then|And|${writerData}".split('|');
  function resetRows() {
    var numLines = \$('#gherkin').val().split("\\n").length;
    \$('#gherkin').attr("rows", numLines);
  }
  \$(document).ready(function(){
    \$(window).bind('beforeunload', function(){
      return 'WARNING: YOU WILL LOSE YOUR CHANGES!!!';
    });
  
    \$('#statement').autocomplete({source: data, autoFocus: true});
    resetRows();
    \$('#statement').focus();
    \$('#statement').keypress(function(e) {
        if(e.which == 13) {
            var oldVal = \$('#gherkin').val();
            if (oldVal) {
                oldVal += "\\n";
            }
            var newVal = \$('#statement').val();
            if (data.indexOf(newVal) < 0) {
                data.push(newVal);
                \$('#statement').autocomplete("option", "source", data);
            }
            \$('#gherkin').val(oldVal+newVal);
            resetRows();
            \$('#statement').val("");
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
           <textarea wrap="off" style="border: 2px solid black; background-color: #FFFFDD" id="gherkin" cols="90" ></textarea>
           <input type="text" id="statement" name="statement" size="120">          
          </td>
          <td>
            ${listData}
          </td>
        </tr>
       </table>     
    </center>
</body>
</html>"""
new File("gherkin-ide.html").text = html
println "Created gherkin-ide.html"