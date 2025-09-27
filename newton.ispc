#define BLACK 0x000000FF

#define EPS 0.000001f

typedef uint32 clr;

struct cplx{
    double re, im;
};

struct binding{
    cplx z;
    clr color;
};

//utils
cplx operator*(cplx a, cplx b){
    cplx result;

    result.re = a.re * b.re - a.im * b.im;
    result.im = a.re * b.im + a.im * b.re;

    return result;
}

cplx operator*(int n, cplx z){
    cplx result;

    result.re = z.re * n;
    result.im = z.im * n;
    
    return result;
}

cplx operator+(cplx a, cplx b){
    cplx result;

    result.re = a.re + b.re;
    result.im = a.im + b.im;

    return result;
}

cplx operator+(int n, cplx z){
    cplx result;

    result.re = z.re + n;
    result.im = z.im;

    return result;
}

cplx operator-(cplx a, cplx b){
    cplx result;

    result.re = a.re - b.re;
    result.im = a.im - b.im;

    return result;
}

cplx operator-(cplx z, int n){
    cplx result;

    result.re = z.re - n;
    result.im = z.im;

    return result;
}

cplx operator/(cplx a, cplx b){
    cplx res;

    double denom = b.re * b.re + b.im * b.im;
    res.re = (a.re * b.re + a.im * b.im) / denom;
    res.im = (a.im * b.re - a.re * b.im) / denom;

    return res;
}

static cplx cpow(cplx z, int exp){
    cplx result = {1.0f, 0.0f}; // jedynka
    cplx base = z;

    while (exp > 0) {
        if (exp & 1)
            result = result * base;

        base = base * base;
        exp >>= 1;
    }
    return result;
}

static cplx f(cplx z, int n){
    return cpow(z,n) - 1;
}

static cplx df(cplx z, int n){
    return n * cpow(z,n-1);
}

static inline clr adjustColor(const clr c, const uint iters){
    const double brightness = 1.0 / (1.0 + iters * 0.1);

    return c * brightness;
}

static inline clr findColor(const uint x,  const uniform uint y, const uniform uint width, const uniform uint height, const uniform uint max_iterations, const uniform int n, const uniform binding roots[]){
    const double zx = -2.5f + ((double)x / (double)(width - 1)) * 3.5f;
    const double zy = -2.0f + ((double)y / (double)(height - 1)) * 3.0f;

    cplx z = {zx,zy};
     for(uint i=0; i < max_iterations; i++){
        z = z - (f(z,n) / df(z,n));

        for(int j = 0; j < n; j++){
            const cplx diff = z - (roots[j].z);

            if(abs(diff.re) < EPS && abs(diff.im) < EPS)
                return adjustColor(roots[j].color, i);
        }
    }
    return BLACK;
}

export void newtonFrac(uniform clr buffer[], const uniform binding roots[], const uniform int n, const uniform uint width, const uniform uint height, const uniform uint max_iterations){
    for (uniform uint y = 0; y < height; y++) {
        foreach (x = 0 ... width) {
                buffer[y * width + x] = findColor(x, y, width, height, max_iterations, n, roots);
        }
    }
}