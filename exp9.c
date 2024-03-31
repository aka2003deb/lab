#include <dsk6416_aic23.h>
Uint32 fs=DSK6416_AIC23_FREQ_8KHZ;
#define DSK6416_AIC23_INPUT_MIC 0x0015
#define DSK6416_AIC23_INPUT_LINE 0x0011
Uint16 inputsource=DSK6416_AIC23_INPUT_LINE;
#include <math.h>
static short in_buffer[100];
Uint32 sample_data;
short k=0;

float filter_Coeff[] = { -0.0017,-0.0020,-0.0024,-0.0027,-0.0021,
0.0000,0.0044 ,0.0117,0.0221,0.0351,0.0500,0.0655,0.0799,0.0917,
0.0994,0.1021,0.0994,0.0917,0.0799,0.0655,0.0500, 0.0351,0.0221,
0.0117,0.0044,0.0000,-0.0021,-0.0027, -0.0024,-0.0020, -0.0017};
// for fc=400Hz
float filter_Coeff[] = { -0.0017, 0.0000,0.0029,-0.0000,-0.0067, 0.0000, 0.0141,-0.0000,-
0.0268, 0.0000, 0.0491,-0.0000,-0.0969,0.0000,0.3156, 0.5008,0.3156, 0.0000,-0.0969,-
0.0000, 0.0491,0.0000,-0.0268,-0.0000,0.0141, 0.0000,-0.0067,-0.0000, 0.0029, 0.0000,-
0.0017};
// for fc=2KHz
void comm_intr();

void output_left_sample(short);
short input_left_sample();
signed int FIR_FILTER(float *h, signed int);
interrupt void c_int11()
{
l_input = input_left_sample();
l_output=(Int16)FIR_FILTER(filter_Coeff ,l_input);
output_left_sample(l_output);
return;
}
signed int FIR_FILTER(float * h, signed int x)
{
int i=0;
signed long output=0;
in_buffer[0] = x;
for(i=31;i>0;i--)
in_buffer[i] = in_buffer[i-1];
for(i=0;i<31;i++)
output = output + h[i] * in_buffer[i];
return(output);
}
void main()
{
comm_intr();
while(1);
}
