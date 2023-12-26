# CPU Benchmarking/Testing using nbody.c

**Scenario:** You want to test which CPU is better between some Linux machines.   

Here's what you do: Download the (small) repository mini-nbody:  
`git clone https://github.com/harrism/mini-nbody`

or alternately, copy the `nbody.c` and and `timer.h` files 
to the servers you want to test, inside e.g. `~/nbody-mini` directory.

Change `nbody.c`:  
add line: `printf("Total time: %0.3f secs\n", totalTime);`  
at the end of `main()` function  

Also, **IMPORTANT**: 
If you don't want this benchmark to stress all the CPUs - which is enabled by 
default (e.g. a machine with 8 cores will show 800% in *top* command 
if you run this program) you **MUST COMMENT**
this line that uses the *OpenMP* standard as is below:  
`//  #pragma omp parallel for schedule(dynamic)`

Thus, with the above comment the nbody program will reach 100% (**one core only 
full utilization**) and will not bring a production system to its knees by using 
all the available CPUs!

Run:
```
SRC=nbody.c
EXE=nbody
gcc -std=c99 -O3 -fopenmp -DSHMOO -o $EXE $SRC -lm -D_DEFAULT_SOURCE
./nbody
```

Notes:
- By default `nbody.c` takes as an argument `nbodies=30000`, so if you want to 
test for more time, use it as such:  
`./nbody 40000` (the larger the value of `nbodies`, more calculations are 
needed, so more CPU time)
- Of course be careful to compare the same number of nbodies between different 
servers with different CPUs.

**Conclusion:** less totalTime for one Core means better CPU (so you can safely 
say which server is the faster one :)
