#!/usr/bin/env bash
selected=`cat ~/.scripts/cht/.tmux-cht-languages ~/.scripts/cht/.tmux-cht-command | fzf`
if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

if grep -qs "$selected" ~/.scripts/.tmux-cht-languages; then
    query=`echo $query | tr ' ' '+'`
    bash -c "echo \"curl cht.sh/$selected/$query/\" & curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done" 
else
    bash -c "curl -s cht.sh/$selected~$query | less"
fi
