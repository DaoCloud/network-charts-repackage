{{/*
Expand the name of the chart.
*/}}
{{- define "GPUExt.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "GPUExt.fullname" -}}
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
{{- define "GPUExt.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "GPUExt.labels" -}}
helm.sh/chart: {{ include "GPUExt.chart" . }}
{{ include "GPUExt.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "GPUExt.selectorLabels" -}}
app.kubernetes.io/name: {{ include "GPUExt.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "GPUExt.serviceAccountName" -}}
{{- default (include "GPUExt.name" .) .Values.serviceAccountName }}
{{- end }}
{{- define "GPUExt.roleName" -}}
{{ include "GPUExt.serviceAccountName" .}}-role
{{- end }}
{{- define "GPUExt.roleBindingName" -}}
{{ include "GPUExt.serviceAccountName" .}}-rolebinding
{{- end }}

{{- define "GPUExt.deviceImage" -}}
{{- default "gpu-device" ((.Values.gpuDevice).image).name }}:{{ default .Chart.Version ((.Values.gpuDevice).image).tag }}
{{- end }}

{{- define "GPUExt.labelImage" -}}
{{- default "gpu-label" ((.Values.gpuLabel).image).name }}:{{ default .Chart.Version ((.Values.gpuLabel).image).tag }}
{{- end }}

{{- define "GPUExt.topoMasterImage" -}}
{{- default "topo-master" (((.Values.topoDiscovery).master).image).name }}:{{ default .Chart.Version (((.Values.topoDiscovery).master).image).version }}
{{- end }}

{{- define "GPUExt.topoMasterDfCmd" -}}
- --mode=dragonfly
- --node-number={{ default "2" ((.Values.topoDiscovery).dragonfly).nodeNumber }}
{{- end }}

{{- define "GPUExt.topoWorkerImage" -}}
{{- default "topo-worker" (((.Values.topoDiscovery).worker).image).name }}:{{ default .Chart.Version (((.Values.topoDiscovery)).worker.image).version }}
{{- end }}

{{- define "GPUExt.topoWorkerDfCmd" -}}
- --detect-mode=dragonfly
- --node-number={{ default "2" ((.Values.topoDiscovery).dragonfly).nodeNumber }}
- --enable-training={{ default false ((.Values.topoDiscovery).dragonfly).enableTraining }}
{{- end }}

{{- define "GPUExt.gpuAwareImage" -}}
{{- default "gpu-aware" ((.Values.gpuAware).image).name }}:{{ default .Chart.Version ((.Values.gpuAware).image).version }}
{{- end }}
