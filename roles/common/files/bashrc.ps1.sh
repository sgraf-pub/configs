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

unset EXIT_CODES
# Exit codes definitions, see bash(1),
EXIT_CODES[1]='Catchall for general errors / Operation not permitted'
EXIT_CODES[2]='Misuse of shell builtins / No such file or directory'
EXIT_CODES[126]='A command is found but is not executable'
EXIT_CODES[127]='A command is not found'
EXIT_CODES[128]='Invalid argument to exit'
EXIT_CODES[255]='Exit status out of range / SSH error occurred'
# Signals, see signal(7)
EXIT_CODES[129]='SIGHUP,1,Term Hangup detected on controlling terminal or '\
'death of controlling process'
EXIT_CODES[130]='SIGINT,2,Term Interrupt from keyboard (Ctrl-C)'
EXIT_CODES[131]='SIGQUIT,3,Core Quit from keyboard (Ctrl-\)'
EXIT_CODES[132]='SIGILL,4,Core Illegal Instruction'
EXIT_CODES[133]='SIGTRAP,5,Core Trace/breakpoint trap'
EXIT_CODES[134]='SIGABRT,6,Core Abort signal from abort(3) / SIGIOT,6,Core '\
'IOT trap'
EXIT_CODES[135]='SIGBUS,7,Core Bus error (bad memory access)'
EXIT_CODES[136]='SIGFPE,8,Core Floating point exception'
EXIT_CODES[137]='SIGKILL,9,Term Kill signal'
EXIT_CODES[138]='SIGUSR1,10,Term User-defined signal 1'
EXIT_CODES[139]='SIGSEGV,11,Core Invalid memory reference'
EXIT_CODES[140]='SIGUSR2,12,Term User-defined signal 2'
EXIT_CODES[141]='SIGPIPE,13,Term Broken pipe: write to pipe with no readers'
EXIT_CODES[142]='SIGALRM,14,Term Timer signal from alarm(2)'
EXIT_CODES[143]='SIGTERM,15,Term Termination signal'
EXIT_CODES[144]='SIGSTKFLT,16,Term Stack fault on coprocessor (unused)'
EXIT_CODES[145]='SIGCHLD,17,Ign Child stopped or terminated / SIGCLD,17,Ign'
EXIT_CODES[146]='SIGCONT,18,Cont Continue if stopped'
EXIT_CODES[147]='SIGSTOP,19,Stop Stop process'
EXIT_CODES[148]='SIGTSTP,20,Stop Stop typed at terminal'
EXIT_CODES[149]='SIGTTIN,21,Stop Terminal input for background process'
EXIT_CODES[150]='SIGTTOU,22,Stop Terminal output for background process'
EXIT_CODES[151]='SIGURG,23,Ign Urgent condition on socket (4.2BSD)'
EXIT_CODES[152]='SIGXCPU,24,Core CPU time limit exceeded (4.2BSD)'
EXIT_CODES[153]='SIGXFSZ,25,Core File size limit exceeded (4.2BSD)'
EXIT_CODES[154]='SIGVTALRM,26,Term Virtual alarm clock (4.2BSD)'
EXIT_CODES[155]='SIGPROF,27,Term Profiling timer expired'
EXIT_CODES[156]='SIGWINCH,28,Ign Window resize signal (4.3BSD, Sun)'
EXIT_CODES[157]='SIGPOLL,29,Term Pollable event (Sys V) / SIGIO,29,Term I/O '\
'now possible (4.2BSD)'
EXIT_CODES[158]='SIGPWR,30,Term Power failure (System V) / SIGINFO,30,Term'
EXIT_CODES[159]='SIGSYS,31,Core Bad argument to routine (SVr4) / SIGUNUSED,'\
'31,Core'

parse_exit_code () {
    local temp_ecode=( $1 )
    local final_ecode=
    if [ ${temp_ecode} != ${temp_ecode[@]:(-1)} ]; then
        final_ecode=${temp_ecode}
    else
        final_ecode=${temp_ecode[@]:1}
    fi
    for i in ${final_ecode[@]}; do
        if [ ${i} != "0" ] ; then
            PS1+="${LIGHT_RED} ${EXIT_CODES[$i]} (exit code ${i})\n"
            PS1+="${RESET_COLOR}"
        fi
    done
}

parse_git () {
    local branchname=
    local gitstatus=
    local workt=
    local stage=
    local ahead=
    local behind=
    branchname=$(git branch 2>/dev/null | grep '\*')
    if [[ -n ${branchname} ]]; then
        PS1+="(${LIGHT_BLUE}${branchname:2}${RESET_COLOR}"
        gitstatus=$(git status --short 2> /dev/null)
        if [[ -n "${gitstatus}" ]] ; then
            workt=$(echo -e "${gitstatus}" | cut -c2 | sort | uniq | \
                tr -d '\n ')
            stage=$(echo -e "${gitstatus}" | cut -c1 | sort | uniq | \
                grep -v -e '\?' -e '\!' | tr -d '\n ')
        fi
        if [[ -n ${stage} || -n ${workt} ]]; then
            PS1+=" ${YELLOW}${stage}${LIGHT_RED}${workt}"
        fi
        ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null)
        behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null)
        if [[ -n ${ahead} ]]; then
            if [ ${ahead} -ne 0 ]; then
                PS1+=" ${YELLOW}+${ahead}"
            fi
            if [ ${behind} -ne 0 ]; then
                PS1+=" ${YELLOW}-${behind}"
            fi
        fi
        git stash show &>/dev/null
        if (( $? == 0 )); then
            PS1+=" ${LIGHT_PURPLE}S"
        fi
        PS1+="${RESET_COLOR}"
        PS1+=")"
    fi
}

generate_ps () {
    local ecode="${?} ${PIPESTATUS[@]}"
    PS1=
    parse_exit_code "${ecode}"
    PS1+="[\u@\h"
    PS1+=" ${LIGHT_BLUE}\w${RESET_COLOR}]"
    parse_git
    [[ ! -z ${VIRTUAL_ENV} ]] && PS1+="(${VIRTUAL_ENV##*/})"
    if [ \u == "root" ]; then
        PS1+="# "
    else
        PS1+="\$ "
    fi
}

PROMPT_COMMAND=generate_ps

