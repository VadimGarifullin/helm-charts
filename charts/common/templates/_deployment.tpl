{{- define "common.deployment" -}}
---

apiVersion: {{ .context.Values.fullnameOverride }}

{{- with .component }}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "common.fullname" $ }}-{{ .name }}
  labels:
    tier: {{ include "common.fullname" $ }}-{{ .name }}
    app: {{ include "common.fullname" $ }}-{{ .name }}
spec:
  replicas: {{ .replicas}}
  selector:
    matchLabels:
      tier: {{ include "common.fullname" $ }}-{{ .name }}
      app: {{ include "common.fullname" $ }}-{{ .name }}
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      labels:
        tier: {{ include "common.fullname" $ }}-{{ .name }}
        app: {{ include "common.fullname" $ }}-{{ .name }}
    spec:
      imagePullSecrets:
        - name: gitlab-registry-creds
      containers:
          {{- include "common.containers" $ | nindent 8 }}
{{- end }}
{{- end -}}