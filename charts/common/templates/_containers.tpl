{{/*
Component container
*/}}
{{- define "common.containers" -}}
{{- with .component -}}
- name: {{ include "common.name" $ }}-{{ .name }}
  {{- $image := .image | default (dict) }}
  {{- include "common.image" (dict "image" $image "context" $.context) | nindent 2 }}
  {{- with .command }}
  command:
    {{- include "common.command" . | nindent 4 }}
  {{- end }}
  {{- with .securityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- $env := include "common.env" (dict "env" .env "envSecret" .envSecret "envRaw" .envRaw "merge" true "context" $.context) }}
  {{- if $env }}
  env:
    {{- $env | nindent 4 }}
  {{- end }}
  {{- with .ports }}
  ports:
    {{- include "common.ports" . | indent 4 }}
  {{- end }}
  {{- with .probes }}
  {{- with .readiness }}
  readinessProbe: {{- include "common.probe" (dict "probe" . "component" $.component) | indent 4 }}
  {{- end }}
  {{- with .liveness }}
  livenessProbe: {{- include "common.probe" (dict "probe" . "component" $.component) | indent 4 }}
  {{- end }}
  {{- with .startup }}
  startupProbe: {{- include "common.probe" (dict "probe" . "component" $.component) | indent 4 }}
  {{- end }} 
  {{- end }} 
  {{- with .resources }}
  resources:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- if or .preStop .postStart }}
  lifecycle:
    {{- with .postStart }}
    postStart:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with .preStop }}
    preStop:
      {{- toYaml . | nindent 6 }}
    {{- end }}
  {{- end }}
  volumeMounts:
    {{- range .configFiles | default (list) }}
    - name: {{ .name | replace "." "-" }}
      mountPath: {{ .mountPath }}
      {{- with .subPath }}
      subPath: {{ . }}
      {{- end }}
    {{- end }}
    {{- range .emptyDirs | default (list) }}
    - name: {{ .name | replace "." "-" }}
      mountPath: {{ .mountPath }}
    {{- end }}
    {{- with .volumeMounts }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- include "common.containers.sidecar" $ }}
{{- end -}}
{{- end -}}

{{/*
Sidecar containers
*/}}
{{- define "common.containers.sidecar" -}}
{{- range .component.sidecars }}
- name: {{ include "common.name" $ }}-{{ .name }}
  {{- $image := .image | default $.component.image | default (dict) }}
  {{- include "common.image" (dict "image" $image "context" $.context) | nindent 2 }}
  {{- with .command }}
  command:
    {{- include "common.command" . | nindent 4 }}
  {{- end }}
  {{- with .securityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- $env := include "common.env" (dict "env" .env "envSecret" .envSecret "envRaw" .envRaw "context" $.context) }}
  {{- if $env }}
  env:
    {{- $env | nindent 4 }}
  {{- end }}
{{- end }}
{{- end -}}

{{/*
Init containers
*/}}
{{- define "common.containers.init" -}}
{{- range .component.initContainers }}
- name: {{ include "common.name" $ }}-{{ .name }}
  {{- $image := .image | default (dict) }}
  {{- include "common.image" (dict "image" $image "context" $.context) | nindent 2 }}
  {{- with .command }}
  command:
    {{- include "common.command" . | nindent 4 }}
  {{- end }}
  {{- $env := include "common.env" (dict "env" .env "envSecret" .envSecret "envRaw" .envRaw "context" $.context) }}
  {{- if $env }}
  env:
    {{- $env | nindent 4 }}
  {{- end }}
  {{- with .securityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  volumeMounts:
    - name: tz-config
      mountPath: /etc/localtime
      readOnly: true
    {{- with .volumeMounts }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
{{- end }}

{{- end -}}
