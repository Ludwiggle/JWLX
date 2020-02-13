# JWLX

Jupyter notebooks for Wolfram Language on Linux. 


### Features

* Autocompletion of WL Symbols
* WL syntax highlighting
* Graphics and interactive objects handled by the browser

### Installation

1. Copy `JWLS_kernel` folder where jupyter expects custom kernels to be, typically in `~/miniconda3/lib/python3.7/site-packages/` 
2. Run the installation script  `python JWLS_2_kernel/install.py` 
3. Check if `JWLS.sh` points the actual `wolframscript` executable, then make it globally available: `sudo cp JWLS_2.sh /usr/local/bin/JWLS`

### Usage 

Run `JWLS`. 


#### Remote Notebooks

In order to use it on a cloud compute virtual machine, edit the `JWLS` script at the `nbAddrF` function definition by adding `jupyter notebook --no-browser --port=7000` . Then `screen` a session, run `JWLS` and detach it (Ctrl A + Ctrl D). Go back to your local machine and   `ssh -N -f -L  localhost:6001:localhost:7000  <IP>"`.
For AWS instances also add the pem. For Google Cloud follow their instructions about remote jupyter notebooks. 


### Features 



#### Graphics and Interactivity

There are 3 custom functions to deal with graphics and dynamical outputs:

1. `show` returns a URL of the pdf export of any expression, except for images that are exported to PNG. By clicking the URL, graphics graphics gets rendered by the browser PDF reader or, in case of images, by the Jupyter file viewer.

2. `manipulate` mimics Manipuate and it returns a dynamic HTML page with a single slider; multiple sliders or different types of controllers are not supported yet. Valid expressions are  `manipulate[Hold @ expr, {u, u_min, u_max, du}]` or  `manipulate[Hold @ exp, {u, u_min, u_max}]` with a default value of `du`=1/10 or the interval. **Note:** To wrap `expr` in `Hold` is necessary in most cases.  
At every change of the slider value, the JS script sends a POST request to the Wolfram Engine that provides an `HTTPResponse`.  

3. `refresh` works similarly to `manipulate` there is no slider; the JS script automatically sends POST requests at regular intervals.  Valid syntax is `refresh[expr, dt]`  or `refresh[expr]`  with a default update interval `dt`= 1s.

4. `listanimate` mimics ListAnimate and it gives the smoothest experience insofar all outputs are preemptively saved in RAM. Valid syntax is `listanimate[{e_1, e_2, .., e_N}]`.




