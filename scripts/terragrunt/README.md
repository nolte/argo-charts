# Service Configurations

```
terragrunt apply-all
```


```
export AWS_S3_ENDPOINT="http://minio.172-17-0-1.sslip.io" \
  && export AWS_ACCESS_KEY_ID=$(kubectl -n minio get secrets minio -ojson | jq '.data.accesskey' -r | base64 -d) \
  && export AWS_SECRET_ACCESS_KEY=$(kubectl -n minio get secrets minio -ojson | jq '.data.secretkey' -r | base64 -d) \
  && export MINIO_ENDPOINT="minio.172-17-0-1.sslip.io" \
  && export MINIO_ACCESS_KEY=$(kubectl -n minio get secrets minio -ojson | jq '.data.accesskey' -r | base64 -d) \
  && export MINIO_SECRET_KEY=$(kubectl -n minio get secrets minio -ojson | jq '.data.secretkey' -r | base64 -d) \
  && export MINIO_ENABLE_HTTPS=false \
  && export VAULT_ADDR=https://vault.172-17-0-1.sslip.io \
  && export VAULT_SKIP_VERIFY=true \
  && export VAULT_TOKEN=s.71OIfGZPdzYKaKGt521EjJsk \
  && export KUBE_CONFIG_PATH=~/.kube/config \
  && export KEYCLOAK_URL=https://keycloak.172-17-0-1.sslip.io \
  && export KEYCLOAK_USER=admin \
  && export KEYCLOAK_PASSWORD=admin \
  && export KEYCLOAK_CLIENT_ID=admin-cli

```