{{- define "common.command" -}}
{{- if kindIs "string" . }}
{{- toYaml (splitList " " .) }}
{{- else if kindIs "slice" . }}
{{- toYaml . }}
{{- else }}
{{- toYaml (. | toString | splitList " ") }}
{{- end }}
{{- end -}}