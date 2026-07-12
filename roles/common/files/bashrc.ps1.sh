#!/bin/bash

# Bash colour definitions
# see http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
BLACK='\[\e[0;30m\]';       DARK_GRAY='\[\e[1;30m\]'
BLUE='\[\e[0;34m\]';        LIGHT_BLUE='\[\e[1;34m\]'
GREEN='\[\e[0;32m\]';       LIGHT_GREEN='\[\e[1;32m\]'
CYAN='\[\e[0;36m\]';        LIGHT_CYAN='\[\e[1;36m\]'
RED='\[\e[0;31m\]';         LIGHT_RED='\[\e[1;31m\]'
PURPLE='\[\e[0;35m\]';      LIGHT_PURPLE='\[\e[1;35m\]'
BROWN='\[\e[0;33m\]';       YELLOW='\[\e[1;33m\]'
LIGHT_GRAY='\[\e[0;37m\]';  WHITE='\[\e[1;37m\]'
RESET_COLOR='\[\e[00m\]'

# git-prompt.sh (from git contrib) — shows branch, dirty state, upstream diff, stash
GIT_PS1_SHOWDIRTYSTATE=1       # * unstaged, + staged
GIT_PS1_SHOWSTASHSTATE=1       # $ stash exists
GIT_PS1_SHOWUPSTREAM="verbose" # +N/-N ahead/behind
GIT_PS1_SHOWCOLORHINTS=1       # colorise via PROMPT_COMMAND form
for _gp in \
    /usr/share/git-core/contrib/completion/git-prompt.sh \
    /usr/share/git/git-prompt.sh \
    /etc/bash_completion.d/git-prompt; do
    [ -f "$_gp" ] && { source "$_gp"; break; }
done
unset _gp

