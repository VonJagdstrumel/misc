#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <netdb.h>
#include <unistd.h>

#ifndef htonll
#define htonll(x) ((((uint64_t)htonl(x)) << 32) + htonl((x) >> 32))
#endif

#define BUFSIZE 8192
#define DESTPORT 5000

int main(int argc, char** argv) {
    int activeSocket, ret;
    struct hostent* resolvedAddr;
    struct sockaddr_in hostAddr;
    int32_t fileCount = htonl(argc - 2);
    char* buffer;
    char ackByte;
    FILE* filePtr;
    off_t fileSize;
    size_t readLength;

    if (argc < 3) {
        puts("Usage: sockfile <ip> <files...>\n");
        return 1;
    }

    activeSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (activeSocket < 0) {
        perror("socket");
        return 1;
    }

    resolvedAddr = gethostbyname(argv[1]);
    if (resolvedAddr == NULL) {
        herror("gethostbyname");
        return 1;
    }

    memset(&hostAddr, 0, sizeof(hostAddr));
    hostAddr.sin_family = AF_INET;
    hostAddr.sin_port = htons(DESTPORT);
    memcpy(&hostAddr.sin_addr, resolvedAddr->h_addr, resolvedAddr->h_length);

    ret = connect(activeSocket, (struct sockaddr*) &hostAddr, sizeof(hostAddr));
    if (ret < 0) {
        perror("connect");
        exit(1);
    }

    // TODO: Convert from machine-endian to little endian
    ret = write(activeSocket, &fileCount, sizeof(fileCount));
    if (ret < 0) {
        perror("write");
        exit(1);
    }

    buffer = (char*) malloc(BUFSIZE);

    puts("Sending files...");

    for (int i = 2; i < argc; ++i) {
        ret = read(activeSocket, &ackByte, sizeof(ackByte));
        if (ret < 0) {
            perror("read");
            return 1;
        }

        if (ackByte != 0) {
            filePtr = fopen(argv[i], "r");
            if (filePtr == NULL) {
                perror("fopen");
            }

            fseek(filePtr, 0, SEEK_END);
            fileSize = htonll(ftello(filePtr));
            rewind(filePtr);

            printf("Sending info for \"%s\"...", argv[i]);

            ret = write(activeSocket, &fileSize, sizeof(fileSize));
            if (ret < 0) {
                perror("write");
                return 1;
            }

            printf("Sending data for \"%s\"...", argv[i]);

            for (;;) {
                readLength = fread(buffer, 1, BUFSIZE, filePtr);
                if (ferror(filePtr)) {
                    perror("fread");
                    return 1;
                }

                if (readLength == 0) {
                    break;
                }

                ret = write(activeSocket, buffer, readLength);
                if (ret < 0) {
                    perror("write");
                    return 1;
                }
            }

            printf("File \"%s\" sent successfully.", argv[i]);

            fclose(filePtr);
        } else {
            puts("Send cancelled by remote.");
        }
    }

    free(buffer);

    return 0;
}
