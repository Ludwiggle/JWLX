from ipykernel.kernelapp import IPKernelApp
from . import JWLS_2_kernel

IPKernelApp.launch_instance(kernel_class=JWLS_2_kernel)
