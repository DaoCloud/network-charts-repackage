#!/usr/bin/env bash

# 获取压缩包路径
OPERATOR=$1
REGISTRY=$2 # release-ci.daocloud.io

# 判断文件是否存在
if [ ! -f "$OPERATOR" ]; then
  echo "Error: File '$OPERATOR' does not exist."
  exit 2
fi


# 使用正则表达式提取版本号
MX_VERSION=$(echo ${OPERATOR} | awk -F'metax-gpu-k8s-package.|.tgr.gz' '{print $2}' | awk -F '.tar.gz' '{print $1}')

# 输出版本号
if [ -n "$MX_VERSION" ]; then
  echo "Extracted version: $MX_VERSION"
else
  echo "Failed to extract version"
  exit 1
fi

function decompress() {
    rm -rf metax-gpu-k8s-package.${MX_VERSION}
    mkdir metax-gpu-k8s-package.${MX_VERSION}
    tar -zxvf $OPERATOR -C metax-gpu-k8s-package.${MX_VERSION}
    echo "Extraction completed successfully."
}

function pushMultiImage() {
  ./metax-gpu-k8s-package.${MX_VERSION}/metax-k8s-images.${MX_VERSION}.run push ${REGISTRY}/metax
  bash ./data/k8s-driver-image.2.25.2.8-aarch64.run push ${REGISTRY}/metax
  bash ./data/k8s-driver-image.2.25.2.8-x86_64.run push ${REGISTRY}/metax


  DRIVER_VERSION=$(echo "k8s-driver-image.2.25.2.8-x86_64.run" | awk -F'k8s-driver-image.|-x86_64.run' '{print $2}')
  echo "DRIVER_VERSION is " $DRIVER_VERSION
  docker manifest create ${REGISTRY}/metax/driver-image:${DRIVER_VERSION} \
      ${REGISTRY}/metax/driver-image:${DRIVER_VERSION}-arm64 \
      ${REGISTRY}/metax/driver-image:${DRIVER_VERSION}-amd64


  docker manifest annotate ${REGISTRY}/metax/driver-image:${DRIVER_VERSION} \
      ${REGISTRY}/metax/driver-image:${DRIVER_VERSION}-amd64 --arch amd64

  docker manifest annotate ${REGISTRY}/metax/driver-image:${DRIVER_VERSION} \
      ${REGISTRY}/metax/driver-image:${DRIVER_VERSION}-arm64 --arch arm64

  docker manifest push ${REGISTRY}/metax/driver-image:${DRIVER_VERSION}
  cd -
}

function packageHelm() {
    tar -zxf ./metax-gpu-k8s-package.${MX_VERSION}/metax-operator-${MX_VERSION}.tgz
}


action=$3
case "$action" in
  all)
    echo "decompress->pushMultiImage->packageHelm"
    decompress
    pushMultiImage
    packageHelm
    ;;
  dc)
    echo "decompress"
    decompress
    ;;
  image)
    echo "pushMultiImage"
    pushMultiImage
    ;;
  dc-image)
    echo "decompress->pushMultiImage"
    decompress
    pushMultiImage
    ;;
  helm)
    echo "packageHelm"
    packageHelm
    ;;
  push-helm)
     echo "pushHelm"
#     helm repo add addon https://${REGISTRY}/chartrepo/addon --username=admin --password=${PASSWORD}
     helm package metax-operator
     helm cm-push metax-operator-${MX_VERSION}.tgz addon
    ;;
  *)
    echo "无效选项，请输入 all/dc/image/helm 之一"
    ;;
esac