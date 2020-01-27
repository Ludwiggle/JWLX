# JWLS_2
Minimalistic Wolfram Language Kernel for Jupyter Notebooks

### Features

* Autocompletion of WL Symbols
* WL syntax highlighting
* Graphics and *dynamic* displayed in the browser

### Installation

1. Copy `JWLS_kernel` where jupyter expects custom kernels to be, typically in `~/miniconda3/lib/python3.7/site-packages/` 
2. Run the installation script  `python JWLS_2_kernel/install.py` 
3. Check if `JWLS.sh` points the actual `wolframscript` executable, then make it globally available: `sudo cp JWLS_2.sh /usr/local/bin/JWLS

### Usage 

Run `JWLS`. 

In order to use it on a cloud compute virtual machine, open the `JWLS` script and modify the `nbAddrF` function by adding `jupyter notebook --no-browser --port=7000` . Then `screen` a session, run `JWLS` and detach it. Go back to your local machine and   `ssh -N -f -L  localhost:6001:localhost:7000  <IP>"`.
For AWS instances also add the pem. For Google Cloud follow their instructions about remote jupyter notebooks. 


### Features 



#### Graphics and *Dynamic*

There are 3 custom functions to deal with graphics and dynamical outputs:

1. `show` returns a pdf export (clickable URL) of any expression is applied to, except for images that are exported to PNG. In this way, graphics is rendered by the browser PDF reader or, in case of images, by the Jupyter file viewer.
2. `manipulate` 
3. `listanimate`
4. `refresh`






