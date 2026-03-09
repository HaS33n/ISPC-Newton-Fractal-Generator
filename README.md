# ISPC-Newton-Fractal-Generator
![Logo](/img.png)

This is simple program that generates Newton Fractals for the equation `z^n - 1 = 0`
Its main generating algorithm is written in [ISPC](https://ispc.github.io/) in order to reduce execution times, and was optimized specifically for SIMD parallel execution model.

## Requrements:
C++ and [ISPC compiler](https://github.com/ispc/ispc)

## Building
simply run provided makefile:
```bash
make all
```

## Usage
```bash
./frac.out n
```
where n is requested value of n in the base generating equation `z^n - 1 = 0`.
