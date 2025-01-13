#!/usr/bin/env bash

if [ -z "${LOCAL+x}" ]; then
  echo "LOCAL is not defined, skipping..."
  exit 0
fi

bash ./script/upload.sh ./data/mx-exporter.${MX_VERSION}.tgz release.daocloud.io dc-image
echo "Upload image complete"

CHART_DIR=./mx-exporter/deployment/mx-exporter/helm/mx-exporter

rm -rf metax-exporter/
cp -rf ./mx-exporter/deployment/mx-exporter/helm/mx-exporter metax-exporter
rm -rf mx-exporter

yq -i '
  .name = "metax-exporter"
' metax-exporter/Chart.yaml

yq -i "
  .image.registry=\"release.daocloud.io\" |
  .image.repository = \"metax/mx-exporter\" |
  .image.tag= \"${MX_VERSION}\"
" metax-exporter/values.yaml

os=$(uname)
echo $os
if [ $os == "Darwin" ];then
   sed -i "" "s/{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}/{{ .Values.image.registry }}\/{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}/g" ./metax-exporter/templates/daemonset.yaml
elif [ $os == "Linux" ]; then
   sed -i  "s/{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}/{{ .Values.image.registry }}\/{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}/g" ./metax-exporter/templates/daemonset.yaml
fi


helm schema-gen metax-exporter/values.yaml > metax-exporter/values.schema.json
cp -rf parent/ metax-exporter/


bash ./script/upload.sh ./data/mx-exporter.${MX_VERSION}.tgz release.daocloud.io helm-push
rm -rf metax-exporter-${MX_HELM_VERSION}.tgz
echo "Push helm chart complete"