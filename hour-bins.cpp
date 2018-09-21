#include <string.h>
#include <time.h>
#include <stdlib.h>
#include <sstream>
#include <fstream>
#include <iostream>
#include <unistd.h>

int main() {

    time_t  current_time;
    char*   c_time_string;

    int     i;

    long    secshour=3600;
    long     secsday=86400; 
    long    secsweek=604800;


    struct days_eM {
       // start second,   end second
       long ssec, esec;
       // emission
       float Emmy;
    };


    // first & last unix time stamps in the series
    long alfa =1405234800;
    long omega=1533906654;
    long span = omega - alfa;

    // how many: enough bins for every hour in the time span
    long totbins = trunc(span / secshour) +1;

    long hours[totbins];
    // for every hour, store start, end seconds and emission within that time span
    hours_eM dMarks[totbins];

    days[0]=alfa;
    for (i=1; i<totbins; i++){
        days[i] = alfa + i*secshour;
        // printf("Day %d: %ld %ld\n",i, days[i-1],days[i]);	
        dMarks[i].ssec=hours[i-1];
        dMarks[i].esec=hours[i];
        dMarks[i].Emmy=0.0;
    }

    // system("pause");  // MS Windows
    // Both of these work on Linux:
    /* pause();
    getchar(); */

    /* Obtain current time. */
    current_time = time(NULL);

    if (current_time == ((time_t)-1))
    {
        (void) fprintf(stderr, "Failure to obtain the current time.\n");
        exit(EXIT_FAILURE);
    }

    /* Convert to local time format. */
    c_time_string = ctime(&current_time);

    if (c_time_string == NULL)
    {
        (void) fprintf(stderr, "Failure to convert the current time.\n");
        exit(EXIT_FAILURE);
    }

    // Note: compile as 'g++ day-bins.cpp'    or    'gcc day-bins.cpp  -lstdc++'
    //    (https://stackoverflow.com/questions/9447428/very-simple-program-not-working-in-c)
    // std::ifstream infile("~/bitmark-plots/Bitmark.emission.0-497154.log");
    std::string   line;
    std::ifstream infile("~/bitmark-plots/MARKS.emission");
    i=0;
    int currday=0;
    while (std::getline(infile, line))
    //while ( infile >> a >> b >> c >> d)
    {
        i++;
	std::istringstream iss(line);
        int a, b;
	float c, d;
        int bin;
	//printf("%s \n",line);
	/* std::cout << line; */
        if (!(iss >> a >> b >> c >>d)) { 
		printf("\nOut of while loop !\n"); 
		break; 
	} // error
	/* printf("%d: %d  %d %f %f\n",i,a,b,c,d); */
        bin=(b-alfa)/secshour; 
        if (bin != currday) {
              printf("Day %d: %f\n",bin,dMarks[bin-1].Emmy); 
              currday=bin;
	      //getchar();
        }
        dMarks[bin].Emmy+=c;  // Add the block's reward to that day's bin 
        /* printf(" %f ",dMarks[bin].Emmy); */

    }

    std::ofstream outfile("~/bitmark-plots/MARKS-daily-output");
    std::ofstream markfile("~/bitmark-plots/MARKS.daily.dat");
    for (i=1; i<1490; i++){
      printf("Day %d: %f\n",i,dMarks[i].Emmy); 
      // if (i % 24 == 0) getchar();
      if (outfile.is_open()) {
	    outfile<< i << ":  " << dMarks[i].esec << "  " << dMarks[i].Emmy << std::endl;
      }
      if (markfile.is_open()) {
	    markfile<< dMarks[i].ssec << " " << dMarks[i].esec << "   " << dMarks[i].Emmy << std::endl;
      }
    };
    outfile.close();
    markfile.close();

    /* Print to stdout. ctime() has already added a terminating newline character. */
    (void) printf("Current time is %s", c_time_string);
    exit(EXIT_SUCCESS);

}
