

helm install vpn-bot ../helm-charts/ --values values.yaml --atomic --dry-run --debug --namespace=test

helm install vpn-bot ../helm-charts/ --values values.yaml --atomic --dry-run --debug --namespace=vpn-bot-stage --set fullnameOverride=vpn-bot

helm install vpn-bot vpn-bot/vpn-bot -f /opt/helm-charts/values.yaml --namespace vpn-bot-stage --set fullnameOverride=vpn-bot


#autoscaling:
#  enabled: false
#  minReplicas: 1
#  maxReplicas: 100
#  targetCPUUtilizationPercentage: 80
#  targetMemoryUtilizationPercentage: 80

wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
chmod a+x /usr/local/bin/yq



yq -i eval '.image.name = "tg-bot-group/vpn-bot"' values.yaml
yq -i eval '.image.tag = "0.0.0-202403300847.gitad22099e"' values.yaml
yq -i eval '.imageRegistry = "gitlab.skylinkbot.ru:5050"' values.yaml

yq -i eval '.env.CI_COMMIT_SHORT_SHA = "d5b53188"' values.yaml
yq -i eval '.env.CI_COMMIT_TAG = ""' values.yaml
yq -i eval '.env.CI_COMMIT_TITLE = "hello"' values.yaml
yq  values.yaml -o json



helm repo add ${CHART} --username ${CI_REGISTRY_USER} --password ${CI_REGISTRY_PASSWORD} ${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/helm/stable
    - helm package ${CHART}
    - helm push ${CHART}*.tgz ${CHART}

curl --request POST --user gitlab-ci-token:$CI_JOB_TOKEN --form "chart=@mychart-0.1.0.tgz" "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/helm/api/<channel>/charts"

helm repo add vpn-bot --username root --password pass https://gitlab.skylinkbot.ru/api/v4/projects/3/packages/helm/stable
curl --request POST --user root:pass --form "chart=@vadim-general-0.1.1.tgz" "https://gitlab.skylinkbot.ru/api/v4/projects/3/packages/helm/api/stable/charts"
helm package vpn-bot

#helm redis install

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo list
helm search repo bitnami | grep redis
helm pull bitnami/redis --untar
helm intall <chart-name> <dir-name-of-redis-chart> -f <dir/values.yaml>
kubectl get secret --namespace default redis -o jsonpath="{.data.redis-password}" | base64 -d

or
kubectl create namespace vpn-bot-stage
helm repo add bitnami https://charts.bitnami.com/bitnami
helm chart pull bitnami/redis
helm upgrade --install \
  redis \
  bitnami/redis \
  --namespace vpn-bot-stage \
  --set service.type=LoadBalancer \
  --set replicas.enabled=true \
  --set replicas.replicaCount=3 \
  --set persistence.disabled=true
  --set global.storageClass="csi-ceph-ssd-ms1"

helm upgrade --install redis bitnami/redis --namespace vpn-bot-stage --set replicas.enabled=true --set replicas.replicaCount=2 --set persistence.disabled=true --set global.storageClass="csi-ceph-ssd-ms1"
--set masters.persistence.storageClass="csi-ceph-ssd-ms1"
--set replicas.persistence.storageClass="csi-ceph-ssd-ms1"
удалить чарт
helm uninstall redis --namespace vpn-bot-stage

kubectl get secret --namespace vpn-bot-stage redis -o jsonpath="{.data.redis-password}" | base64 -d

REDIS=redis://redispass@dev-redis-chart-master:6379/0

celery_broker_url: "redis://pass@redis-master-0:6379/0"

pvc-master.yaml

kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: pvc-for-master-redis
  namespace: vpn-bot-stage
spec:
  storageClassName: "local-storage"
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 4Gi

