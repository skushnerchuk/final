USERNAME=drcoyote
IMAGE=gitlab_utils
VERSION=0.1

docker build -t $USERNAME/$IMAGE:$VERSION .
docker push $USERNAME/$IMAGE:$VERSION
