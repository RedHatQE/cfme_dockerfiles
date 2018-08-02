#!bin/bash

BUILDS=(
	sel_base
	sel_base_new
	sel_ff_chrome
	sel_ff_chrome_new
	stable
)

for build in ${BUILDS[*]}
do
	docker build . -f Dockerfile.${build} -t cfmeqe/${build}:latest || { echo $build failed; exit 1; }
done