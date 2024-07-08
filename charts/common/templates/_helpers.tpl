{{/*
Expand the name of the chart.
*/}}
{{- define "common.name" -}}
{{- default .context.Chart.Name .context.Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "common.fullname" -}}
{{- if .context.Values.fullnameOverride -}}
{{- .context.Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .context.Chart.Name .context.Values.nameOverride -}}
{{- if contains $name .context.Release.Name -}}
{{- .context.Release.Name | trunc 64 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .context.Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "common.chart" -}}
{{- printf "%s-%s" .context.Chart.Name .context.Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Print "true" if the API pathType field is supported
Usage:
{{ include "common.ingress.supportsPathType" . }}
*/}}
{{- define "common.ingress.supportsPathType" -}}
{{- if (semverCompare "<1.18-0" (include "common.capabilities.kubeVersion" .)) -}}
{{- print "false" -}}
{{- else -}}
{{- print "true" -}}
{{- end -}}
{{- end -}}

{{/*
Generate backend entry that is compatible with all Kubernetes API versions.
Usage:
{{ include "common.ingress.backend" (dict "serviceName" "backendName" "servicePort" "backendPort" "context" $) }}

Params:
  - serviceName - String. Name of an existing service backend
  - servicePort - String/Int. Port name (or number) of the service. It will be translated to different yaml depending if it is a string or an integer.
  - context - Dict - Required. The context for the template evaluation.
*/}}
{{- define "common.ingress.backend" -}}
{{- $apiVersion := (include "common.capabilities.ingress.apiVersion" .context) -}}
{{- if or (eq $apiVersion "extensions/v1beta1") (eq $apiVersion "networking.k8s.io/v1beta1") -}}
serviceName: {{ .serviceName }}
servicePort: {{ .servicePort }}
{{- else -}}
service:
  name: {{ .serviceName }}
  port:
    {{- if typeIs "string" .servicePort }}
    name: {{ .servicePort }}
    {{- else if or (typeIs "int" .servicePort) (typeIs "float64" .servicePort) }}
    number: {{ .servicePort | int }}
    {{- end }}
{{- end -}}
{{- end -}}

{{/*
Print "true" if headlessOnly flag is enabled for component
Usage:
{{ include "common.service.headlessOnly" . }}
*/}}
{{- define "common.service.headlessOnly" -}}
{{- $headlessOnly := false -}}
{{- range .component.ports }}
{{- if .headlessOnly }}
{{- $headlessOnly = true -}}
{{- end }}
{{- end }}
{{- print $headlessOnly -}}
{{- end -}}

{{/*
Print "true" if publishNotReadyAddresses flag is enabled for component
Usage:
{{ include "common.service.publishNotReadyAddresses" . }}
*/}}
{{- define "common.service.publishNotReadyAddresses" -}}
{{- $publishNotReadyAddresses := false -}}
{{- range .component.ports }}
{{- if .publishNotReadyAddresses }}
{{- $publishNotReadyAddresses = true -}}
{{- end }}
{{- end }}
{{- print $publishNotReadyAddresses -}}
{{- end -}}
