def step_definition_dir = "../features/step_definitions"
def steps = []
new File(step_definition_dir).eachFileRecurse {
    if (it.isFile() && it.name.endsWith(".java")) {	
        it.eachLine {
            def matches = it =~ /(@)([Given|When|Then])(.*)(\(\")(.*)(\".*\))/
            if (matches) {
                step = matches[0][5]
                steps << step
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
  <script src='http://code.jquery.com/jquery-latest.js'></script>
  <script type='text/javascript' src='http://imankulov.github.com/js/jquery.a-tools-1.4.1.js'></script>
  <script type='text/javascript' src='http://imankulov.github.com/js/jquery.asuggest.js'></script>  
  <script>
  \$(document).ready(function(){
    var data = "Given|When|Then|And|${writerData}".split('|');
    \$('#gherkin').asuggest(data);
    \$('#gherkin').focus();
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
            ${listData}
          </td>
        </tr>
       </table>     
    </center>
</body>
</html>"""
println html