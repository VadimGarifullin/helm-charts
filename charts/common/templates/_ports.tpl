{{/*
Ports list for component
*/}}
{{- define "common.ports" -}}
{{- range . }}
- containerPort: {{ .port }}
  {{- if .name }}
  name: {{ .name }}
  {{- end }}
  protocol: {{ .protocol | default "TCP" }}
{{- end }}
{{- end -}}
