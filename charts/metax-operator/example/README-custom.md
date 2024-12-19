# This project is offline gpu-operator helm chart

## How To Test

1. make build_chart
```shell
$ cd github.com/daocloud/dce-charts-repackage
$ make build_chart -e PROJECT=gpu-operator
```

2. package helm chart
```shell
$ cd github.com/daocloud/dce-charts-repackage/charts/gpu-operator
$ helm package gpu-operator
```

3. upload to harbor
```shell
$ helm repo add harbor-test-helm-repo --username=xxx --password=xxx http://harbor-test.demo.com.cn:8086/chartrepo/helm-repo
$ helm push gpu-operator-v23.6.1.tgz harbor-test-helm-repo
```

4. download charts-syncer
```shell
https://github.com/DaoCloud/charts-syncer
```

5. sync to local
```shell
$ vim config-save-bundles.yaml
# sync to local
$ charts-syncer sync --config config-save-bundles.yaml --v 5
```

6. sync offline addon to harbor
```shell
$ vim config-write-bundles.yaml
source:
    intermediateBundlesPath: addon # chart tar 包所在的目录，需把 relok8s 生成的 tar 包放到此目录下
target:
    containerRegistry: 10.6.232.5:30727  # 目标镜像仓库地址
    containerRepository: kangaroo # laod 镜像时 project 如果不需要修改可不填写
    repo:
        kind: HARBOR # or as any other supported Helm Chart repository kinds
        url: http://10.6.232.5:30727/chartrepo/kangaroo  #load charts 的目标地址，改为需要的地址即可
        auth:   ## charts仓库用户名密码
            username: admin
            password: Harbor12345
    containers:
        auth:
           username: admin
           password: Harbor12345

$ charts-syncer sync --config config-write-bundles.yaml --insecure=true
```

6. schema-gen
```
$ helm schema-gen values-schema.yaml > values.schema.json
```

