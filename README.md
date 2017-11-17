# Kubeadm Ansible Playbook
Build a Kubernetes cluster using Ansible with kubeadm. The goal is easily install a Kubernetes cluster on machines running `Ubuntu 16.04`, `CentOS 7`.

System requirement:
* Deploy node must be install `Ansible v2.4.0+`.
* All Master/Node should have password-less access from Deploy node.

Add the system information gathered above into a file called `inventory`. For example:
```
[master]
192.16.35.12

[node]
192.16.35.[10:11]

[kube-cluster:children]
master
node
```

After going through the setup, run the `site.yml` playbook:
```sh
$ ansible-playbook site.yml
...
==> master1: TASK [addon : Create Kubernetes dashboard deployment] **************************
==> master1: changed: [192.16.35.12 -> 192.16.35.12]
==> master1:
==> master1: PLAY RECAP *********************************************************************
==> master1: 192.16.35.10               : ok=18   changed=14   unreachable=0    failed=0
==> master1: 192.16.35.11               : ok=18   changed=14   unreachable=0    failed=0
==> master1: 192.16.35.12               : ok=34   changed=29   unreachable=0    failed=0
```

Verify cluster is fully running using kubectl:
```sh
$ export KUBECONFIG=~/admin.conf
$ kubectl get node
NAME      STATUS    AGE       VERSION
master1   Ready     22m       v1.6.3
node1     Ready     20m       v1.6.3
node2     Ready     20m       v1.6.3

$ kubectl get po -n kube-system
NAME                                    READY     STATUS    RESTARTS   AGE
etcd-master1                            1/1       Running   0          23m
...
```

Finally, reset all kubeadm installed state using `reset-site.yml` playbook:
```sh
$ ansible-playbook reset-site.yml
```
