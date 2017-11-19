# Azure

Install Azure CLI : https://docs.microsoft.com/en-us/cli/azure/overview?view=azure-cli-latest

### Minikube

Install instructions : https://kubernetes.io/docs/tasks/tools/install-minikube/

You should have virtual box installed

put in path: kubectl.exe & minikybe.exe

The following command creates a vm in Virtual Box. 1 master & 1 node

```bash
#start
minikube start

#nodes
kubectl get nodes

#dashboard
minikube dashboard
```

#Master & Nodes

###Master

**Kube-apiserver** : front end to the control plane, exposes the API, resides on master. We send it the manifest yml file & master deploys services to cluster. The only service we deal directly with.

**Cluster Store**: persistent storage. config and state of cluster gets stored here. Uses etcd (open source key-value store, developed by core os)

kube-controller-manager: controller of controllers: node controller, endpoints controller, namespace controller... watch for changes and help maintain desired state.

**kube-scheduler**: watches apiserver for new pods, assigns works to nodes

### Nodes

**Kubelet**: the main kubernetes agent on the node. It registers node with cluster and then watches apiserver for work assignments. It carries out the task (instantiates pod), then reports back to master. It exposes an endpoint on port 10255 where you can inspect it. Some API calls: /spec, /healthz, /pods

*(definition) pod*: one or more containers packaged together and deployed as a unit.

**Container engine**: works with pods. pulls images, start/stops containers. Container runtime is usually Docker - it uses native Docker API

**Kube-proxy**: Kubernetes networking. Responsible for assigning one unique ip to all containers in a pod. Does lightweight load balancing across all pods in a service.

*(definition) Service*: is a way of hiding multiple pods behind a single network address.

### Pods

A sandboxed environment for a container. All containers must reside in pods. Unit of scaling is also a pod: you don't scale by adding more containers but by replicating pods. Pods exist on a single node. Deployed by manifest files and the Replication Controller. Note: We don't really work with pods this way. We work with a Replication Controller , where we specify a "desired state" of the replicas and it keeps state of the cluster from drifting from this state

```yaml
#sample pod manifest
apiVersion: v1
kind: Pod
metadata:
  name: hello-pod
  labels:
    zone: prod
    version: v1
spec:
  containers:
  - name: hello-ctr
    image: nigelpoulton/pluralsight-docker-ci:latest
    ports:
    - containerPort: 8080

```

```bash
#create pod
kubectl create -f pod.yml

#check
kubectl get pods
kubectl get pods/hello-pod

#describe
kubectl describe pods

#delete
kubectl delete pods hello-pod
```

### Replication Controller

```yaml
## Sample Replication Controller YAML file used in example (called rc.yml in video):
apiVersion: v1
kind: ReplicationController
metadata:
  name: hello-rc
spec:
  replicas: 10
  selector:
    app: hello-world
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
      - name: hello-ctr
        image: nigelpoulton/pluralsight-docker-ci:latest
        ports:
        - containerPort: 8080
```

```bash
#create rc
kubectl create -f pod.yml

#check
kubectl get rc
kubectl get rc -o wide

#describe
kubectl describe rc

#delete rc
kubectl delete svc hello-svc

```

**Updating YAML**

after making changes

```baxh
kubectl apply -f pods.yml

```



###Services

Pods die and come up with new IPs. We can scale the up and down and they get new IPs. We cannot rely on pod IPs. A Service object is Kubernetes object, defined with a YAML manifest. It provides a stable IP and DNS name & load balancing for pods. By default DNS name is same as the service name.

Outside: by service  ip & port : An endpoint object is created (like a lb pool)

pod to pod (internal): localhost

You tie the service & pods together by labels. In the Replication Controller manifest above, the label we gave was "hello-world"

**Iterative way of exposing services**

```bash
#create service
kubectl expose rc hello-rc --name=hello-svc --target-port=8080 --type=NodePort

#describe
kubectl describe svc hello-svc

#note the NodePort. In my case it was 32319
#We can hit any node in the cluster at this port to get to our service

#Get the Nodes/External ID from dashboard. If running on minikube, it is minikube

#dashboard
minikube dashboard

#view web page at NodePort 
http://minikube:32319/

#delete svc
kubectl delete svc hello-svc
```

**Declarative  way of exposing service (YAML File): the preferred way**

Type:

Each step below adds a wrapper on top of ClusterIP

1. ClusterIP : Stable internal cluster IP
2. NodePort: Exposes the app outside of the cluster by adding a cluster-wide port on top of ClusterIP
3. LoadBalancer: Integrates NodePort with cloud-based load balancers.

Below, pods internally expose 8080 and externally, the node exposes port 30001.

Selector has to match selector in Replication Controller.

Labels tie service to replication controller, hence should match.

```yaml
### The following is the "svc.yml" file used in the module
apiVersion: v1
kind: Service
metadata:
  name: hello-svc
  labels:
    app: hello-world
spec:
  type: NodePort
  ports:
  - port: 8080
    nodePort: 30001
    protocol: TCP
  selector:
    app: hello-world
```



```bash
#check if rc selecter matches
kubectl describe pods |grep app

#create
kubectl create -f svc.yml
#check
kubectl describe svc hello-svc
```

**Endpoints**

These are the endpoints of all pods the service manages

```grep
kubectl get ep
kubectl describe ep hello-svc
```



### Labels

The way a pod belongs to a service is via labels. If we label the service and a pod with the same labels, the service will load balance it.

This is great for versioning. If we add a version number, service will automatically target the matching version number. If something bad happen to the new version, we can simply go back to earlier version by flipping the label.

# Deployments

Deployments wrap around Replication Controllers. Deployments  manage updates and rollbacks. In the world of deployments, Replication Controllers, with subtle differences,  are Replica Sets. Deployments manage Replica Sets and Replica Sets manage Pods.

You deploy with a YAML file, K8s creates a Replica set. You need to update, you modify the YAML file and give to the apiserver again. K8s creates a new Replica set and once it is provisioned, removes the old Replica Set. The old Replica Sets don't get deleted. They stick around if you want to rollback.

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: hello-deploy
spec:
  replicas: 10
  minReadySeconds: 10
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
      - name: hello-pod
        image: nigelpoulton/pluralsight-docker-ci:latest
        ports:
        - containerPort: 8080
```

```bash
#create
kubectl create -f deploy.yml

#describe
kubectl describe deploy hello-deploy

#rs
kubectl get rs

#describe
kubectl describe rs

#delete
kubectl delete deploy hello-deploy
```



**Updates**

minReadySeconds: sec to wait before updating next

```bash
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: hello-deploy
spec:
  replicas: 10
  minReadySeconds: 10
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
      - name: hello-pod
        image: nigelpoulton/pluralsight-docker-ci:latest
        ports:
        - containerPort: 8080
```

```bash
#apply update: always use record because it gives user friendy label to hist
kubectl apply -f deploy.yml --record

#watch
kubectl rollout status deployment hello-deploy

#get
kubectl get deploy hello-deploy

#history: will show versions/revisions
kubectl rollout history deployment hello-deploy

#rs
kubectl get rc

#describe current state of deployment
kubectl describe deploy hello-deploy
```



### Rollback

```bash
#rollback
kubectrl rollout undo deployment hello-deploy --to-revision=1

#watch
kubectl get deploy

#status
kubectl rollout status  deployment hello-deploy
```



