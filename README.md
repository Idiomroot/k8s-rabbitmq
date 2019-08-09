## k8s安装rabbitmq集群
一、下载rabbitmq集群插件
###### # git clone https://github.com/Idiomroot/k8s-rabbitmq.git
###### # mkdir plugins && cd plugins
###### # wget https://github.com/rabbitmq/rabbitmq-autocluster/releases/download/0.10.0/autocluster-0.10.0.ez
###### # wget https://github.com/rabbitmq/rabbitmq-autocluster/releases/download/0.10.0/rabbitmq_aws-0.10.0.ez
二、构建镜像
###### # cd ../
###### # docker build -t 172.16.0.14:5000/pointsmart/rabbitmq3.7:v4 .
###### # docker push 172.16.0.14:5000/pointsmart/rabbitmq3.7:v4
三、生成cookie文件
###### # sh erlang-cookie.sh
四、配置rbac
###### # kubectl create -f rabbitmq-rbac.yaml
五、配置service
###### # kubectl create -f serveice-rabbitmq.yaml
六、创建StatefulSet
###### # kubectl create -f StatefulSet.yaml
七、如果没有存储类，则直接创建PV和PVC
###### # kubectl create -f nfs-data.yaml
八、查看已经生成服务
###### # kubectl get pod -o wide| grep rabbitmq
###### rabbitmq-0 1/1 Running 0 126m 172.30.28.2 172.16.0.9 <none> <none>
###### rabbitmq-1 1/1 Running 0 126m 172.30.3.2 172.16.0.8 <none> <none>
###### rabbitmq-2 1/1 Running 0 86m 172.30.28.7 172.16.0.9 <none> <none>
###### # kubectl describe service rabbitmq
###### Name: rabbitmq
###### Namespace: default
###### Labels: app=rabbitmq
###### Annotations: <none>
###### Selector: app=rabbitmq
###### Type: ClusterIP
###### IP: None
###### Port: amqp 5672/TCP
###### TargetPort: 5672/TCP
###### Endpoints: 172.30.28.2:5672,172.30.28.7:5672,172.30.3.2:5672
###### Session Affinity: None
###### Events: <none>
###### # kubectl describe service rabbitmq-service
###### Name: rabbitmq-service
###### Namespace: default
###### Labels: <none>
###### Annotations: <none>
###### Selector: app=rabbitmq
###### Type: NodePort
###### IP: 10.254.216.47
###### Port: mangement 15672/TCP
###### TargetPort: 15672/TCP
###### NodePort: mangement 32001/TCP
###### Endpoints: 172.30.28.2:15672,172.30.28.7:15672,172.30.3.2:15672
###### Port: smp 5672/TCP
###### TargetPort: 5672/TCP
###### NodePort: smp 32002/TCP
###### Endpoints: 172.30.28.2:5672,172.30.28.7:5672,172.30.3.2:5672
###### Session Affinity: None
###### External Traffic Policy: Cluster
###### Events: <none>
###### 网页访问：http://nodeip:32001
###### 注意：如果启动后出现报错： 
###### =INFO REPORT==== 8-Aug-2019::08:09:41 ===
###### autocluster: (cleanup) No partitioned nodes found.
###### 解决办法：需要将其他两个节点加入到第一个节点中
###### #kubectl exec -it rabbitmq-xxxxx /bin/bash 
###### root@rabbitmq-xxxxx:/#rabbitmqctl stop_app
###### root@rabbitmq-xxxxx:/#rabbitmqctl join_cluster  rabbit@rabbitmq-0
###### root@rabbitmq-xxxxx:/#rabbitmqctl start_app
###### 若出现节点无法加入集群的问题
###### root@rabbitmq-xxxxx:/#rabbitmqctl reset
###### root@rabbitmq-xxxxx:/#rabbitmqctl join_cluster  rabbit@rabbitmq-0
###### root@rabbitmq-xxxxx:/#rabbitmqctl start_app
