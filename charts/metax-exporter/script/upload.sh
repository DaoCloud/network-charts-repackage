#!/usr/bin/env bash

# 获取压缩包路径
EXPORTER=$1
REGISTRY=$2 # release-ci.daocloud.io

# 判断文件是否存在
if [ ! -f "$EXPORTER" ]; then
  echo "Error: File '$EXPORTER' does not exist."
  exit 2
fi




function decompress() {
    rm -rf mx-exporter
    # 获取文件扩展名
    EXT="${EXPORTER##*.}"

    # 根据扩展名选择解压命令
    case "$EXT" in
      tar)
        tar -xvf "$EXPORTER"
        ;;
      tar.gz|tgz)
        tar -xvzf "$EXPORTER"
        ;;
      zip)
        unzip "$EXPORTER"
        ;;
      tar.bz2|tbz)
        tar -xvjf "$EXPORTER"
        ;;
      *)
        echo "Error: Unsupported archive format '$EXT'."
        exit 3
        ;;
    esac

    echo "Extraction completed successfully."
}

function pushMultiImage() {
  echo "Load image push to registry" $REGISTRY
  cd mx-exporter
  docker load -i mx-exporter-${MX_VERSION}-arm64.xz
  docker tag cr.metax-tech.com/cloud/mx-exporter:${MX_VERSION} ${REGISTRY}/metax/mx-exporter:${MX_VERSION}-arm64
  docker push ${REGISTRY}/metax/mx-exporter:${MX_VERSION}-arm64

  docker load -i mx-exporter-${MX_VERSION}-amd64.xz
  docker tag cr.metax-tech.com/cloud/mx-exporter:${MX_VERSION} ${REGISTRY}/metax/mx-exporter:${MX_VERSION}-amd64
  docker push ${REGISTRY}/metax/mx-exporter:${MX_VERSION}-amd64

  docker manifest create ${REGISTRY}/metax/mx-exporter:${MX_VERSION} \
      ${REGISTRY}/metax/mx-exporter:${MX_VERSION}-arm64 \
      ${REGISTRY}/metax/mx-exporter:${MX_VERSION}-amd64


  docker manifest annotate ${REGISTRY}/metax/mx-exporter:${MX_VERSION} \
      ${REGISTRY}/metax/mx-exporter:${MX_VERSION}-amd64 --arch amd64

  docker manifest annotate ${REGISTRY}/metax/mx-exporter:${MX_VERSION} \
      ${REGISTRY}/metax/mx-exporter:${MX_VERSION}-arm64 --arch arm64

  docker manifest push ${REGISTRY}/metax/mx-exporter:${MX_VERSION}

  docker rmi ${REGISTRY}/metax/mx-exporter:${MX_VERSION}-arm64
  docker rmi ${REGISTRY}/metax/mx-exporter:${MX_VERSION}-amd64
  docker rmi cr.metax-tech.com/cloud/mx-exporter:${MX_VERSION}
}

#function packageHelmAndPush() {
#    CHART_DIR=./mx-exporter/deployment/mx-exporter/helm/mx-exporter
#    echo "Helm chart directory: $CHART_DIR"
#    # 使用 Helm 打包
#    helm package "$CHART_DIR"
#
#    if [ $? -ne 0 ]; then
#      echo "Error: Helm package failed."
#      exit 5
#    fi
#
#    PACKAGE_FILE=$(find "." -name "*.tgz" | head -n 1)
#
#    if [ -z "$PACKAGE_FILE" ]; then
#      echo "Error: No Helm package file generated."
#      exit 6
#    fi
#
#    echo "Helm package created: $PACKAGE_FILE"
#
#    # 推送到 release-ci.daocloud.io 仓库
#    helm repo add release-ci --username=admin --password=${ADMIN_PASSWORD} "https://${REGISTRY}/chartrepo/addon"
#    helm cm-push "$PACKAGE_FILE" release-ci
#
#    if [ $? -ne 0 ]; then
#      echo "Error: Failed to push Helm chart to release-ci.daocloud.io."
#      exit 7
#    fi
#
#    echo "Helm chart successfully pushed to release-ci.daocloud.io."
#    rm -rf "$PACKAGE_FILE"
#}


action=$3
case "$action" in
  all)
    echo "decompress->pushMultiImage->packageHelmAndPush"
    decompress
    pushMultiImage
#    packageHelmAndPush
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
  helm-push)
    echo "push helm"
#     helm repo add addon https://${REGISTRY}/chartrepo/addon --username=admin --password=${PASSWORD}
     helm package metax-exporter
     helm cm-push metax-exporter-${MX_HELM_VERSION}.tgz addon
    ;;
  *)
    echo "无效选项，请输入 all/dc/image/helm 之一"
    ;;
esac