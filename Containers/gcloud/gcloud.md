### Gcloud Commands

```bash
#Get project id
gcloud projects list
```



####Build a .net web app

https://cloudplatform.googleblog.com/2016/10/managing-containerized-ASP.NET-Core-apps-with-Kubernetes.html

To kill web running at port 5000

```bash
netstat -ano | findstr :5000
taskkill //PID 15516 //F
```

### Dockerfile

 Create a Dockerfile in the root of our app folder:

```yaml
FROM microsoft/aspnetcore-build:2.0 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM microsoft/aspnetcore:2.0
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "aspnetapp.dll"]
```

This is the recipe for the Docker image that we'll create shortly. In a nutshell, we're creating an image based on microsoft/dotnet:latest image, copying the current directory to /app directory in the container, executing the commands needed to get the app running, making sure port 8080 is exposed and that ASP.NET Core is using that port.



```bash
#Build
docker build -t gcr.io/fresh-shell-185922/hello-dotnet:v1 .
#Run
docker run -d -p 8081:80 -t gcr.io/fresh-shell-185922/hello-dotnet:v1
#check
docker ps -a


```

### Enable Container Registry API

https://cloud.google.com/container-registry/docs/quickstart

### Install  Google Cloud SDK Shell

https://cloud.google.com/sdk/docs/quickstart-debian-ubuntu

```bash
# Create an environment variable for the correct distribution
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"

# Add the Cloud SDK distribution URI as a package source
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# Import the Google Cloud Platform public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Update the package list and install the Cloud SDK
sudo apt-get update && sudo apt-get install google-cloud-sdky

#init
gcloud init
```



###install Kubectl

```bash
gcloud components install kubectl

```



### Configure `kubectl` command line access to the cluster with the following

Login

```bash
gcloud container clusters get-credentials cluster-1 --zone us-central1-a
```

### Push image to Google Container Registry

Now, let’s push our image to Google Container Registry using `gcloud`, so we can later refer to this image when we deploy and run our Kubernetes cluster. In the Google Cloud SDK Shell, type:

```bash
#Push
gcloud docker -- push gcr.io/fresh-shell-185922/hello-dotnet:v1
```



###Create a cluster

```bash
gcloud container clusters create hello-dotnet-cluster --num-nodes 2 --machine-type n1-standard-1
```



### Deploy and run the app

```bash
#Run
kubectl run hello-dotnet --image=gcr.io/fresh-shell-185922hello-dotnet:v1 \
  --port=8080
  
#Check
 kubectl get deployments
 
#expose our deployment to the outside world:
kubectl expose deployment hello-dotnet --type="LoadBalancer"
service "hello-dotnet" exposed

#Check and sisplay external-ip
kubectl get services 
```

Finally, if you visit the external IP address on port 8080, you should see the default ASP.NET Core app managed by Kubernetes!

https://35.188.10.3:8080/

Stop the cluster

```bash
gcloud container clusters resize cluster-1 --size=0
```

