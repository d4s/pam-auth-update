/**
 * @file generate_pam_common.c
 * @author Denis Pynkin (d4s) <denis.pynkin@collabora.com>
 * @brief Read templates and generate appropriate configuration in "/etc/pam.d/common-*"
 */

#include <pam-auth-update.h>
#include <parse_args.h>
#include <string.h>
#include <unistd.h>

extern void tplset_in(FILE *in);
extern void tplset_out(FILE *out);
extern int tpllex_destroy(void );
extern int tpllex(void );

int gen_pam_common() {
    const char configs[5][25] = {
        "auth\0",
        "account\0",
        "password\0",
        "session\0",
        "session-noninteractive\0"
    };
    char template[FILENAME_SIZE];
    char config[FILENAME_SIZE];
    FILE *fin, *fout;

    for(int i=0; i<5; i++){
        DBGPRINT("####### Generating config: common-%s\n", configs[i]);
        snprintf(template, sizeof(template), "%s/common-%s", templatedir, configs[i]);
        DBGPRINT("####### Template: %s\n", template);
        snprintf(config, sizeof(config), "%s/common-%s", outputdir, configs[i]);

        fout = fopen(config, "w");
        if(fout == NULL) {
            fprintf(stderr, "Can't open config for write: %s\n", config);
            return 1;
        }
 
        fin = fopen(template, "r");
        if(fin == NULL) {
            fclose(fout);
            fprintf(stderr, "Can't open template for read: %s\n", template);
            return 1;
        }

        tplset_in(fin);
        tplset_out(fout);
        tpllex();
        tpllex_destroy();
        fclose(fin);
        fclose(fout);
    }
    return 0;
}

