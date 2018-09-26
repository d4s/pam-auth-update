/**
 * @file common.c
 * @author Denis Pynkin (d4s) <denis.pynkin@collabora.com>
 * @brief 
 */

#include <pam-auth-update.h>
#include <parse_args.h>
#include <config/config_scanner.h>
#include <template/template_scanner.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>

extern void cfgset_in(FILE *in);
int cfglex_destroy (void );

common_configuration_t *common;

char *configdir = NULL;
char *templatedir = NULL;
char *outputdir = NULL;

int init_common_conf(){
    /* initialize common storage */
    common = malloc(sizeof(common_configuration_t));
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

    if( common->auth.primary == NULL ||
        common->auth.additional == NULL ||
        common->account.primary == NULL ||
        common->account.additional == NULL ||
        common->password.primary == NULL ||
        common->password.additional == NULL ||
        common->session.primary == NULL ||
        common->session.additional == NULL ||
        common->session_ni.primary == NULL ||
        common->session_ni.additional ==NULL ) {
    
        return 1;
    }

    return 0;
}

void clear_common_conf(common_conf_t *conf){
    if(conf->primary_num > 0) {
        for(int i=0; i < conf->primary_num; i++){
            if(conf->primary[i].module != NULL)
                free(conf->primary[i].module);
                conf->primary[i].priority = 0;
        }
    }
    conf->primary_num = 0;

    if(conf->additional_num > 0) {
        for(int i=0; i < conf->additional_num; i++){
            if(conf->additional[i].module != NULL)
                free(conf->additional[i].module);
                conf->additional[i].priority = 0;
        }
    }
    conf->additional_num = 0;
}

static int conf_files_filter(const struct dirent *entry){
    char fname[FILENAME_SIZE];
    struct stat st;
    
    if(entry->d_name == NULL)
        return 0;

    snprintf(fname, sizeof(fname), "%s/%s", configdir, entry->d_name);

    stat(fname, &st);

    return(st.st_mode & S_IFREG);
}

int read_common_conf() {
    char fname[FILENAME_SIZE];
    DIR *dir;
    int entries;
    struct dirent **configs;

    if( (entries = scandir(configdir, &configs, conf_files_filter, alphasort)) == -1){
        return 1;
    }

    while (entries--){
        if(configs[entries]->d_name == NULL)
            continue;

        snprintf(fname, sizeof(fname), "%s/%s", configdir, configs[entries]->d_name);
        DBGPRINT("Config found: %s\n", fname);
   
        FILE *fp;
        fp = fopen(fname, "r");
        cfgset_in(fp);
        cfgparse();
        cfglex_destroy();
    }

    return 0;
}

#ifdef DEBUG
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

    fprintf(stderr, "######## %s #######\n", "Directories");
    fprintf(stderr, "Directory with configs: %s\n", configdir);
    fprintf(stderr, "Directory with templates: %s\n", templatedir);
    fprintf(stderr, "Output directory: %s\n", outputdir);

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
#endif /* DEBUG */



