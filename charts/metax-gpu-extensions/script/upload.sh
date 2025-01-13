#!/usr/bin/env bash

# 获取压缩包路径
OPERATOR=$1
REGISTRY=$2 # release-ci.daocloud.io


# 使用正则表达式提取版本号
#MX_VERSION=$(echo ${OPERATOR} | awk -F'metax-gpu-k8s-package.|.tgr.gz' '{print $2}' | awk -F '.tar.gz' '{print $1}')
#
## 输出版本号
#if [ -n "$MX_VERSION" ]; then
#  echo "Extracted version: $MX_VERSION"
#else
#  echo "Failed to extract version"
#  exit 1
#fi

function decompress() {
    # 判断文件是否存在
    if [ ! -f "$OPERATOR" ]; then
      echo "Error: File '$OPERATOR' does not exist."
      exit 2
    fi
    rm -rf metax-gpu-k8s-package.${MX_VERSION}
    mkdir metax-gpu-k8s-package.${MX_VERSION}
    tar -zxvf $OPERATOR -C metax-gpu-k8s-package.${MX_VERSION}
    echo "Extraction completed successfully."
}

function pushMultiImage() {
  ./metax-gpu-k8s-package.${MX_VERSION}/metax-k8s-images.${MX_VERSION}.run push ${REGISTRY}/metax
  cd -
}

function packageHelm() {
    tar -zxf ./metax-gpu-k8s-package.${MX_VERSION}/metax-gpu-extensions-${MX_VERSION}.tgz
}


action=$3
case "$action" in
  all)
    echo "decompress->packageHelm"
    decompress
    packageHelm
    ;;
  dc)
    echo "decompress"
    decompress
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
     helm repo add addon https://${REGISTRY}/chartrepo/addon --username=admin --password=${PASSWORD}
     helm package metax-gpu-extensions
     helm cm-push metax-gpu-extensions-${MX_VERSION}.tgz addon
    ;;
  *)
    echo "无效选项，请输入 all/dc/image/helm 之一"
    ;;
esac