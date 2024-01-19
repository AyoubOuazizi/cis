terraform init
terraform apply
cd C:\Users\hp\Desktop\cis\Manifests\Owasp-juice-shop\
gcloud container clusters get-credentials owasp-juice-shop-cluster --region us-central1
kubectl apply -f owasp-juice-shop-deployment.yaml
kubectl apply -f owasp-juice-shop-service.yaml
kubectl get services owasp-juice-shop
kubectl get ingress owasp-juice-shop
kubectl get managedcertificates

cd C:\Users\hp\Desktop\cis\Manifests\NetworkPolicy\
kubectl apply -f networkPolicy.yaml

cd C:\Users\hp\Desktop\cis\Terraform\gke\
terraform destroy -auto-approve
cd C:\Users\hp\Desktop\cis\Terraform\cloud_armor\
terraform destroy -auto-approve

cd C:\Users\hp\Desktop\cis\Terraform\gke\
terraform apply -auto-approve
cd C:\Users\hp\Desktop\cis\Terraform\cloud_armor
terraform apply -auto-approve
cd C:\Users\hp\Desktop\cis\Terraform\static-ip
terraform apply -auto-approve

cd C:\Users\hp\Desktop\cis\Manifests\Logs
helm install filebeat filebeat/filebeat-8.5.1/filebeat/
helm install logstash logstash/logstash-8.5.1/logstash/
helm install elasticsearch elasticsearch/elasticsearch-8.5.1/elasticsearch/
helm install kibana kibana/kibana-8.5.1/kibana/ --timeout 600s

helm uninstall kibana

kubectl delete configmap kibana-kibana-helm-scripts
kubectl delete serviceaccount pre-install-kibana-kibana
kubectl delete roles pre-install-kibana-kibana
kubectl delete rolebindings pre-install-kibana-kibana
kubectl delete job pre-install-kibana-kibana
kubectl delete job post-delete-kibana-kibana
kubectl delete secrets kibana-kibana-es-token

helm uninstall filebeat
helm uninstall logstash
helm uninstall elasticsearch


kubectl debug filebeat-filebeat-75t72 -it --image=busybox -- sh
kubectl exec -it <nom-du-pod> -- /bin/sh



gcloud auth login
gcloud config set project cis-project-411615
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check           
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
gcloud container clusters get-credentials owasp-juice-shop-cluster --region us-central1


gcloud compute scp --recurse ..\..\Manifests jump-host: --zone us-central1-a


curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm


sudo apt-get install software-properties-common
sudo apt-get update
export OSQUERY_KEY=1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys $OSQUERY_KEY
sudo add-apt-repository 'deb [arch=amd64] https://pkg.osquery.io/deb deb main'
sudo apt-get update
sudo apt-get install osquery