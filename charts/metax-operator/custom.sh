#!/usr/bin/env bash

if [ -z "${LOCAL+x}" ]; then
  echo "LOCAL is not defined, skipping..."
  exit 0
fi

bash ./script/upload.sh ./data/metax-gpu-k8s-package.${MX_VERSION}.tar.gz release.daocloud.io dc-image
echo "Upload image complete"

rm -rf metax-operator/
bash ./script/upload.sh ./data/metax-gpu-k8s-package.${MX_VERSION}.tar.gz release.daocloud.io helm
echo "Extracted helm complete"


#yq -i '
#  .registry="release.daocloud.io/metax" |
#  .gpuLabel.image.name="gpu-label" |
#  .gpuLabel.image.version="0.8.1" |
#  .driver.image.name="driver-manager" |
#  .driver.image.version="0.8.1" |
#  .driver.payload.name="driver-image" |
#  .driver.payload.version="2.25.2.8" |
#  .maca.payload.registry="" |
#  .maca.payload.name="cr.metax-tech.com/library/maca-c500" |
#  .maca.payload.version="2.20.2.19-ubuntu22.04-amd64" |
#  .maca.image.name="driver-manager" |
#  .maca.image.version="0.8.1" |
#  .runtime.image.name="container-runtime" |
#  .runtime.image.version="0.8.1" |
#  .gpuDevice.image.name="gpu-device" |
#  .gpuDevice.image.version="0.8.1" |
#  .dataExporter.image.name="mx-exporter" |
#  .dataExporter.image.version="0.8.1" |
#  .controller.image.version="0.8.1"
#' metax-operator/values.yaml

yq -i "
  .registry=\"release.daocloud.io/metax\" |
  .image.registry=\"release.daocloud.io/metax\" |
  .gpuLabel.image.name=\"gpu-label\" |
  .gpuLabel.image.version=\"$MX_VERSION\" |
  .driver.image.name=\"driver-manager\" |
  .driver.image.version=\"$MX_VERSION\" |
  .driver.payload.name=\"driver-image\" |
  .driver.payload.version=\"2.25.2.8\" |
  .maca.payload.registry=\"\" |
  .maca.payload.name=\"cr.metax-tech.com/library/maca-c500\" |
  .maca.payload.version=\"2.20.2.19-ubuntu22.04-amd64\" |
  .maca.image.name=\"driver-manager\" |
  .maca.image.version=\"$MX_VERSION\" |
  .runtime.image.name=\"container-runtime\" |
  .runtime.image.version=\"$MX_VERSION\" |
  .gpuDevice.image.name=\"gpu-device\" |
  .gpuDevice.image.version=\"$MX_VERSION\" |
  .dataExporter.image.name=\"mx-exporter\" |
  .dataExporter.image.version=\"$MX_VERSION\" |
  .controller.image.version=\"$MX_VERSION\"
" metax-operator/values.yaml


# maca-c500:2.19.0.3-ubuntu18.04-amd64 -> cr.metax-tech.com/library/maca-c500:2.20.2.19-ubuntu22.04-amd64
os=$(uname)
echo $os
if [ $os == "Darwin" ];then
   sed -i "" "s/maca-c500:2.19.0.3-ubuntu18.04-amd64/cr.metax-tech.com\/library\/maca-c500:2.20.2.19-ubuntu22.04-amd64/g" ./metax-operator/values.yaml
elif [ $os == "Linux" ]; then
   sed -i  "s/maca-c500:2.19.0.3-ubuntu18.04-amd64/cr.metax-tech.com\/library\/maca-c500:2.20.2.19-ubuntu22.04-amd64/g" ./metax-operator/values.yaml
fi


helm schema-gen metax-operator/values.yaml > metax-operator/values.schema.json
cp -rf parent/ metax-operator/

echo rm -rf ./metax-gpu-k8s-package.${MX_VERSION}
rm -rf ./metax-gpu-k8s-package.${MX_VERSION}

bash ./script/upload.sh ./data/metax-gpu-k8s-package.${MX_VERSION}.tar.gz release.daocloud.io push-helm
rm -rf metax-operator-${MX_VERSION}.tgz
echo "Push helm complete"