/**
 * @file parse_args.h
 * @author Denis Pynkin (d4s) <denis.pynkin@collabora.com>
 * @brief 
 */

#ifndef PARSE_ARGS_H
#define PARSE_ARGS_H

#include <config.h>

typedef struct args {
    int force;
    int remove;
    int package;
    char *package_name;
} args_t;

int parse_args(args_t *args, int argc, char **argv);

#endif /* PARSE_ARGS_H */
