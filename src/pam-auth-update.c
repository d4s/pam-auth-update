/**
 * @file pam-auth-update.c
 * @author Denis Pynkin (d4s) <denis.pynkin@collabora.com>
 * @brief replacement for original `pam-auth-update' utility
 *
 * Initial version is adapted for Apertis usecase:
 * then adding new package all common-* files are regenerated,
 * while removing package -- it's config is excluded from re-generation process
 */

#include <pam-auth-update.h>
#include <parse_args.h>
#include <config/config_scanner.h>
#include <template/template_scanner.h>
#include <stdlib.h>
#include <string.h>

common_configuration_t *common;

int main(int argc, char **argv) {
 
    args_t args;
    if(parse_args(&args, argc, argv) != 0){
        exit(1);
    }
    
    /* initialize common storage */
    common = malloc(sizeof(common_configuration_t));
    DBGPRINT("Size: %ld\n", sizeof(common_configuration_t));
    if(common == NULL){
        return 1;
    }
    memset(common, 0, sizeof(common_configuration_t));

    common->auth.primary = calloc(ELEMENTS, sizeof(pam_str_t));
    common->auth.additional = calloc(ELEMENTS, sizeof(pam_str_t));
    common->account.primary = calloc(ELEMENTS, sizeof(pam_str_t));
    common->account.additional = calloc(ELEMENTS, sizeof(pam_str_t));
    common->password.primary = calloc(ELEMENTS, sizeof(pam_str_t));
    common->password.additional = calloc(ELEMENTS, sizeof(pam_str_t));
    common->session.primary = calloc(ELEMENTS, sizeof(pam_str_t));
    common->session.additional = calloc(ELEMENTS, sizeof(pam_str_t));
    common->session_ni.primary = calloc(ELEMENTS, sizeof(pam_str_t));
    common->session_ni.additional = calloc(ELEMENTS, sizeof(pam_str_t));


    print_configuration();
    cfgparse();
    print_configuration();
    return 0;


    tplparse();


    free (common);
    return 0;
}

void print_config(common_conf_t *conf){
    fprintf(stderr, "Primary block: %d\n", conf->primary_num);
    if(conf->primary_num > 0) {
        for(int i=0; i < conf->primary_num; i++){
            fprintf(stderr, "  [%d] %d: %s\n", i,
            conf->primary[i].priority,
            conf->primary[i].module);
        }
    }
    fprintf(stderr, "Additional block: %d\n", conf->additional_num);
    if(conf->additional_num > 0) {
        for(int i=0; i < conf->additional_num; i++){
            fprintf(stderr, "  [%d] %d: %s\n", i,
            conf->additional[i].priority,
            conf->additional[i].module);
        }
    }
 }

void print_configuration(){

    fprintf(stderr, "######## %s #######\n", "Auth");
    print_config(&common->auth);
    fprintf(stderr, "######## %s #######\n", "Account");
    print_config(&common->account);
    fprintf(stderr, "######## %s #######\n", "Password");
    print_config(&common->password);
    fprintf(stderr, "######## %s #######\n", "Session");
    print_config(&common->session);
    fprintf(stderr, "######## %s #######\n", "Session Non-Interactive");
    print_config(&common->session_ni);
}
