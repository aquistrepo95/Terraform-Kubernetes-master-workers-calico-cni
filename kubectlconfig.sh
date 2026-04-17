#!/bin/bash

# set up kubeconfig for the regular user
echo "Setting up kubeconfig for the regular user..."
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# install a pod network add-on (Weave Net)
echo "Installing Calico CNI network add-on for pod networking..."

# Install the Tigera Calico operator
echo "Installing the Tigera Calico operator"
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.0/manifests/tigera-operator.yaml

# Install the Calico custom resources
echo "Installing the Calico custom resources"
curl -s https://raw.githubusercontent.com/projectcalico/calico/v3.31.1/manifests/custom-resources.yaml -O

# modify pod network CIDR in custom-resources.yaml
sed -i 's/192.168.0.0\/16/10.0.1.0\/24/g' custom-resources.yaml

# Apply the Calico custom resources
#echo "Applying the Calico custom resources..."
#kubectl apply -f custom-resources.yaml


