#!/usr/bin/env bash

if [ -z "${LOCAL+x}" ]; then
  echo "LOCAL is not defined, skipping..."
  exit 0
fi

bash ./script/upload.sh ./data/metax-gpu-k8s-package.${MX_VERSION}.tar.gz release.daocloud.io dc-image
echo "Upload complete"

rm -rf metax-gpu-extensions/
bash ./script/upload.sh ./data/metax-gpu-k8s-package.${MX_VERSION}.tar.gz release.daocloud.io helm
echo "Extracted helm complete"

if [ "$MX_VERSION" == "0.9.0" ]; then
  yq -i "
    .registry = \"release.daocloud.io\" |
    .image.registry = \"release.daocloud.io\" |
    .gpuLabel.image.name = \"metax/gpu-label\" |
    .gpuLabel.image.version = \"$MX_VERSION\" |
    .topoDiscovery.master.image.name = \"metax/topo-master\" |
    .topoDiscovery.master.image.version = \"$MX_VERSION\" |
    .topoDiscovery.worker.image.name = \"metax/topo-worker\" |
    .topoDiscovery.worker.image.version = \"$MX_VERSION\" |
    .gpuAware.image.name = \"metax/gpu-aware\" |
    .gpuAware.image.version = \"$MX_VERSION\" |
    .gpuDevice.image.name = \"metax/gpu-device\" |
    .gpuDevice.image.version = \"$MX_VERSION\"
  " metax-gpu-extensions/values.yaml
elif [ "$MX_VERSION" == "0.8.1" ]; then
  yq -i "
    .registry = \"release.daocloud.io\" |
    .image.registry = \"release.daocloud.io\" |
    .gpuLabel.image.name = \"metax/gpu-label\" |
    .gpuLabel.image.version = \"$MX_VERSION\" |
    .topoMaster.image.name = \"metax/topo-master\" |
    .topoMaster.image.version = \"$MX_VERSION\" |
    .topoWorker.image.name = \"metax/topo-worker\" |
    .topoWorker.image.version = \"$MX_VERSION\" |
    .gpuAware.image.name = \"metax/gpu-aware\" |
    .gpuAware.image.version = \"$MX_VERSION\" |
    .gpuDevice.image.name = \"metax/gpu-device\" |
    .gpuDevice.image.version = \"$MX_VERSION\"
  " metax-gpu-extensions/values.yaml

  # 定义目标文件,因为沐曦0.8.1版本有一个bug，所以需要靠这个脚本来修复；等我们不需要这个版本的时候就可以删除这段代码了
  FILE="metax-gpu-extensions/templates/_helpers.tpl"
  # 定义要替换的字符串和替换后的字符串
  OLD_STRING='{{- default "gpu-aware" ((.Values.topoWorker).image).name }}:{{ default .Chart.Version ((.Values.topoWorker).image).version }}'
  NEW_STRING='{{- default "gpu-aware" ((.Values.gpuAware).image).name }}:{{ default .Chart.Version ((.Values.gpuAware).image).version }}'
  # 替换字符串
  os=$(uname)
  if [ $os == "Darwin" ];then
    echo sed -i "" "s|$OLD_STRING|$NEW_STRING|g" "$FILE"
    sed -i "" "s|$OLD_STRING|$NEW_STRING|g" "$FILE"
  elif [ $os == "Linux" ]; then
    echo sed -i "s|$OLD_STRING|$NEW_STRING|g" "$FILE"
    sed -i "s|$OLD_STRING|$NEW_STRING|g" "$FILE"
  fi
  echo "字符串替换完成！"
fi



helm schema-gen metax-gpu-extensions/values.yaml > metax-gpu-extensions/values.schema.json
cp -rf parent/${MX_VERSION}/ metax-gpu-extensions/


echo rm -rf ./metax-gpu-k8s-package.${MX_VERSION}
rm -rf ./metax-gpu-k8s-package.${MX_VERSION}

bash ./script/upload.sh ./data/metax-gpu-k8s-package.${MX_VERSION}.tar.gz release.daocloud.io push-helm
rm -rf metax-gpu-extensions-${MX_VERSION}.tgz
echo "push helm complete"