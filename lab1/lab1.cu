#include "lab1.h"
#include "PerlinNoise.h"
#include <cmath>
#include "stdio.h"
static const unsigned W = 640;
static const unsigned H = 480;
static const unsigned NFRAME = 240;


struct Lab1VideoGenerator::Impl {
	int t = 0;
};

Lab1VideoGenerator::Lab1VideoGenerator(): impl(new Impl) {
}

Lab1VideoGenerator::~Lab1VideoGenerator() {}

void Lab1VideoGenerator::get_info(Lab1VideoInfo &info) {
	info.w = W;
	info.h = H;
	info.n_frame = NFRAME;
	// fps = 24/1 = 24
	info.fps_n = 24;
	info.fps_d = 1;
};


void Lab1VideoGenerator::Generate(uint8_t *yuv) {

    
	// Create a PerlinNoise object with the reference permutation vector
	PerlinNoise pn;
	unsigned int kk = 0;
    unsigned int nn = 0;


    unsigned int rarray[240] = {0, 0, 0, 0, 0, 0, 85, 136, 187, 170, 204, 198, 170, 162, 68, 102, 193, 204, 230, 238, 221, 238, 153, 102, 0, 0, 0, 0, 0, 0, 0, 68, 85, 119, 165, 204, 255, 204, 153, 119, 85, 0, 0, 0, 0, 0, 0, 0, 119, 187, 255, 255, 255, 255, 255, 255, 136, 170, 255, 255, 255, 255, 255, 255, 204, 153, 51, 51, 51, 51, 51, 85, 85, 119, 153, 185, 233, 255, 255, 227, 210, 176, 159, 153, 153, 119, 102, 119, 119, 102, 187, 221, 255, 255, 255, 255, 255, 255, 221, 255, 255, 255, 255, 255, 255, 255, 238, 204, 153, 187, 170, 153, 204, 204, 204, 204, 209, 232, 240, 255, 255, 240, 232, 209, 204, 204, 204, 204, 153, 170, 187, 153, 204, 238, 255, 255, 255, 255, 255, 255, 255, 221, 255, 255, 255, 255, 255, 255, 221, 187, 102, 119, 119, 102, 119, 153, 153, 159, 176, 210, 227, 255, 255, 233, 185, 153, 119, 85, 85, 51, 51, 51, 51, 51, 153, 204, 255, 255, 255, 255, 255, 255, 170, 136, 255, 255, 255, 255, 255, 255, 187, 119, 0, 0, 0, 0, 0, 0, 0, 85, 119, 153, 204, 255, 204, 165, 119, 85, 68, 0, 0, 0, 0, 0, 0, 0, 102, 153, 238, 221, 238, 230, 204, 193, 102, 68, 162, 170, 198, 204, 170, 187, 136, 85, 0, 0, 0, 0, 0, 0 };
    unsigned int garray[240] = {60, 136, 170, 170, 170, 170, 170, 170, 187, 119, 102, 51, 0, 0, 68, 102, 0, 0, 63, 119, 170, 238, 221, 221, 221, 221, 221, 221, 159, 68, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 102, 187, 255, 255, 255, 255, 255, 255, 255, 187, 136, 85, 0, 0, 136, 170, 68, 51, 119, 170, 204, 255, 255, 255, 255, 255, 255, 255, 204, 153, 85, 68, 85, 79, 62, 62, 119, 142, 142, 136, 136, 153, 187, 221, 255, 255, 255, 255, 255, 255, 255, 221, 187, 164, 136, 136, 221, 255, 183, 204, 200, 221, 238, 255, 255, 255, 255, 255, 255, 255, 238, 221, 204, 187, 187, 204, 187, 179, 179, 187, 204, 187, 187, 204, 221, 238, 255, 255, 255, 255, 255, 255, 255, 238, 221, 200, 204, 183, 255, 221, 136, 136, 164, 187, 221, 255, 255, 255, 255, 255, 255, 255, 221, 187, 153, 136, 136, 142, 142, 119, 62, 62, 79, 85, 68, 85, 153, 204, 255, 255, 255, 255, 255, 255, 255, 204, 170, 119, 51, 68, 170, 136, 0, 0, 85, 136, 187, 255, 255, 255, 255, 255, 255, 255, 187, 102, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 68, 159, 221, 221, 221, 221, 221, 221, 238, 170, 119, 63, 0, 0, 102, 68, 0, 0, 51, 102, 119, 187, 170, 170, 170, 170, 170, 170, 136, 60};
    unsigned int barray[240] = {157, 168, 170, 136, 85, 0, 0, 0, 0, 0, 0, 0, 0, 85, 68, 102, 102, 0, 0, 0, 0, 0, 0, 0, 0, 119, 170, 221, 204, 187, 204, 204, 221, 187, 204, 204, 255, 255, 255, 255, 255, 255, 255, 255, 255, 204, 153, 0, 0, 0, 0, 0, 0, 17, 0, 136, 136, 170, 170, 51, 68, 51, 34, 51, 51, 51, 51, 170, 221, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 238, 204, 102, 102, 119, 119, 85, 102, 136, 136, 194, 221, 255, 221, 204, 180, 170, 153, 187, 187, 153, 153, 238, 238, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 238, 238, 153, 153, 187, 187, 153, 170, 180, 204, 221, 255, 221, 194, 136, 136, 102, 85, 119, 119, 102, 102, 204, 238, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 221, 170, 51, 51, 51, 51, 34, 51, 68, 51, 170, 170, 136, 136, 0, 17, 0, 0, 0, 0, 0, 0, 153, 204, 255, 255, 255, 255, 255, 255, 255, 255, 255, 204, 204, 187, 221, 204, 204, 187, 204, 221, 170, 119, 0, 0, 0, 0, 0, 0, 0, 0, 102, 102, 68, 85, 0, 0, 0, 0, 0, 0, 0, 0, 85, 136, 170, 168, 157};

    uint8_t y_channel[W*H];
    uint8_t u_channel[W*H];
    uint8_t v_channel[W*H];
    uint8_t u_yuv420[W*H/4];
    uint8_t v_yuv420[W*H/4];

    // (cos(alpha), cos(theta)*cos(alpha), sin(theta))
    double pi = 3.14159265;
    double alpha = 45;
    double theta = 1.5*(impl->t);
    double cos_a = cos(alpha*pi/180);
    double sin_a = sin(alpha*pi/180);
    double cos_t = cos(theta*pi/180);
    double sin_t = sin(theta*pi/180);

    unsigned int r = 0;
    unsigned int g = 0;
    unsigned int b = 0;

	// Visit every pixel of the image and assign a color generated with Perlin noise
    for(unsigned int i = 0; i < H; ++i) {     // y
        for(unsigned int j = 0; j < W; ++j) {  // x
            double x = (double)j/((double)W);
			double y = (double)i/((double)H);

            
			// Wood like structure
			double n = 20 * pn.noise(x+cos_a, y+(cos_a*2*cos_t), 2*sin_t);
			n = n - floor(n);

			// Map the values to the [0, 255] interval, for simplicity we use 
			// tones of grey
			r = floor(rarray[(impl->t)%240] * n);
			g = floor(garray[(impl->t)%240] * n);
			b = floor(barray[(impl->t)%240] * n);

            y_channel[kk] = uint8_t(floor( 0.229*double(r) + 0.587*double(g) + 0.114*double(b)));
            u_channel[kk] = uint8_t(floor(-0.169*double(r) - 0.331*double(g) + 0.500*double(b)) + 128);
            v_channel[kk] = uint8_t(floor( 0.500*double(r) - 0.419*double(g) - 0.081*double(b)) + 128);


            if(i%2==1 && j%2==1){ // y odd and x odd
                uint8_t u_mean;
                uint8_t v_mean;
                
                u_mean = uint8_t(floor((float(u_channel[(i-1)*W+j-1]) + float(u_channel[(i-1)*W+j]) + float(u_channel[i*W+j-1]) + float(u_channel[i*W+j]))/4));
                v_mean = uint8_t(floor((float(v_channel[(i-1)*W+j-1]) + float(v_channel[(i-1)*W+j]) + float(v_channel[i*W+j-1]) + float(v_channel[i*W+j]))/4));
                
                u_yuv420[nn] = u_mean;
                v_yuv420[nn] = v_mean;
                nn++;
            }
            kk++;
		}
	}
	// Save the image in a binary PPM file
    cudaMemcpy(yuv, y_channel, W*H, cudaMemcpyHostToDevice);
    cudaMemcpy(yuv+W*H, u_yuv420, W*H/4, cudaMemcpyHostToDevice);
    cudaMemcpy(yuv+W*H+W*H/4, v_yuv420, W*H/4, cudaMemcpyHostToDevice);
	++(impl->t);
}
