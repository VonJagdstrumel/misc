#include <iomanip>
#include <iostream>
#include <cstdio>
using namespace std;

int main() {
    time_t rawTime;
    tm *timeInfo;

    time(&rawTime);
    timeInfo = localtime(&rawTime);
    timeInfo->tm_mon += 1;
    timeInfo->tm_year += 1900;

    // Old school C89
    printf("%02d/%02d/%d@%02d:%02d:%02d\n", timeInfo->tm_mday, timeInfo->tm_mon, timeInfo->tm_year, timeInfo->tm_hour, timeInfo->tm_min, timeInfo->tm_sec);

    // C++
    cout << setfill('0') <<
            setw(2) << timeInfo->tm_mday << '/' << setw(2) << timeInfo->tm_mon << '/' << timeInfo->tm_year <<
            '@' <<
            setw(2) << timeInfo->tm_hour << ':' << setw(2) << timeInfo->tm_min << ':' << setw(2) << timeInfo->tm_sec <<
            endl;

    return 0;
}
