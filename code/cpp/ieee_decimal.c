#include <stdio.h>

// Parse decimal number to IEE binary representation
// TODO: Double-precision support

int main(int argc, char** argv) {
	char sBinary[33]; // Init IEEE single precision representation
	sBinary[32] = 0; // Null terminate
	float fValue;
	long lBuf;

	if(scanf("%f", &fValue) != 1) // Get float val
		return 1; // Bad input is bad
	lBuf = *(long*) &fValue; // Cast to long int for... WAIT, WHAT KIND OF SORCERY IS THIS?!
	for(short i = 32; i > 0; lBuf >>= 1) // Parse every bit
		sBinary[--i] = (lBuf & 1) + '0'; // Get leftmost bit then store as ASCII char
	printf("%s", sBinary); // Print binary string
	return 0; // Everything was ok
}
