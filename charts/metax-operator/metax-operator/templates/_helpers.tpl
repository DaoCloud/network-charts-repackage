{{/*
Expand the name of the chart.
*/}}
{{- define "metax-operator.name" -}}
{{- default .Chart.Name .Values.controller.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "metax-operator.fullname" -}}
{{- if .Values.controller.fullnameOverride }}
{{- .Values.controller.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.controller.nameOverride }}
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
{{- define "metax-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "metax-operator.labels" -}}
helm.sh/chart: {{ include "metax-operator.chart" . }}
{{ include "metax-operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "metax-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "metax-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: "metax-operator"
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "metax-operator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "metax-operator.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
{{- define "metax-operator.roleName" -}}
{{ include "metax-operator.serviceAccountName" .}}-role
{{- end }}
{{- define "metax-operator.roleBindingName" -}}
{{ include "metax-operator.serviceAccountName" .}}-rolebinding
{{- end }}


{{- define "controller.name" -}}
{{- default "operator-controller" ((.Values.controller).image).name }}
{{- end }}
{{- define "controller.version" -}}
{{- default .Chart.Version ((.Values.controller).image).version }}
{{- end }}
{{- define "controller.pullPolicy" -}}
{{- default .Values.pullPolicy ((.Values.controller).image).pullPolicy }}
{{- end }}
{{- define "controller.registry" -}}
{{- default .Values.registry ((.Values.controller).image).registry }}
{{- end }}


{{- define "driver.name" -}}
{{- default "driver-manager" ((.Values.driver).image).name }}
{{- end }}
{{- define "driver.version" -}}
{{- default .Chart.Version ((.Values.driver).image).version }}
{{- end }}
{{- define "driver.registry" -}}
{{- default .Values.registry ((.Values.driver).image).registry }}
{{- end }}
