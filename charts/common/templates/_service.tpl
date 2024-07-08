{{- define "common.service" -}}
---
apiVersion: v1
kind: Service
metadata:
  name: {{ include "common.fullname" $ }}-{{ .component.name }}
spec:
  selector:
    app: {{ include "common.fullname" $ }}-{{ .component.name }}
  type: ClusterIP
  ports:
  {{- range .component.ports }}
    - port: {{ .port }}
      targetPort: {{ if .name }}{{ .name }}{{ else }}{{ .port }}{{ end }}
      {{- if .name }}
      name: {{ .name }}
      {{- end }}
      protocol: {{ .protocol | default "TCP" }}
  {{- end }}
{{- end -}}