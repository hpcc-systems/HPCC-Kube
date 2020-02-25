{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "chart-name" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
 {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create fully qualified names.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "hpccsystems-fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hpccsystems-chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "hpccsystems-name" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "admin.entrypoint.command" -}}
{{- printf "[\"/opt/hpcc-tools/run\"]" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "admin.entrypoint.args.auto" -}}
{{- printf "[\"-e\", \"kube\"]" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "admin.entrypoint.args" -}}
{{- printf "[\"-D\"]" | trunc 63 | trimSuffix "-" -}}
{{- end -}}