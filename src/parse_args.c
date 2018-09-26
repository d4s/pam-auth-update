/**
 * @file parse_args.c
 * @author Denis Pynkin (d4s) <denis.pynkin@collabora.com>
 * @brief 
 */

#include <getopt.h>
#include <string.h>
#include <pam-auth-update.h>
#include <parse_args.h>

void help(void) {
    printf(
            "%s. v.%s\n"
            "Usage: pam-auth-update [--package] [--remove] [--force]\n",
            PACKAGE_NAME, PACKAGE_VERSION, COPYRIGHT_YEAR);

}

// Parse command line arguments
int parse_args(args_t *args, int argc, char **argv){

    memset(args, 0, sizeof(args_t));
    
    while(1) {
        int c;
        int option_index = 0;
        static struct option long_options[] = {
            {"package", no_argument, 0, 'p' },
            {"remove",  no_argument, 0, 'r' },
            {"force",   no_argument, 0, 'f' },
            {"help",    no_argument, 0, 'h' },
            {"configdir", required_argument, 0, 'C' },
            {"templatedir", required_argument, 0, 'T' },
            {"outputdir", required_argument, 0, 'O' },
            {0, 0, 0, 0 }
        };

        c = getopt_long_only(argc, argv, "",
                long_options, &option_index);
        if (c == -1)
            break;

        DBGPRINT("option %s\n", long_options[option_index].name);

        switch (c) {
            case 'p':
                args->package = 1;
                break;
            case 'r':
                /* Set auto package option */
                args->package = 1;
                args->remove = 1;
                break;
            case 'f':
                args->force= 1;
                break;
            case 'C':
                configdir = optarg;
                break;
            case 'T':
                templatedir = optarg;
                break;
            case 'O':
                outputdir = optarg;
                break;
            case 'h':
                help();
                return 0;
            default:
                help();
                return 1;
        }
    }

    /* get the name of package from environment */
    if(args->package) {
    }

    /* Set default system values if not set via command line */
    if(configdir == NULL) configdir = CONFIGDIR;
    if(templatedir == NULL) templatedir = TEMPLATEDIR;
    if(outputdir == NULL) outputdir = OUTPUTDIR;

	return 0;
}

