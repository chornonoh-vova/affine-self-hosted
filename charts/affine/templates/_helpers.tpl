{{- define "affine.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "affine.fullname" -}}
{{ include "affine.name" . }}-{{ .Release.Name }}
{{- end }}
