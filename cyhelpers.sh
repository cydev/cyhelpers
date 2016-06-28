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


bf_complete() {
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    subcommands="$(cyhelpers -b-completion .)"

    if [[ ${COMP_CWORD} == 1 ]] ; then
        COMPREPLY=($(compgen -W "${subcommands}" -- ${cur}))
        return 0
    fi
}

pf() {
    go test -bench Benchmark$1 -o ${PWD##*/}.test -memprofile=mem.perf
    go tool pprof -alloc_space ${PWD##*/}.test mem.perf
    rm mem.perf ${PWD##*/}.test
}

pfc() {
    go test -bench Benchmark$1 -o ${PWD##*/}.test -cpuprofile cpu.perf
    go tool pprof ${PWD##*/}.test cpu.perf
    rm cpu.perf ${PWD##*/}.test
}

complete -F bf_complete bf
complete -F bf_complete pfc