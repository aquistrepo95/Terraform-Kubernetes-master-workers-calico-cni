#!/bin/bash

# set up kubeconfig for the regular user
echo "Setting up kubeconfig for the regular user..."
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# install a pod network add-on (Calico)
echo "Installing Calico CNI network add-on for pod networking..."

# Install the Tigera Calico operator
echo "Installing the Tigera Calico operator"
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.4/manifests/tigera-operator.yaml

# wait for the Calico operator to be ready
echo "Waiting for the Calico operator to be ready..."
sleep 60
echo "Calico operator is ready!"


# GET the Calico custom resources
echo "Installing the Calico custom resources"
curl -s https://raw.githubusercontent.com/projectcalico/calico/v3.31.4/manifests/custom-resources.yaml -O

# modify pod network CIDR in custom-resources.yaml
sed -i 's/192.168.0.0\/16/10.244.0.0\/24/g' custom-resources.yaml

# Apply the Calico custom resources
echo "Applying the Calico custom resources..."
kubectl apply -f custom-resources.yaml

# wait for the Calico components to be ready
echo "Waiting for the Calico components to be ready..."
sleep 60
echo "Calico CNI network add-on installed successfully!"

# install helm
echo "Installing Helm package manager..."
sudo apt-get install curl gpg apt-transport-https --yes
curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm



