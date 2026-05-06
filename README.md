# Terraform-Kubernetes-master-workers-calico-cni

# Terraform configuration to create nodes for Kubernetes deployment on AWS.

## Functional Terraform infrastructure project to run a single control plane node and two worker nodes(the configuration could be modified to run as many nodes as needed).

## This project showcases the following concepts in Terraform:
* Deploying AWS infrastructure using Terraform to provision components like VPC, EC2, security groups, etc.
* Deploying Kubernetes control plane and worker components to run on AWS infrastructure.

## Built with:
* Terraform
* AWS CLI
* Docker: Docker engine, Docker CRI(Container Runtime Interface).
* Kubernetes: Kubeadm, Kubectl, Kubelet.
* BASH: script to provide Kubernetes, control-plane, and worker components.
* Calico CNI
* AWS Elastic File System
* AWS EFS CSI driver

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
  NB: It is also possible to SSH to worker nodes. Replace: (terraform output -raw instance_public_ip_master) in the previous command with         the IP address of the worker node. 
  
* Run the following commands to install the AWS CSI driver for EFS on the master Node.
  ```
  $ helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver/
  $ helm repo update aws-efs-csi-driver
  $ helm upgrade --install aws-efs-csi-driver --namespace kube-system aws-efs-csi-driver/aws-efs-csi-driver
  ```
   
* Run the following commands to ensure all nodes in the cluster are available, and all essential Kubernetes control plane and worker          components have been created:
  ```
  ubuntu@master-node:~$ kubectl get nodes
  NAME            STATUS   ROLES           AGE   VERSION
  master-node     Ready    control-plane   63m   v1.35.4
  worker-node-1   Ready    <none>          59m   v1.35.4
  worker-node-2   Ready    <none>          59m   v1.35.4
  ```
  ```
  ubuntu@master-node:~$ kubectl get po -A
  NAMESPACE         NAME                                      READY   STATUS    RESTARTS   AGE
  calico-system     calico-apiserver-7454b75f6f-lmdc9         1/1     Running   0          63m
  calico-system     calico-apiserver-7454b75f6f-p7nnz         1/1     Running   0          63m
  calico-system     calico-kube-controllers-877d84dbc-6kfhv   1/1     Running   0          63m
  calico-system     calico-node-kk4db                         1/1     Running   0          60m
  calico-system     calico-node-l4pm8                         1/1     Running   0          61m
  calico-system     calico-node-rh42n                         1/1     Running   0          63m
  calico-system     calico-typha-5fd768d787-5vzgp             1/1     Running   0          60m
  calico-system     calico-typha-5fd768d787-c77wr             1/1     Running   0          63m
  calico-system     csi-node-driver-9xskj                     2/2     Running   0          63m
  calico-system     csi-node-driver-jchmt                     2/2     Running   0          61m
  calico-system     csi-node-driver-tvmhx                     2/2     Running   0          60m
  calico-system     goldmane-58f96f7c58-dsqnr                 1/1     Running   0          57m
  calico-system     whisker-5b78c7ddd6-6cb7n                  2/2     Running   0          57m
  kube-system       coredns-7d764666f9-4fhqn                  1/1     Running   0          64m
  kube-system       coredns-7d764666f9-gqzdt                  1/1     Running   0          64m
  kube-system       efs-csi-controller-7b8bdc5484-fwlmc       3/3     Running   0          57m
  kube-system       efs-csi-controller-7b8bdc5484-qgsdw       3/3     Running   0          57m
  kube-system       efs-csi-node-6q59n                        3/3     Running   0          57m
  kube-system       efs-csi-node-jnl55                        3/3     Running   0          57m
  kube-system       efs-csi-node-m9dvv                        3/3     Running   0          57m
  kube-system       etcd-master-node                          1/1     Running   0          65m
  kube-system       kube-apiserver-master-node                1/1     Running   0          65m
  kube-system       kube-controller-manager-master-node       1/1     Running   0          65m
  kube-system       kube-proxy-bttzq                          1/1     Running   0          61m
  kube-system       kube-proxy-d8slz                          1/1     Running   0          64m
  kube-system       kube-proxy-kpgcd                          1/1     Running   0          60m
  kube-system       kube-scheduler-master-node                1/1     Running   0          65m
  tigera-operator   tigera-operator-6cf4cccc57-dwzds          1/1     Running   0          64m

  ```    
