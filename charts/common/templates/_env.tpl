{{/*
Merged env variables for component
*/}}
{{- define "common.env" -}}
{{- $envKv := (include "common.envKv" . | fromYaml).env | default (list) }}
{{- $envSecret := (include "common.envSecret" . | fromYaml).env | default (list) }}
{{- $envRaw := (include "common.envRaw" . | fromYaml).env | default (list) }}
{{- $env := concat $envKv $envSecret $envRaw | default (list) }}
{{- with $env -}}
{{- toYaml . }}
{{- end -}}
{{- end -}}

{{/*
Key-value environment variables
*/}}
{{- define "common.envKv" -}}
{{- $env := .env | default (dict) }}
{{- if .merge }}
{{- $env = merge (.env | default (dict)) (.context.Values.env | default (dict)) }}
{{- else }}
{{- end }}
{{- with $env -}}
env:
{{- range $key, $val := . }}
  - name: {{ $key | quote }}
    value: {{ $val | quote }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Secret key-value environment variables
*/}}
{{- define "common.envSecret" -}}
{{- $env := .envSecret | default (dict) }}
{{- if .merge }}
{{- $env = merge (.envSecret | default (dict)) (.context.Values.envSecret | default (dict)) }}
{{- end }}
{{- with $env -}}
env:
{{- range $key, $val := . }}
  - name: {{ $key | quote }}
    valueFrom:
      secretKeyRef:
        key: {{ $key | lower | replace "_" "-" }}
        name: {{ $val }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Raw environment variables
*/}}
{{- define "common.envRaw" -}}
{{- $env := .envRaw | default (list) }}
{{- if .merge }}
{{- $env = concat (.envRaw | default (list)) (.context.Values.envRaw | default (list)) }}
{{- end }}
{{- with $env -}}
env:
{{- toYaml . | nindent 2 }}
{{- end -}}
{{- end -}}
