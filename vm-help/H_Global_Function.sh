#!/bin/bash
F_bolg(){
  if test "${1:--1}" -eq 0; then
    echo 'stop bolg and restart...'
    docker stop jekyll-skycoop
  fi  
  docker run --rm -p 80:4000 --name jekyll-skycoop --volume="/home/skycoop/shares/project/skyc00p.github.io:/home/jekyll" -d skyc00p/blog jekyll s --future -w --host 0.0.0.0 --force_polling
}

F_reload(){
  source /usr/bin/H_Global_Function.sh
}