/*[[ insert most restrictive licence mankind has ever seen here c: ]]*/

#include <iostream>
#include <string>
#include <cstdint>
#include <complex>
#include <memory>
#include <fstream>
#include <chrono>

#include "newton.h"

#define FILENAME "cute_pic.ppm"
#define BLACK 0x000000FF
#define WHITE 0xFFFFFFFF
#define RED 0xFF0000FF
#define GREEN 0x00FF00FF
#define BLUE 0x0000FFFF
#define YELLOW 0xFFFF00FF
#define MAGENTA 0xFF00FFFF
#define CYAN 0x00FFFFFF

typedef std::complex<double> Complex;
typedef uint32_t Color;

constexpr uint i_width = 1500;
constexpr uint i_height = 1500;
constexpr uint max_iter = 256;

void dumpToFile(const Color* data);
void calcRoots(ispc::binding* target, const int n);

const Color colors[] = {RED, GREEN, BLUE, MAGENTA, CYAN, YELLOW};
const auto colors_size = sizeof(colors) / sizeof(Color);

int main(int argc, char** argv) {

    int n = 0;
    if(argc == 2){
        n = std::stoi(argv[1]);
    } if(n == 0) return EXIT_FAILURE;

    std::unique_ptr<Color> img_buffer(new Color[i_width * i_height]);
    std::unique_ptr<ispc::binding> roots(new ispc::binding[n]);

    calcRoots(roots.get(), n);

    auto start = std::chrono::high_resolution_clock::now();

    ispc::newtonFrac(img_buffer.get(), roots.get(), n, i_width, i_height, max_iter);

    auto stop = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::milli> elapsed = stop - start;

    std::cout << "ISPC Exec time: " << elapsed.count() << " ms\n";

    dumpToFile(img_buffer.get());

    return 0;
}

void calcRoots(ispc::binding* target, const int n){
    for(int k = 0; k < n; k++){
        const double phi = 2.0 * M_PI * (double(k)/double(n));

        const Complex c(std::cos(phi), std::sin(phi));
        const ispc::cplx cplx = {c.real(), c.imag()};

        target[k] = {cplx, colors[k % (colors_size)]};
    }
}

void dumpToFile(const Color* data){
    std::fstream file(FILENAME, std::ios::out | std::ios::trunc);
    if(!file.good()){
        file.close();
        std::cerr<<"cannot open file for whatever reason\n";
        return;
    }

    file<<"P3\n";
    file<<i_width<<"\n";
    file<<i_height<<"\n";
    file<<255<<"\n";

    for(uint i = 0; i < i_width * i_height; i++){
        const auto pxl = data[i];

        for(uint j = 1; j <= 3; j++)
            file<< ((pxl >> j * 8) & 0xFF)<<" "; //Im doing this, because data is RGBA, and im interested only in RGB; Also, no \n after every row because ppm format doesnt care, so why bother?
    }
    file.flush();
    file.close();
}