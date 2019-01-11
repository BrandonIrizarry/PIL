// C program for writing
// struct to file
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


struct Record {
	int x;
	char code[3];
	float value;
};


int main ()
{
    FILE *outfile;

    // open file for writing
    outfile = fopen ("airports.dat", "w");

    if (outfile == NULL)
    {
        fprintf(stderr, "\nError: cannot open file\n");
        exit (1);
    }

	struct Record atl = {1, "ATL", 50.2}; // millions of passengers
	struct Record lax = {2, "LAX", 41.2};
	struct Record ord = {3, "ORD", 38.5};
	struct Record dfw = {4, "DFW", 31.8};
	struct Record den = {5, "DEN", 29.8};

    // write structs to the file
    fwrite (&atl, sizeof(struct Record), 1, outfile);
    fwrite (&lax, sizeof(struct Record), 1, outfile);
	fwrite (&ord, sizeof(struct Record), 1, outfile);
	fwrite (&dfw, sizeof(struct Record), 1, outfile);
	fwrite (&den, sizeof(struct Record), 1, outfile);

    if(fwrite != 0)
        printf("contents to file written successfully !\n");
    else
        printf("error writing file !\n");

    // close file
    fclose (outfile);

    return 0;
}
