#!bin/bash

BUILDS=(
	sel_base_fc28
	sel_ff_chrome
	stable
)

for build in ${BUILDS[*]}
do
	docker build . -f Dockerfile.${build} -t cfmeqe/${build}:latest || { echo $build failed; exit 1; }
done