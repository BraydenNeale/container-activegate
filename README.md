# Containerised Extension ActiveGate
## Issues
* The extension module download times out during install... So the remoteplugin module is never included or activated.
    * **WARNING Timeout while downloading capabilities**

# Building and Deploying a custom ActiveGate Image

Note: DYNATRACE_API_TOKEN is a PaaS Token
### ENV VARS
```
DYNATRACE_CLUSTER_HOST="[ID].live.dynatrace.com"
DYNATRACE_API_TOKEN="dt0c01...."
DYNATRACE_ACTIVEGATE_VERSION="1.239.195"
ACTIVEGATE_GROUP=network_polling
IMAGE=dynatrace-activegate:v$DYNATRACE_ACTIVEGATE_VERSION
DOCKER_REPO=[USER]/dynatrace-activegate:v$DYNATRACE_ACTIVEGATE_VERSION
```

### DOCKER 
```
docker build \
--build-arg DYNATRACE_CLUSTER_HOST=$DYNATRACE_CLUSTER_HOST \
--build-arg DYNATRACE_API_TOKEN=$DYNATRACE_API_TOKEN \
--build-arg DYNATRACE_ACTIVEGATE_VERSION=$DYNATRACE_ACTIVEGATE_VERSION \
--build-arg ACTIVEGATE_GROUP=$ACTIVEGATE_GROUP
-t $IMAGE \
.
```

Test: The AG should show in Dynatrace deployment status
```
docker run -p 9999:9999 -d $IMAGE
```

Push to docker hub
```
docker tag $IMAGE $DOCKER_REPO
docker login -u [USER]
docker push "${DOCKER_REPO}"
```

# K8s
```
kubectl create secret docker-registry regcred --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email>
kubectl apply -f activegate.yaml
```

# Pulling the Dynatrace cloud-native container image
Can't run extensions... only a few capabilities enabled such as routing and k8s monitoring

Note: The password is a PaaS Token
```
docker login -u [ENV_ID] [ENV_ID].live.dynatrace.com
docker pull [ENV_ID].live.dynatrace.com/linux/activegate:latest
docker run -p 9999:9999 [ENV_ID].live.dynatrace.com/linux/activegate:latest
```