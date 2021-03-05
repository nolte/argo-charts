```
export PDNS_API_KEY=supersecretpw \
&& export PDNS_SERVER_URL=http://localhost:8081

kubectl -n powerdns port-forward svc/powerdns-webserver 8081
```