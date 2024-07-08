{{/*
Value for `image` and `imagePullPolicy` fields of containers
*/}}
{{- define "common.image" -}}
{{- $registry := .image.registry | default .context.Values.imageRegistry -}}
{{- $name := .image.name | default .context.Values.image.name -}}
{{- $tag := .image.tag | default .context.Values.image.tag -}}
{{- $pullPolicy := .image.pullPolicy | default .context.Values.image.pullPolicy -}}
image: {{ printf "%s/%s:%s" $registry $name $tag }}
{{- if $pullPolicy }}
imagePullPolicy: {{ $pullPolicy }}
{{- end }}
{{- end -}}
