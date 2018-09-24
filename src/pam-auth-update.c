#include "config/config_scanner.h"

int main( int argc, char **argv) {
    while (1) {
        int ret = cfgparse();
        if(ret != 0)
            return 1;

    };

    return 0;
}
