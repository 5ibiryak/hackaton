# 1.Docker

## Authentication
____
~~~
export DOCKER_REGISTRY=example.local
export DOCKERFILE=build/Dockerfile
export DOCKER_CONTEXT=.
export MAINTAINER=user@example.ru
read -s DOCKER_USER # пользователь registry
read -s DOCKER_PASSWORD # пароль от registry
docker login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD} ${DOCKER_REGISTRY}
~~~

## Build App
___
~~~
docker build -t ${DOCKER_REGISTRY}/application:${TAG} --build-arg GIT_COMMIT=$(git log -1 --pretty=format:"%h") --build-arg MAINTAINER=${MAINTAINER} -f ${DOCKERFILE} ${DOCKER_CONTEXT}
~~~

## Publishing
___
~~~
docker push ${DOCKER_REGISTRY}/application:${TAG}
~~~

## Run app
___
~~~
docker run -d -p ${PORT_OUTSIDE}:${PORT_INSIDE} ${DOCKER_REGISTRY}/application:${TAG}
~~~

---
---
---
# 2. Kubernetes

## Create secrete for registry
~~~
kubectl create secret docker-registry regestry-secret \
    --docker-server=${DOCKER_REGISTRY} \
    --docker-username=${DOCKER_USER} \
    --docker-password=${DOCKER_PASSWORD} \
~~~

## Helm install
~~~
export HELMFILE=chart/values.yaml
export SERVICE_NAME=web
export PATH_CHART=chart/
export NAMESPACE=web
~~~

~~~
kubectl create namespace ${NAMESPACE}
~~~

~~~
helm upgrade --install -f ${HELMFILE} ${SERVICE_NAME} ${PATH_CHART} --set tag=${TAG} --set repository=${DOCKER_REGISTRY}/application -n ${NAMESPACE}
~~~

