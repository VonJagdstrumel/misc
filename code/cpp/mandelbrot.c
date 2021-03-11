#include <stdio.h>
#include <math.h>
#include <string.h>

typedef struct {
    double r;
    double i;
} complex_t;

typedef struct __attribute__((__packed__)) {
    int8_t bfType[2];
    int32_t bfSize;
    int8_t bfReserved[4];
    int32_t bfOffBits;
    int32_t biSize;
    int32_t biWidth;
    int32_t biHeight;
    int16_t biPlanes;
    int16_t biBitCount;
    int8_t biDummy[24];
} bmp_header_t;

typedef struct {
    uint8_t red;
    uint8_t green;
    uint8_t blue;
} bmp_pixel_t;

complex_t add(complex_t c1, complex_t c2) {
    return (complex_t) {
        c1.r + c2.r,
        c1.i + c2.i
    };
}

complex_t square(complex_t c) {
    return (complex_t) {
        c.r * c.r + c.i * c.i * -1,
        c.i * c.r * 2
    };
}

void bmp_prepare(short width, short height) {
    bmp_header_t bmpHeader;
    size_t headerSize = sizeof(bmp_header_t);
    memset(&bmpHeader, 0, headerSize);

    memcpy(bmpHeader.bfType, "BM", 2);
    bmpHeader.bfSize = headerSize + width * height * 3;
    bmpHeader.bfOffBits = headerSize;
    bmpHeader.biSize = 40;
    bmpHeader.biWidth = width;
    bmpHeader.biHeight = height;
    bmpHeader.biPlanes = 1;
    bmpHeader.biBitCount = 24;

    fwrite(&bmpHeader, headerSize, 1, stdout);
}

void bmp_draw(bmp_pixel_t* pixel, size_t count) {
    fwrite(pixel, sizeof(bmp_pixel_t), count, stdout);
}

int main(int args, char** argv) {
    short width = 2048;
    short height = 2048;
    short iMax = 2048;
    short iteration;
    double diameter = 0.0001; //3;

    complex_t base = { -0.02517, -0.79789 }; //{ -0.75, 0 };
    complex_t cMin = { base.r - diameter / 2, base.i - diameter / 2 };
    complex_t current;
    complex_t result;
    bmp_pixel_t pixel;

    bmp_prepare(width, height);

    for(short y = 0; y < height; ++y) {
        current.i = cMin.i + diameter * y / height;

        for(short x = 0; x < width; ++x) {
            current.r = cMin.r + diameter * x / width;
            result = (complex_t) { 0, 0 };

            for(iteration = 0; iteration < iMax; ++iteration) {
                result = add(square(result), current);

                if(isfinite(result.r) == 0 || isfinite(result.i) == 0) {
                    break;
                }
            }

            if(iteration < iMax) {
                pixel = (bmp_pixel_t) { 255, 255, 255 };
            }
            else {
                pixel = (bmp_pixel_t) { 0, 0, 0 };
            }

            bmp_draw(&pixel, 1);
        }
    }

    return 0;
}
