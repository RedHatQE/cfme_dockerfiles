cfme_dockerfiles
================

Dockerfiles for building cfme-related docker images

The Dockerfiles are suffixed with the name of the
target docker repository name on the [Docker Hub](https://registry.hub.docker.com/repos/cfmeqe/).

When pushing images built from one of the dockerfile, remember to line up the docker and git tags for our sanity.
```
# After a successful docker build
docker tag image_id cfmeqe/docker-repo-name:docker-image-tag
docker push docker tag image_id cfmeqe/docker-repo-name:docker-image-tag

# If replacing an existing tag, you'll need to git tag -f
# Omit the cfmeqe here, since it's redundant, then replace the colon with a slash
git tag docker-repo-name/docker-image-tag
git push --tags
```