unset EXIT_CODES
# Exit codes definitions, see bash(1),
EXIT_CODES[1]='Catchall for general errors / Operation not permitted'
EXIT_CODES[2]='Misuse of shell builtins / No such file or directory'
EXIT_CODES[126]='A command is found but is not executable'
EXIT_CODES[127]='A command is not found'
EXIT_CODES[128]='Invalid argument to exit'
EXIT_CODES[255]='Exit status out of range / SSH error occurred'
# sysexits.h (BSD/POSIX standard), see sysexits(3)
EXIT_CODES[64]='EX_USAGE: command line usage error'
EXIT_CODES[65]='EX_DATAERR: data format error'
EXIT_CODES[66]='EX_NOINPUT: cannot open input'
EXIT_CODES[67]='EX_NOUSER: addressee unknown'
EXIT_CODES[68]='EX_NOHOST: host name unknown'
EXIT_CODES[69]='EX_UNAVAILABLE: service unavailable'
EXIT_CODES[70]='EX_SOFTWARE: internal software error'
EXIT_CODES[71]='EX_OSERR: system error (e.g. cannot fork)'
EXIT_CODES[72]='EX_OSFILE: critical OS file missing'
EXIT_CODES[73]='EX_CANTCREAT: cannot create output file'
EXIT_CODES[74]='EX_IOERR: input/output error'
EXIT_CODES[75]='EX_TEMPFAIL: temporary failure (retry)'
EXIT_CODES[76]='EX_PROTOCOL: remote protocol error'
EXIT_CODES[77]='EX_NOPERM: permission denied'
EXIT_CODES[78]='EX_CONFIG: configuration error'
# Signals (exit code = 128 + signal number), see signal(7)
EXIT_CODES[129]='SIGHUP (1): hangup — terminal closed or parent process died'
EXIT_CODES[130]='SIGINT (2): interrupt — keyboard (Ctrl-C)'
EXIT_CODES[131]='SIGQUIT (3): quit — keyboard (Ctrl-\) [core dump]'
EXIT_CODES[132]='SIGILL (4): illegal instruction [core dump]'
EXIT_CODES[133]='SIGTRAP (5): trace/breakpoint trap [core dump]'
EXIT_CODES[134]='SIGABRT (6): abort — from abort(3) [core dump]'
EXIT_CODES[135]='SIGBUS (7): bus error — bad memory access [core dump]'
EXIT_CODES[136]='SIGFPE (8): floating-point exception [core dump]'
EXIT_CODES[137]='SIGKILL (9): killed — cannot be caught or ignored'
EXIT_CODES[138]='SIGUSR1 (10): user-defined signal 1'
EXIT_CODES[139]='SIGSEGV (11): segmentation fault — invalid memory reference [core dump]'
EXIT_CODES[140]='SIGUSR2 (12): user-defined signal 2'
EXIT_CODES[141]='SIGPIPE (13): broken pipe — write to pipe with no readers'
EXIT_CODES[142]='SIGALRM (14): alarm — timer from alarm(2)'
EXIT_CODES[143]='SIGTERM (15): terminated — graceful termination request'
EXIT_CODES[144]='SIGSTKFLT (16): stack fault on coprocessor (unused)'
EXIT_CODES[145]='SIGCHLD (17): child process stopped or terminated'
EXIT_CODES[146]='SIGCONT (18): continue — resume if stopped'
EXIT_CODES[147]='SIGSTOP (19): stop — cannot be caught or ignored'
EXIT_CODES[148]='SIGTSTP (20): terminal stop — keyboard (Ctrl-Z)'
EXIT_CODES[149]='SIGTTIN (21): background process read from terminal'
EXIT_CODES[150]='SIGTTOU (22): background process wrote to terminal'
EXIT_CODES[151]='SIGURG (23): urgent condition on socket'
EXIT_CODES[152]='SIGXCPU (24): CPU time limit exceeded [core dump]'
EXIT_CODES[153]='SIGXFSZ (25): file size limit exceeded [core dump]'
EXIT_CODES[154]='SIGVTALRM (26): virtual timer alarm'
EXIT_CODES[155]='SIGPROF (27): profiling timer expired'
EXIT_CODES[156]='SIGWINCH (28): terminal window size changed'
EXIT_CODES[157]='SIGPOLL (29): pollable event — I/O now possible'
EXIT_CODES[158]='SIGPWR (30): power failure'
EXIT_CODES[159]='SIGSYS (31): bad syscall argument [core dump]'

parse_exit_code () {
    local temp_ecode=( $1 )
    local last_cmd="$2"
    local final_ecode=
    if [ ${#temp_ecode[@]} -eq 2 ]; then
        final_ecode=${temp_ecode[1]}
    else
        final_ecode=${temp_ecode[*]:1}
    fi
    for i in ${final_ecode[*]}; do
        if [ "${i}" != "0" ] ; then
            local msg="${EXIT_CODES[$i]}"
            [[ "$i" -eq 255 && "$last_cmd" == "ssh" ]] && msg="SSH error occurred"
            PS1+="${LIGHT_RED} ${msg} (exit code ${i})\n"
        else
            PS1+="${LIGHT_GREEN} OK (exit code 0)\n"
        fi
        PS1+="${RESET_COLOR}"
    done
}

generate_ps () {
    local ecode="${?} ${PIPESTATUS[@]}"
    local last_cmd
    last_cmd=$(HISTTIMEFORMAT='' history 1 2>/dev/null | sed 's/^ *[0-9]* *//' | awk '{print $1}')
    PS1=
    parse_exit_code "${ecode}" "$last_cmd"
    PS1+="[\u@\h"
    PS1+=" ${LIGHT_BLUE}\w${RESET_COLOR}]"
    local pre="$PS1"
    [[ -n ${VIRTUAL_ENV} ]] && pre+="(${VIRTUAL_ENV##*/})"
    local post=
    if [ \u == "root" ]; then
        post="# "
    else
        post="\$ "
    fi
    if type __git_ps1 &>/dev/null; then
        __git_ps1 "$pre" "$post" "(%s)"
    else
        PS1="${pre}${post}"
    fi
}

PROMPT_COMMAND=generate_ps