echo $(openssl rand -base64 32) > erlang.cookie
kubectl create secret generic erlang.cookie --from-file=erlang.cookie
