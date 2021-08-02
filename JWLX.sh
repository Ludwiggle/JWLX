#!/bin/bash

mkdir JWLXout 2>/dev/null
mkdir /dev/shm/JWLXout 2>/dev/null

function finish {
  rm -r JWLXout
  rm -r /dev/shm/JWLXout
}

wolframscript -f JWLX_init.wl

trap finish EXIT



