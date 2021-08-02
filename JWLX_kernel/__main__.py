from ipykernel.kernelapp import IPKernelApp
from . import JWLX_kernel

IPKernelApp.launch_instance(kernel_class=JWLX_kernel)