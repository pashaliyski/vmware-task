# vmware-task
Prometheus exporter for http status codes

> Export HTTP(s) endpoints status and response time metrics to prometheus

## Local development
### Prerequisites
- python3
- pip3

### Install app dependencies
```
pip3 install --user -r requirements.txt
```

### Run app service
```
python3 vmware-task.py
```

## Build docker image
```
make docker_build
```

## Push docker image (only as developer of this service)
### Login to docker repository
```
docker login -u $user
```

### Push docker image to logged docker repository
```
make docker_push
```

### Change docker repo in helm chart if necessary:
```
sed -i "s/repository: pashaliyski/repository: $user/g" charts/vmware-task/values.yaml
```

### Install helm chart in k8s cluster using helm cli:
```
helm upgrade $app-name --install --namespace $namespace ./charts/vmware-task
```
