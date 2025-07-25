# shl-assessment
SHL Assesment practice questions solved with perl

These are my solutions to some (47) practice questions I received to pass the SHL Assessment

https://www.shl.com/shldirect/en/practice-tests/

I chose perl because it's the best scripting language to practice solving programming challenges:

- You can store the data right in the script after a __DATA__ marker.
- You can switch between reading standard input and from __DATA__ rather easily. use --test on command line to read the internal data.
- It's great at text manipuation and everything else.


## Run a question with internal data.
./q10-resource-allocation.pl --test

## Run a question with a file of external data.
./q10-resource-allocation.pl < q10.dat
