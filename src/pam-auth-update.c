/**
 * @file pam-auth-update.c
 * @author Denis Pynkin (d4s) <denis.pynkin@collabora.com>
 * @brief replacement for original `pam-auth-update' utility
 *
 * Initial version is adapted for Apertis use case:
 * then adding new package all common-* files are regenerated,
 * while removing package -- it's config is excluded from re-generation process
 */

#include <pam-auth-update.h>
#include <parse_args.h>
#include <stdlib.h>
#include <locale.h>

common_configuration_t *common;

char *configdir = NULL;
char *templatedir = NULL;
char *outputdir = NULL;


int main(int argc, char **argv) {

    args_t args;

    /* To be sure all file/text-based things works well */
    setlocale(LC_ALL, "");

    if(parse_args(&args, argc, argv) != 0){
        exit(1);
    }

    if(init_common_conf()){
        exit(1);
    }
    if(read_common_conf()){
        exit(2);
    }

#ifdef DEBUG
    print_configuration();
#endif

    clear_common_configuration();
    return 0;
}
