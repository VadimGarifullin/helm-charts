{{ define "common.ingress" }}
{{- if (default .component.ingress true) }}
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .context.Values.fullnameOverride }}-ingress-{{.component.ingress}}
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-{{ .context.Release.Namespace }}"
spec:
  tls:
  - hosts:
    - {{ .context.Release.Namespace }}.skylinkbot.ru
    secretName: {{ .context.Release.Namespace }}-private-key
  ingressClassName: nginx
  rules:
  - host: {{ .context.Release.Namespace }}.skylinkbot.ru
    http:
      paths:
      - pathType: Prefix
        path: /
        backend:
          service:
            name: {{ .context.Values.fullnameOverride }}-api
            {{- range .component.ports }}
            port:
              number: {{ .port }}
            {{- end }}
{{- end }}
{{ end }}
