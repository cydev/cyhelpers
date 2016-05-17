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
    DIR=$(cyhelpers $1)
    if [ -f "${DIR}/.venv" ]; then
        . $(cyhelpers -v $(cat "${DIR}/.venv"))
        export DJANGO_CONFIGURATION=Local
    else
        FTYPE=$(type -t "deactivate")
        if [[ ${FTYPE} == "function" ]]; then
            deactivate
        fi
    fi
    cd ${DIR}
}

complete -F p_complete p

e_complete () {
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    subcommands="$(cyhelpers -v-completion)"

    if [[ ${COMP_CWORD} == 1 ]] ; then
        COMPREPLY=($(compgen -W "${subcommands}" -- ${cur}))
        return 0
    fi
}

e () {
   . $(cyhelpers -v $1)
}

d () {
    FTYPE=$(type -t "deactivate")
    if [[ ${FTYPE} == "function" ]]; then
        deactivate
    else
        echo "nothing to deactivate"
    fi
}
complete -F e_complete e
