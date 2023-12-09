#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>

int main() {
    long long int size = 1024LL * 1024LL * 1024LL; // 1 GB in bytes
    long long int sleep_s = 60 * 60 * 24 * 7;      // 1 week

    setvbuf(stdout, NULL, _IONBF, 0);
    printf("My PID: %i, I will hoard %lld B then sleep for %lld s", getpid(), size, sleep_s);

    void *ptr = malloc(size);
    if (ptr != NULL) {
        memset(ptr, 0, size);
    }

    sleep(sleep_s);
    return 0;
}
