{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "redis-ha.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "redis-ha.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "redis-ha.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "redis-ha.labels" -}}
helm.sh/chart: {{ include "redis-ha.chart" . }}
{{ include "redis-ha.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "redis-ha.selectorLabels" -}}
app.kubernetes.io/name: {{ include "redis-ha.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "redis-ha.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "redis-ha.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "redis-ha.masterGroupName" -}}
{{- $masterGroupName := tpl ( .Values.redis.masterGroupName | default "") . -}}
{{- $validMasterGroupName := regexMatch "^[\\w-\\.]+$" $masterGroupName -}}
{{- if $validMasterGroupName -}}
{{ $masterGroupName }}
{{- else -}}
{{ required "A valid .Values.redis.masterGroupName entry is required (matching ^[\\w-\\.]+$)" ""}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for poddisruptionbudget.
*/}}
{{- define "redis-ha.podDisruptionBudget.apiVersion" -}}
{{- if .Capabilities.APIVersions.Has "policy/v1" }}
{{- print "policy/v1" -}}
{{- else -}}
{{- print "policy/v1beta1" -}}
{{- end -}}
{{- end -}}

{{- define "redis-ha.image" -}}
{{- $registry := coalesce .Values.global.image.registry .Values.image.registry "docker.io" -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion }}
{{- if .Values.image.flavor }}
{{- printf "%s/%s:%s-%s" $registry .Values.image.repository $tag .Values.image.flavor }}
{{- else }}
{{- printf "%s/%s:%s" $registry .Values.image.repository $tag }}
{{- end }}
{{- end }}

{{- define "redis-ha.sysctl.image" -}}
{{- $registry := coalesce .Values.global.image.registry .Values.sysctlImage.image.registry "docker.io" -}}
{{- $tag := coalesce .Values.sysctlImage.image.tag "latest" | toString -}}
{{- printf "%s/%s:%s" $registry .Values.sysctlImage.image.repository $tag -}}
{{- end -}}

{{- define "redis-ha.exporter.image" -}}
{{- $registry := coalesce .Values.global.image.registry .Values.exporter.image.registry "docker.io" -}}
{{- $tag := .Values.exporter.image.tag | default "latest" }}
{{- printf "%s/%s:%s" $registry .Values.exporter.image.repository $tag }}
{{- end }}

{{- define "redis-ha.haproxy.image" -}}
{{- $registry := coalesce .Values.global.image.registry .Values.haproxy.image.registry "docker.io" -}}
{{- $tag := .Values.haproxy.image.tag | default "latest" }}
{{- printf "%s/%s:%s" $registry .Values.haproxy.image.repository $tag }}
{{- end }}

{{- define "redis-ha.configmapTest.image" -}}
{{- $registry := coalesce .Values.global.image.registry .Values.configmapTest.image.registry "docker.io" -}}
{{- $tag := .Values.configmapTest.image.tag | default "latest" }}
{{- printf "%s/%s:%s" $registry .Values.configmapTest.image.repository $tag }}
{{- end }}

{{- define "redis-ha.s3.image" -}}
{{- $registry := coalesce .Values.global.image.registry .Values.restore.s3.image.registry "docker.io" -}}
{{- $tag := .Values.restore.s3.image.tag | default "latest" }}
{{- printf "%s/%s:%s" $registry .Values.restore.s3.image.repository $tag }}
{{- end }}

{{- define "redis-ha.ssh.image" -}}
{{- $registry := coalesce .Values.global.image.registry .Values.restore.ssh.image.registry "docker.io" -}}
{{- $tag := .Values.restore.ssh.image.tag | default "latest" }}
{{- printf "%s/%s:%s" $registry .Values.restore.ssh.image.repository $tag }}
{{- end }}
