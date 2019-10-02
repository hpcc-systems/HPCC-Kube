# HPCC-Kubernetes
## Deploy a single HPCC pod
### Turning up an HPCC Platform single node
A [_Pod_](https://github.com/kubernetes/kubernetes/blob/master/docs/user-guide/pods.md) is one or more containers that _must_ be scheduled onto the same host.  All containers in a pod share a network namespace, and may optionally share mounted volumes.

Here is the config for the hpcc platform pod: [hpcc.yaml](hpcc.yaml)

Create HPCC Platfrom node as follow:
The current default hpcc pode use HPCC 5.4.8-1 on Ubuntu 14.04 amd64 trusty. You can change to other [HPCC docker images](https://hub.docker.com/r/hpccsystems/platform) or [build a HPCC docker image](https://github.com/hpcc-systems/docker-hpcc) youself.
```sh
kubectl create -f hpcc.yaml
```
For single node deployment HPCC is not started. you can start it as:
```sh
kubectl exec  hpcc -- /etc/init.d/hpcc-init start
Starting mydafilesrv ...       [   OK    ]
Starting mydali ...            [   OK    ]
Starting mydfuserver ...       [   OK    ]
Starting myeclagent ...        [   OK    ]
Starting myeclccserver ...     [   OK    ]
Starting myeclscheduler ...    [   OK    ]
Starting myesp ...             [   OK    ]
Starting myroxie ...           [   OK    ]
Starting mysasha ...           [   OK    ]
Starting mythor ...            [   OK    ]
```
You also can access the contain to run commands:
```sh
kubectl exec  -i -t hpcc -- bash -il
```
Type "exit" to exit it.

Tt
exit

Get HPCC node ip:
```sh
kubectl get pod hpcc -o json | grep podIP
    "podIP": "172.17.0.2",
```
or
```sh
kubectl describe pod hpcc | grep "IP:"
IP:				172.17.0.2
```
You can access ECLWatch from browser: ```hpcc://172.17.0.2:8010```

Pod ip (172.17.0.2) is private. If can't reach it you can try ssh tunnel to the host Linux:
```sh
ssh -L 8010:172.17.0.2:8010 <user>@<host linux ip>
```
Now you can access ECLWatch from your local broswer: ```hpcc://localhost:8010```

### Stop and delete the HPCC pod
```sh
kubectl delete -f hpcc.yaml
