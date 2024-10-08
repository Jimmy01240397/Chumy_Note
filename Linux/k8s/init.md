# k8s install

ref: [about install 1](https://www.linuxtechi.com/install-kubernetes-cluster-on-debian/)

ref: [about install 2](https://ithelp.ithome.com.tw/articles/10236963)
``` bash
sudo swapoff -a
sudo vi /etc/fstab

echo "overlay
br_netfilter" | sudo tee /etc/modules-load.d/containerd.conf
for a in $(cat /etc/modules-load.d/containerd.conf)
do
    sudo modprobe $a
done

echo "net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1" | sudo tee /etc/sysctl.d/98-k8s.conf

sudo sysctl --system

sudo apt install containerd -y

sudo sed -i 's/SystemdCgroup = .*/SystemdCgroup = true/g' /etc/containerd/config.toml
sudo systemctl restart containerd

sudo apt install gnupg gnupg2 curl software-properties-common -y
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/cgoogle.gpg
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/k8s.list

sudo apt install kubelet kubeadm kubectl -y
```

# k8s master init
ref: [for init failed](https://blog.csdn.net/woay2008/article/details/93250137)

``` bash
rm -r $HOME/.kube
sudo kubeadm init --control-plane-endpoint=k8s-master --pod-network-cidr=10.244.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# setup kube-flannel
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml  
```
ref: [about join token](https://sleeplessbeastie.eu/2020/10/02/how-to-display-command-to-join-kubernetes-cluster/)

show master info
``` bash
kubectl get nodes
kubectl cluster-info
```

# k8s cluster join
ref: [about join token](https://sleeplessbeastie.eu/2020/10/02/how-to-display-command-to-join-kubernetes-cluster/)
``` bash
sudo kubeadm join k8s-master:6443 --token ${tokenid} --discovery-token-ca-cert-hash ${tokenhash}
```

# k8s dashboard
ref: [install dashboard](https://kubernetes.io/zh-cn/docs/tasks/access-application-cluster/web-ui-dashboard/)

``` bash
# setup kubernetes-dashboard
sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

# setup kubectl proxy
# HOME=/home/$USER
sudo kubectl proxy

# setup https

curl https://192.168.100.149/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login
```
![image](https://github.com/Jimmy01240397/IT_System_Admin_Note/assets/57281249/9ea16896-7860-46ed-b361-d828a067929f)

setup user token

ref: [install dashboard and setup service account 1](https://medium.com/learn-or-die/kubernetes-dashboard-%E4%BD%BF%E7%94%A8%E8%87%AA%E5%AE%9A%E7%BE%A9-service-account-%E7%99%BB%E5%85%A5-b136669fff34)

ref: [install dashboard and setup service account 2](https://upcloud.com/resources/tutorials/deploy-kubernetes-dashboard)

ref: [about service account didn't have secret](https://stackoverflow.com/questions/72256006/service-account-secret-is-not-listed-how-to-fix-it)

``` bash
kubectl create sa admin -n kubernetes-dashboard

echo "kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: cluster-admin-binding
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
subjects:
- kind: ServiceAccount
  name: admin
  namespace: kubernetes-dashboard" | kubectl create -f -

kubectl create token admin -n kubernetes-dashboard
```

setup user kubeconfig

ref: [kubeconfig setup 1](https://jimmysong.io/kubernetes-handbook/guide/authenticate-across-clusters-kubeconfig.html)

ref: [kubeconfig setup 2](https://stackoverflow.com/questions/70287656/kubernetes-dashboard-internal-error-500-not-enough-data-to-create-auth-info)

generate script
``` bash
#!/bin/bash
if [ $# -lt 1 ]
then
    echo "Usage: $0 <clustername> <username>"
fi

echo "apiVersion: v1
clusters:
- cluster:
    server: https://$1:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: $2
  name: kubernetes
current-context: "kubernetes"
kind: Config
preferences: {}
users:
- name: $2
  user:
    token: $(kubectl create token $2 -n kubernetes-dashboard)"
```
