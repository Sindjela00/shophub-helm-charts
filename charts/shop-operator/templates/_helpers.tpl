{{/*
Chart name.
*/}}
{{- define "shop-operator.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Fully qualified app name — <release>-<chart> unless the release name already contains the
chart name, or the chart name is overridden via .Values.fullnameOverride.
*/}}
{{- define "shop-operator.fullname" -}}
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
{{- define "shop-operator.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{ include "shop-operator.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag | default .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "shop-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "shop-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
ServiceAccount name to use.
*/}}
{{- define "shop-operator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "shop-operator.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Name of the Discord bot credentials Secret to use — either a user-supplied existingSecret, or
the one this chart generates from .Values.discord.botToken/guildId.
*/}}
{{- define "shop-operator.discordSecretName" -}}
{{- if .Values.discord.existingSecret }}
{{- .Values.discord.existingSecret }}
{{- else }}
{{- printf "%s-discord" (include "shop-operator.fullname" .) }}
{{- end }}
{{- end }}
