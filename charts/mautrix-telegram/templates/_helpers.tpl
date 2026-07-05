{{/*
Expand the name of the chart.
*/}}
{{- define "mautrix-telegram.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mautrix-telegram.fullname" -}}
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
{{- define "mautrix-telegram.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mautrix-telegram.labels" -}}
helm.sh/chart: {{ include "mautrix-telegram.chart" . }}
{{ include "mautrix-telegram.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mautrix-telegram.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mautrix-telegram.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mautrix-telegram.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mautrix-telegram.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Secret name for configEnv — existingSecret if set, otherwise the chart-managed secret.
*/}}
{{- define "mautrix-telegram.configEnv.secretName" -}}
{{- if .Values.configEnv.existingSecret -}}
{{- .Values.configEnv.existingSecret -}}
{{- else -}}
{{- include "mautrix-telegram.fullname" . }}-config-env
{{- end -}}
{{- end -}}

{{/*
Validate configEnv at render time to give clear error messages on misconfiguration.
*/}}
{{- define "mautrix-telegram.configEnv.validate" -}}
{{- if .Values.configEnv.enabled -}}
  {{- if and (not .Values.configEnv.existingSecret) (not .Values.configEnv.secretEnv) -}}
    {{- fail "mautrix-telegram: configEnv.enabled requires either configEnv.existingSecret or configEnv.secretEnv" -}}
  {{- end -}}
  {{- if not .Values.configEnv.variables -}}
    {{- fail "mautrix-telegram: configEnv.enabled requires configEnv.variables to be non-empty" -}}
  {{- end -}}
{{- end -}}
{{- end -}}
