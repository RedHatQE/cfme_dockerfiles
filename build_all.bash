#!bin/bash

BUILDS=(
	sel_base
	sel_base_new
	sel_ff_chrome
	sel_ff_chrome_new
)


# docker pull cfmeqe/sel_base:latest
# docker pull cfmeqe/sel_ff_chrome:latest

for build in ${BUILDS[*]}
do
	docker build . -f Dockerfile.${build} -t cfmeqe/${build}:latest || { echo $build failed; exit 1; }
done