#!/bin/bash
F_bolg(){
    docker run --rm -p 80:4000 --name jekyll-skycoop --volume="/home/skycoop/shares/project/skyc00p.github.io:/home/jekyll" -d skyc00p/blog jekyll s -w --host 0.0.0.0 --force_polling
}