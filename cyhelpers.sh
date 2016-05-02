#!/bin/bash
p_complete () {
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    subcommands="$(cyhelpers)"

    if [[ ${COMP_CWORD} == 1 ]] ; then
        COMPREPLY=($(compgen -W "${subcommands}" -- ${cur}))
        return 0
    fi
}
p () {
    cd $(cyhelpers $1)
}

complete -F p_complete p
