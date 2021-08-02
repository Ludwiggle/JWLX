StringTemplate@"
<html>
<body>

<div id='result'></div>
    
<script>
    
    setInterval( refresher, '`dt`' );
    
    function refresher() {
    
        const request = new XMLHttpRequest();
        const url = 'http://127.0.0.1:5859';
        data = '`f`';
        
        request.onload = function() {
            document.getElementById('result').innerHTML = request.responseText;
        }
        
        request.open('POST', url, true);
        request.send(data + '// ReleaseHold');
        console.log(data);
    }
    
</script>

</body>
</html>
"
