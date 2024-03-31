#include "DSK6416_AIC23.h"
Uint32 fs=DSK6416_AIC23_FREQ_8KHZ;
#define DSK6416_AIC23_INPUT_MIC 0x0015

#define DSK6416_AIC23_INPUT_LINE 0x0011

Uint16 inputsource=DSK6416_AIC23_INPUT_LINE;

#include "bs1800int.cof"

short input_left_sample();
void output_left_sample(short);

void comm_intr();
short w[NUM_SECTIONS][2] = {0};

interrupt void c_int11()

{

short section;
short input;
int wn,yn;

input = input_left_sample();

for(section=0 ; section<NUM_SECTIONS;section++)
{

wn = input - ((a[section][0]*w [section][0])>>15) - ((a[section][1]*w[section][1])>>15);

yn = ((b[section][0]*wn)>>15) + ((b[section][1]*w[section][0])>>15) + ((b[section][2]*w [section][1])>>15);

w[section][1] = w[section][0];

w[section][0] = wn;

input = yn;

}

output_left_sample((short)(yn));
return;
}

void main()

{

comm_intr();
while(1);

}
