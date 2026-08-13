{{/*
Chart name.
*/}}
{{- define "shophub.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Fully qualified app name — <release>-<chart> unless the release name already contains the
chart name, or the chart name is overridden via .Values.fullnameOverride.
*/}}
{{- define "shophub.fullname" -}}
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
Common labels.
*/}}
{{- define "shophub.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{ include "shophub.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag | default .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "shophub.selectorLabels" -}}
app.kubernetes.io/name: {{ include "shophub.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
ServiceAccount name to use.
*/}}
{{- define "shophub.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "shophub.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Name of the JWT signing key Secret to use — either a user-supplied existingSecret, or the one
this chart generates from .Values.jwt.signingKey.
*/}}
{{- define "shophub.jwtSecretName" -}}
{{- if .Values.jwt.existingSecret }}
{{- .Values.jwt.existingSecret }}
{{- else }}
{{- printf "%s-jwt" (include "shophub.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Name of the database connection string Secret to use — either a user-supplied existingSecret,
or the one this chart generates from .Values.database.connectionString.
*/}}
{{- define "shophub.databaseSecretName" -}}
{{- if .Values.database.existingSecret }}
{{- .Values.database.existingSecret }}
{{- else }}
{{- printf "%s-database" (include "shophub.fullname" .) }}
{{- end }}
{{- end }}
