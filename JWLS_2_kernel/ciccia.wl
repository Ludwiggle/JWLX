StringTemplate@"

<html>
<style>
.slidecontainer {
  width: 40%;
}

.slider {
  -webkit-appearance: none;
  width: 40%;
  height: 15px;
  border-radius: 5px;
  background: #d3d3d3;
  outline: none;
  opacity: 0.7;
  -webkit-transition: .2s;
  transition: opacity .2s;
}

.slider:hover {
  opacity: 1;
}

.slider::-webkit-slider-thumb {
  -webkit-appearance: none;
  appearance: none;
  width: 25px;
  height: 25px;
  border-radius: 50%;
  background: #4CAF50;
  cursor: pointer;
}

.slider::-moz-range-thumb {
  width: 25px;
  height: 25px;
  border-radius: 50%;
  background: #4CAF50;
  cursor: pointer;
}
</style>

<body>

<input type=\"range\"  class=\"slider\"  oninput=\"refresh();\">

<span  <p> <span id='result'> </span> of `total` </p> </span>


<script>
    


  let images =[
    `ims`
  ]


  let src = \"\"

  function refresh(){
   
    document.querySelector(\"img\").setAttribute(\"src\", src)
   
    document.querySelector(\"#result\").innerHTML = output*1 + 1 
  
  }


  let fig = document.createElement(\"figure\");
  
  fig.setAttribute(\"id\",\"mysvg\")
  
  document.body.appendChild(fig)
  
  let img = document.createElement(\"IMG\")

  fig.appendChild(img);
  
  let range_slider = document.querySelector(\"input[type=range]\")
  
  range_slider.min = range_slider.value =  0
  
  range_slider.max  =  images.length - 1
  
  range_slider.step = 1
  
  let input = document.querySelector(\"#result\")
  
  let output = 0
  
  input.innerHTML = output



  document.addEventListener( 'DOMContentLoaded', (event) => {
    
    
    document.querySelector(\"input[type=range]\").addEventListener('input', (event) => {
    
    let value = range_slider.value
    
    output= value
    
    src=images[value]
    
    refresh()
    
        })
      
});

</script>

</body>
</html>
"
