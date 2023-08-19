{{/*
Expand the name of the chart.
*/}}
{{- define "common.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "common.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "common.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "common.labels" -}}
helm.sh/chart: {{ include "common.chart" . }}
{{ include "common.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "common.selectorLabels" -}}
app.kubernetes.io/name: {{ include "common.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "common.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "common.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the path to redis
*/}}
{{- define "goat.redisHost" -}}
{{- if  .Values.redis.enabled }}    
    {{- printf "%s-redis-master.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- else -}}
    {{- printf  .Values.redis.host  -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to rabbitmq
*/}}
{{- define "goat.rabbitmqHost" -}}
{{- if  .Values.rabbitmq.enabled }}    
    {{- printf "%s-rabbitmq.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- else -}}
    {{- printf  .Values.rabbitmq.host  -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to postgres
*/}}
{{- define "goat.postgresqlHost" -}}
{{- if  .Values.rabbitmq.enabled }}    
    {{- printf "%s-postgresql.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- else -}}
    {{- printf  .Values.postgresql.auth.host  -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to mongodb
*/}}
{{- define "goat.mongodbString" -}}
{{- if  .Values.mongodb.enabled }}    
    {{- printf "mongodb://%s:%s@%s-mongodb.%s.svc.cluster.local:27017/?authMechanism=DEFAULT" .Values.mongodb.auth.username .Values.mongodb.auth.password .Release.Name .Release.Namespace  -}}
{{- else -}}
    {{- printf "mongodb://%s:%s@%s:%s/?authMechanism=DEFAULT" .Values.mongodb.auth.username .Values.mongodb.auth.password .Values.mongodb.host .Values.mongodb.port  -}}
{{- end -}}
{{- end -}}