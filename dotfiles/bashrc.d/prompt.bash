#!/bin/bash


function __prompt_parse_git_dirty {
  [[ $(git status --porcelain 2> /dev/null) ]] && echo "*"
}

function __prompt_parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1/"
  #$(__prompt_parse_git_dirty))/"
}


PROMPT_COMMAND=__prompt_command

__prompt_command() {
  local curr_exit="$?"

  local BRed='\[\e[0;91m\]'
  local BGreen='\[\e[0;92m\]'
  local BYellow='\[\e[0;93m\]'
  local BBlue='\[\e[1;94m\]'
  local Blue='\[\e[0;34m\]'
  local BPurple='\[\e[1;95m\]'
  local BCyan='\[\e[1;96m\]'
  local RCol='\[\e[0m\]'

  PS1="${debian_chroot:+($debian_chroot)}${BBlue}\u@\h${RCol} [\t]"
  PS1="$PS1 ${BPurple}$(__prompt_parse_git_branch)${RCol}${BCyan}$(__prompt_parse_git_dirty)${RCol}"
  if [[ "$curr_exit" != 0 ]]; then
    PS1="$PS1 <exit: ${BYellow}$curr_exit${RCol}>"
  fi

  PS1="$PS1\n${BGreen}\w${RCol} \$ "
}


