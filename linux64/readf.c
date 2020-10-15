#include <stdio.h>
#include <stdlib.h>

void printres(int res) {
    printf("res: %d\n", res);
}

int main() {
    FILE *f = fopen("./filecreate.txt", "r+");
    if (f == NULL) {
        perror("fopen");
        return EXIT_FAILURE;
    }
    int res = fseek(f, 0, SEEK_END);
    if (res == -1) {
        perror("fseek");
        return EXIT_FAILURE;
    }
    printres(res);
    char append[] = "\n-appended-\n";
    res = fprintf(f, "%s", append);
    printres(res);
    return 0;
}
