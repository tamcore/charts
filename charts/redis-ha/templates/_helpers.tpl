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
Return sysctl image
*/}}
{{- define "redis.sysctl.image" -}}
{{- $registry := coalesce .Values.global.image.registry .Values.sysctlImage.image.registry "docker.io" -}}
{{- $tag := coalesce .Values.sysctlImage.image.tag "latest" | toString -}}
{{- printf "%s/%s:%s" $registry .Values.sysctlImage.image.repository $tag -}}
{{- end -}}

{{- /*
Credit: @technosophos
https://github.com/technosophos/common-chart/
labels.standard prints the standard Helm labels.
The standard labels are frequently used in metadata.
*/ -}}
{{- define "labels.standard" -}}
app: {{ template "redis-ha.name" . }}
heritage: {{ .Release.Service | quote }}
release: {{ .Release.Name | quote }}
chart: {{ template "chartref" . }}
{{- end -}}

{{- /*
Credit: @technosophos
https://github.com/technosophos/common-chart/
chartref prints a chart name and version.
It does minimal escaping for use in Kubernetes labels.
Example output:
  zookeeper-1.2.3
  wordpress-3.2.1_20170219
*/ -}}
{{- define "chartref" -}}
  {{- replace "+" "_" .Chart.Version | printf "%s-%s" .Chart.Name -}}
{{- end -}}

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

{{- define "redis-ha.exporter.image" -}}
{{- $registry := coalesce .Values.global.image.registry .Values.exporter.image.registry "docker.io" -}}
{{- $tag := .Values.exporter.image.tag | default "latest" }}
{{- printf "%s/%s:%s" $registry .Values.image.repository $tag }}
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
