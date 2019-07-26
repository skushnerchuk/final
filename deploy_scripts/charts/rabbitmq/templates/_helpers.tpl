{{- define "rabbitmq.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{- define "rabbitmq.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name }}
{{- end -}}
