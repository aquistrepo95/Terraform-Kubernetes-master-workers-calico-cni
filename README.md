# Terraform-Kubernetes-master-workers-calico-cni

# Terraform configuration to create nodes for Kubernetes deployment on AWS.

## Functional Terraform infrastructure project to run a single control plane node and two worker nodes(the configuration could be modified to run as many nodes as needed).

## This project showcases the following concepts in Terraform:
* Deploying AWS infrastructure using Terraform to provision components like: VPC, EC2, security groups, etc.
* Deploying Kubernetes control plane and worker components to run on AWS infrastructure.

## Built with:
* Terraform
* AWS CLI
* Docker: Docker engine, Docker CRI(Container Runtime Interface).
* Kubernetes: Kubeadm, Kubectl, Kubelet.
* BASH: script to provide Kubernetes, control-plane, and worker components.
* Calico CNI

## This section will describe: how to deploy the infrastructure on AWS.
* Prequisite: Terraform is installed, and AWS CLI is installed and configured with keys.
* Generate private and public keys and copy them to ssh_keys and ssh_keys.pub.
  ```
  $ ssh-keygen -C "your_email@example.com" -f ssh_keys
  ```
* Run Terraform commands to deploy the infrastructure to AWS.
  ```
  $ terraform fmt
  $ terraform init
  $ terrafrom validate
  $ terraform apply
  ```
NB: This may take a few minutes to complete.

## Verification
* To verify if the nodes are up and running, follow the steps below:
* ssh to the master/control plane node
  ```
  $ ssh ubuntu@$(terraform output -raw instance_public_ip_master) -i ssh_keys -v
  ```
  
* You should now be connected to the master node.
* Run the following commands to ensure all nodes in the cluster are available, and all essential Kubernetes control plane components have     been created:
  ```
  ubuntu@master-node:~$ kubectl get nodes
  NAME            STATUS   ROLES           AGE   VERSION
  master-node     Ready    control-plane   20m   v1.35.0
  worker-node-1   Ready    <none>          19m   v1.35.0
  worker-node-2   Ready    <none>          18m   v1.35.0
  ```
  ```
  ubuntu@master-node:~$ kubectl get po -A
  NAMESPACE         NAME                                      READY   STATUS    RESTARTS   AGE
  calico-system     calico-apiserver-5cd597c7d7-58qps         1/1     Running   0          96s
  calico-system     calico-apiserver-5cd597c7d7-x44hq         1/1     Running   0          96s
  calico-system     calico-kube-controllers-bb45db999-jw9r9   1/1     Running   0          95s
  calico-system     calico-node-gztx7                         1/1     Running   0          96s
  calico-system     calico-node-s8wpc                         1/1     Running   0          96s
  calico-system     calico-node-v7m6x                         1/1     Running   0          96s
  calico-system     calico-typha-75b5b5db55-7sg8v             1/1     Running   0          96s
  calico-system     calico-typha-75b5b5db55-dnwqm             1/1     Running   0          91s
  calico-system     csi-node-driver-kf624                     2/2     Running   0          95s
  calico-system     csi-node-driver-p7lm6                     2/2     Running   0          95s
  calico-system     csi-node-driver-rz9fq                     2/2     Running   0          95s
  calico-system     goldmane-58f96f7c58-l7cll                 1/1     Running   0          96s
  calico-system     whisker-7f5659f586-v8kqg                  2/2     Running   0          77s
  kube-system       coredns-7d764666f9-bnj6f                  1/1     Running   0          9m35s
  kube-system       coredns-7d764666f9-f4rxr                  1/1     Running   0          9m34s
  kube-system       etcd-master-node                          1/1     Running   0          9m38s
  kube-system       kube-apiserver-master-node                1/1     Running   0          9m42s
  kube-system       kube-controller-manager-master-node       1/1     Running   0          9m39s
  kube-system       kube-proxy-j7tqm                          1/1     Running   0          9m35s
  kube-system       kube-proxy-qfxzz                          1/1     Running   0          8m13s
  kube-system       kube-proxy-ztgfg                          1/1     Running   0          8m5s
  kube-system       kube-scheduler-master-node                1/1     Running   0          9m41s
  tigera-operator   tigera-operator-6cf4cccc57-f4hch          1/1     Running   0          4m10s
  ```    
