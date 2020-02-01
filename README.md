# JWLS_2
Minimalistic Wolfram Language Kernel for Jupyter Notebooks

### Features

* Autocompletion of WL Symbols
* WL syntax highlighting
* Graphics and *dynamic* displayed in the browser

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



#### Graphics and *Dynamic*

There are 3 custom functions to deal with graphics and dynamical outputs:

1. `show` returns a a clickable URL of the pdf export of any expression is applied to, except for images that are exported to PNG. In this way, graphics is rendered by the browser PDF reader or, in case of images, by the Jupyter file viewer.
2. `manipulate` mimics `Manipulate` and it returns an HTML+JS page with a single slider; multiple sliders or different types of controllers are not supported yet. 
3. `listanimate`
4. `refresh`






