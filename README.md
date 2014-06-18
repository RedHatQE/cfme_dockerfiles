cfme_dockerfiles
================

Dockerfiles for building cfme-related docker images

The Dockerfiles each live in their own orphaned branch, with the branch name matching the
docker repository name on the [Docker Hub](https://registry.hub.docker.com/repos/cfmeqe/).

To create a new dockerfile branch:
`git checkout --orphan docker-repo-name`

Then add the Dockerfile and any other supporting files as need, and commit and push as usual.

When pushing images built from one of the dockerfile, remember to line up the docker and git tags for our sanity.
```
# After a successful docker build
docker tag image_id cfmeqe/docker-repo-name:docker-image-tag
docker push docker tag image_id cfmeqe/docker-repo-name:docker-image-tag

# If replacing an exisitng tag, you might need to git tag -f
git tag docker-image-tag
git push --tags
```
