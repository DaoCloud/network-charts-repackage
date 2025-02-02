
<div align="center">

# 核心服务 Helm Chart<!-- omit in toc -->

</div>

中文 | [English](./README.md)


# 目录<!-- omit in toc -->

- [安装](#安装)
  - [安装 Chart](#安装-chart)
  - [检查运行状态](#检查运行状态)
  - [访问服务](#访问服务)
  - [更新配置](#更新配置)
  - [卸载](#卸载)
- [镜像地址与版本](#镜像地址与版本)
- [服务配置](#服务配置)
  - [ClusterIP 模式示例](#clusterip-模式示例)
  - [NodePort 模式示例](#nodeport-模式示例)
- [站点配置](#站点配置)
- [认证配置](#认证配置)
  - [OIDC 单点登录](#oidc-单点登录)
  - [手机号验证码登录](#手机号验证码登录)
- [内置大语言模型配置](#内置大语言模型配置)
  - [语言模型配置项说明](#语言模型配置项说明)
- [OneAPI 大语言模型转发服务配置](#oneapi-大语言模型转发服务配置)
  - [使用内置的 OneAPI 服务](#使用内置的-oneapi-服务)
  - [使用外置的 OneAPI 服务](#使用外置的-oneapi-服务)
- [预制工具](#预制工具)
  - [工具配置项说明](#工具配置项说明)
- [管理后台配置](#管理后台配置)
- [Clash 代理](#clash-代理)
- [副本数](#副本数)
- [中间件配置](#中间件配置)
  - [Postgres 数据库](#postgres-数据库)
    - [使用内置数据库](#使用内置数据库)
    - [使用外置数据库](#使用外置数据库)
      - [Monkeys 业务数据库](#monkeys-业务数据库)
      - [Conductor 数据库](#conductor-数据库)
  - [Elasticsearch 7](#elasticsearch-7)
    - [使用内置 Elasticsearch 7](#使用内置-elasticsearch-7)
    - [使用外置 Elasticsearch 7](#使用外置-elasticsearch-7)
  - [Redis](#redis)
    - [使用内置 Redis](#使用内置-redis)
    - [使用外置 Redis](#使用外置-redis)
      - [单机 Redis](#单机-redis)
      - [Redis 集群](#redis-集群)
        - [Redis sentinel](#redis-sentinel)
  - [MinIO(S3) 存储](#minios3-存储)
    - [使用内置 Minio 存储](#使用内置-minio-存储)
    - [使用外部 S3 存储](#使用外部-s3-存储)
- [服务监控](#服务监控)
  - [安装 Prometheus Operator](#安装-prometheus-operator)
  - [配置项](#配置项)
- [其他](#其他)
  - [Daocloud DCE 菜单配置](#daocloud-dce-菜单配置)


## 安装

### 安装 Chart

```sh
# 添加 Chart 依赖
helm repo add monkeys https://inf-monkeys.github.io/helm-charts

# 安装核心服务
helm install monkeys monkeys/core -n monkeys --create-namespace
```

<details>
<summary><kbd>开发模式</kbd></summary>

Helm Chart 的开发者可以使用下面的命令在本地进行安装：

```sh
cd charts/core
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add elastic https://helm.elastic.co
helm dependency build
helm install monkeys . --values ./values.yaml -n monkeys --create-namespace
```

</details>

### 检查运行状态

```sh
kubectl get pods -n monkeys
kubectl get svc -n monkeys
```

### 访问服务


默认情况下 `values.yaml` 使用 ClusterIP 模式, 你可以通过 **monkeys-proxy** service 访问 monkeys web ui:

```sh
# Get current pod list
kubectl get pods -n monkeys

# Port Forward monkey-proxy-xxxx-xxxx Pod, in this example use local machine's 8080 port.
kubectl port-forward --address 0.0.0.0 monkeys-core-proxy-xxxx-xxxx 8080:80 -n monkeys

# Try
curl http://localhost:8080
```

如果你的服务运行在防火墙后面，请不要忘记打开防火墙。

### 更新配置

创建一个新的 Values yaml 文件, 比如 `prod-core-values.yaml`。

比如说你需要更新 server 的镜像，添加下面的内容到 `prod-core-values.yaml` 中:

```yaml
images:
  server:
    tag: some-new-tag
```

然后执行：

```sh
helm upgrade monkeys .  --namespace monkeys --values ./prod-core-values.yaml
```

### 卸载

```sh
helm uninstall monkeys -n monkeys
```


## 镜像地址与版本

| 参数                           | 描述                                                                          | 默认值                     |
| ------------------------------ | ----------------------------------------------------------------------------- | -------------------------- |
| `images.server.registry`       | 镜像 Registry                                                                 | `docker.io`                |
| `images.server.repository`     | [monkeys](https://github.com/inf-monkeys/monkeys) 服务 Docker 镜像地址        | `infmonkeys/monkeys`       |
| `images.server.tag`            | 版本号号                                                                      | `latest`                   |
| `images.server.pullPolicy`     | 镜像拉取策略                                                                  | `IfNotPresent`             |
| `images.server.pullSecrets`    | 镜像拉取密钥                                                                  | `""`                       |
| `images.web.registry`          | 镜像 Registry                                                                 | `docker.io`                |
| `images.web.repository`        | [前端](https://github.com/inf-monkeys/monkeys/tree/main/ui) Docker 镜像地址   | `infmonkeys/monkeys-ui`    |
| `images.web.tag`               | 版本号                                                                        | `latest`                   |
| `images.web.pullPolicy`        | 镜像拉取策略                                                                  | `IfNotPresent`             |
| `images.web.pullSecrets`       | 镜像拉取密钥                                                                  | `""`                       |
| `images.conductor.registry`    | 镜像 Registry                                                                 | `docker.io`                |
| `images.conductor.repository`  | 流程编排引擎 [conductor](https://github.com/inf-monkeys/conductor) 的镜像地址 | `infmonkeys/conductor-oss` |
| `images.conductor.tag`         | 版本号                                                                        | `latest`                   |
| `images.conductor.pullPolicy`  | 镜像拉取策略                                                                  | `IfNotPresent`             |
| `images.conductor.pullSecrets` | 镜像拉取密钥                                                                  | `""`                       |
| `images.oneapi.registry`       | 镜像 Registry                                                                 | `docker.io`                |
| `images.oneapi.repository`     | [one-api](https://github.com/songquanpeng/one-api) 的镜像地址                 | `justsong/one-api`         |
| `images.oneapi.tag`            | 版本号                                                                        | `latest`                   |
| `images.oneapi.pullPolicy`     | 镜像拉取策略                                                                  | `IfNotPresent`             |
| `images.oneapi.pullSecrets`    | 镜像拉取密钥                                                                  | `""`                       |
| `images.admin.registry`        | 镜像 Registry                                                                 | `docker.io`                |
| `images.admin.repository`      | 管理后台的镜像地址                                                            | `infmonkeys/monkeys-admin` |
| `images.admin.tag`             | 版本号                                                                        | `latest`                   |
| `images.admin.pullPolicy`      | 镜像拉取策略                                                                  | `IfNotPresent`             |
| `images.admin.pullSecrets`     | 镜像拉取密钥                                                                  | `""`                       |
| `images.clash.registry`        | 镜像 Registry                                                                 | `docker.io`                |
| `images.clash.repository`      | Clash 代理服务的镜像地址                                                      | `infmonkeys/clash`         |
| `images.clash.tag`             | 版本号                                                                        | `latest`                   |
| `images.clash.pullPolicy`      | 镜像拉取策略                                                                  | `IfNotPresent`             |
| `images.clash.pullSecrets`     | 镜像拉取密钥                                                                  | `""`                       |
| `images.busybox.registry`      | 镜像 Registry                                                                 | `docker.io`                |
| `images.busybox.repository`    | Clash 代理服务的镜像地址                                                      | `busybox`                  |
| `images.busybox.tag`           | 版本号                                                                        | `latest`                   |
| `images.busybox.pullPolicy`    | 镜像拉取策略                                                                  | `IfNotPresent`             |
| `images.busybox.pullSecrets`   | 镜像拉取密钥                                                                  | `""`                       |
| `images.nginx.registry`        | 镜像 Registry                                                                 | `docker.io`                |
| `images.nginx.repository`      | Nginx 的镜像地址                                                              | `nginx`                    |
| `images.nginx.tag`             | 版本号                                                                        | `latest`                   |
| `images.nginx.pullPolicy`      | 镜像拉取策略                                                                  | `IfNotPresent`             |
| `images.nginx.pullSecrets`     | 镜像拉取密钥                                                                  | `""`                       |



## 服务配置

默认情况下，使用 ClusterIP 模式，可以 `monkeys-core-proxy`（Nginx 反向代理）`svc` 的 `80` 端口对外暴露服务。

| 参数                | 描述                        | 默认值      |
| ------------------- | --------------------------- | ----------- |
| `service.type`      | `ClusterIP` 或者 `NodePort` | `ClusterIP` |
| `service.port`      | Proxy 组件(Nginx) 暴露端口  | `80`        |
| `service.clusterIP` | ClusterIP                   | `""`        |
| `service.nodePort`  | Node Port 端口              | `""`        |


### ClusterIP 模式示例

```yaml
service:
  type: ClusterIP
  port: 80
  clusterIP: ""
```

### NodePort 模式示例

```yaml
service:
  type: NodePort
  port: 80
  nodePort: 30080
```


## 站点配置

自定义你的站点，比应用 ID、对外访问地址、标题、Logo、认证方式等。

| 参数                                       | 描述                                                                                             | 默认值                                                         |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------ | -------------------------------------------------------------- |
| `server.site.appId`                        | 此次部署服务的唯一 ID，将会作为数据库表、redis key 的前缀。                                      | `monkeys`                                                      |
| `server.site.appUrl`                       | 对外可访问的连接，此配置项会影响到 OIDC 单点登录跳转以及自定义触发器，除此之外不会影响其他功能。 | `http://localhost:3000`                                        |
| `server.site.customization.title`          | 网站标题。                                                                                       | `猴子无限`                                                     |
| `server.site.customization.logo.light`     | 左上角 Logo 图标(Light 模型)。                                                                   | `https://static.infmonkeys.com/logo/InfMonkeys-logo-light.svg` |
| `server.site.customization.logo.dark`      | 左上角 Logo 图标(Dark 模型)。                                                                    | `https://static.infmonkeys.com/logo/InfMonkeys-logo-dark.svg`  |
| `server.site.customization.favicon`        | 浏览器 Favicon 图标                                                                              | `https://static.infmonkeys.com/logo/InfMonkeys-ICO.svg`        |
| `server.site.customization.colors.primary` | 主颜色                                                                                           | `#52ad1f`                                                      |

## 认证配置

目前共支持以下三种用户认证方式：
 
- `password`: 邮箱密码认证；
- `phone`: 手机号验证码认证；
- `oidc`: OIDC 单点登录；

| 参数                  | 描述                                                                     | 默认值     |
| --------------------- | ------------------------------------------------------------------------ | ---------- |
| `server.auth.enabled` | 启用的认证方式，默认只启用密码登录。可选值为 `password`, `oidc`, `phone` | `password` |

### OIDC 单点登录

| 参数                                            | 描述                                                                                                          | 默认值           |
| ----------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | ---------------- |
| `server.auth.oidc.auto_signin`                  | 用户登录时是否自动使用 OIDC 进行登录，设置为 `false` 则需要用户手动点击使用 OIDC 登录按钮才会进行 OIDC 认证。 | `false`          |
| `server.auth.oidc.issuer`                       | OIDC Issuer 地址，如 `https://console.d.run/auth/realms/ghippo`                                               | `""`             |
| `server.auth.oidc.client_id`                    | OIDC Client ID                                                                                                | `""`             |
| `server.auth.oidc.client_secret`                | OIDC Client Secret                                                                                            | `""`             |
| `server.auth.oidc.scope`                        | OIDC 授权时设置的 scope, 如果是 Daocloud DEC，请设置为 `openid profile email phone`                           | `openid profile` |
| `server.auth.oidc.button_text`                  | OIDC 登录按钮文字                                                                                             | `使用 OIDC 登录` |
| `server.auth.oidc.id_token_signed_response_alg` | OIDC ID Token 加密方式。                                                                                      | `RS256`          |

### 手机号验证码登录


| 参数                                     | 描述                                                       | 默认值  |
| ---------------------------------------- | ---------------------------------------------------------- | ------- |
| `server.auth.sms.provider`               | 短信验证码服务商，当前只支持阿里云短信。可选值为 `dysms`。 | `dysms` |
| `server.auth.sms.config.accessKeyId`     | 阿里云 accessKeyId                                         | `""`    |
| `server.auth.sms.config.accessKeySecret` | 阿里云 accessKeySecret                                     | `""`    |
| `server.auth.sms.config.signName`        | 短信签名名称                                               | `""`    |
| `server.auth.sms.config.templateCode`    | 短信模板 Code                                              | `""`    |


## 内置大语言模型配置

你可以设置内置的大语言模型，系统内置的大语言模型所有团队都可以使用。

| 参数        | 描述                                                                  | 默认值 |
| ----------- | --------------------------------------------------------------------- | ------ |
| `llmModels` | 启用的语言模型，详细配置请见[语言模型配置项说明](#语言模型配置项说明) | `[]`   |

### 语言模型配置项说明

你可以按照下面的配置添加任意符合 OpenAI 标准的大语言模型：

| 参数                           | 描述                                                                                                                                                                                                                                     | 默认值  |
| ------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `model`                        | model name，如 `gpt-3.5-turbo`                                                                                                                                                                                                           |         |
| `baseURL`                      | 访问地址，如 `https://api.openai.com/v1`                                                                                                                                                                                                 |         |
| `apiKey`                       | APIKey，如果没有可不填。                                                                                                                                                                                                                 |         |
| `type`                         | 此模型的类型，可选值为 `chat_completions` 和 `completions`，分别表示是一个对话模型还是文本补全模型。不填则表示两种方式都支持。                                                                                                           | `""`    |
| `autoMergeConsecutiveMessages` | 是否自动合并连续的同一个 role 的 messages，通过 VLLM 部署的模型，不能连续传多条为同一个 `role` 的 `message`，如果有多条连续相同 role 的 Message，需要自动合并为一条。如果设置为 `true`，将自动合并为一条 message，使用 `\n\n` 进行分隔。 | `false` |
| `defaultParams`                | 默认请求参数，比如一些模型如 `Qwen/Qwen-7B-Chat-Int4`，需要设置 top 参数。                                                                                                                                                               |         |


以下是一个示例：

```yaml
llmModels:
  - model: gpt-3.5-turbo
    baseURL: https://api.openai.com/v1
    apiKey: xxxxxxxxxxxxxx
    type:
      - chat_completions
  - model: davinci-002
    baseURL: https://api.openai.com/v1
    apiKey: xxxxxxxxxxxxxx
    type:
      - completions
  - model: Qwen/Qwen-7B-Chat-Int4
    baseURL: http://127.0.0.1:8000/v1
    apiKey: token-abc123
    autoMergeConsecutiveMessages: true
    defaultParams:
      stop:
        - <|im_start|>
        - <|im_end|>
```

## OneAPI 大语言模型转发服务配置

如果你需要让用户可以配置自己的大语言模型，需要部署 [one-api](https://github.com/songquanpeng/one-api) （此 Helm Chart 默认会自动启动 one-api 服务）。

### 使用内置的 OneAPI 服务

[one-api](https://github.com/songquanpeng/one-api) 的默认用户名和密码为 `root` 和 `123456`（**无法自定义，请不要修改。**），Monkeys 会使用此账号密码创建 Token，从而[进行 API 调用](https://github.com/songquanpeng/one-api/blob/main/docs/API.md)。

| 参数                  | 描述                           | 默认值   |
| --------------------- | ------------------------------ | -------- |
| `oneapi.enabled`      | 是否启动内置的 `OneAPI` 服务。 | `true`   |
| `oneapi.rootUsername` | 默认的 root 用户名             | `root`   |
| `oneapi.rootPassword` | 默认的 root 密码               | `123456` |

### 使用外置的 OneAPI 服务

你也可以使用外置的 OneAPI 服务：

| 参数                       | 描述                                                                                                         | 默认值   |
| -------------------------- | ------------------------------------------------------------------------------------------------------------ | -------- |
| `externalOneapi.enabled`   | 是否启动内置的 `OneAPI` 服务。                                                                               | `false`  |
| `externalOneapi.baseURL`   | 服务地址，如 `http:127.0.0.1:3000`，最后面请不要带 `\`                                                       | `""`     |
| `externalOneapi.rootToken` | Root 用户的 token，请见[此文档](https://github.com/songquanpeng/one-api/blob/main/docs/API.md)了解如何获取。 | `123456` |


## 预制工具

| 参数    | 描述                                                               | 默认值 |
| ------- | ------------------------------------------------------------------ | ------ |
| `tools` | 启用的预制工具。（不同的工具请通过其相应的 Helm Chart 来进行安装） | `[]`   |


### 工具配置项说明

你可以使用 Monkeys 提供的其他工具（一般以 `monkey-tools-` 开头）的 Helm 来安装，或者使用现成的[满足 Monkeys 标准](https://inf-monkeys.github.io/docs/zh-cn/tools/build-custom-tools/)的在线服务。

| 参数          | 描述                                                                 | 默认值                                                  |
| ------------- | -------------------------------------------------------------------- | ------------------------------------------------------- |
| `name`        | 工具唯一标志，如 `knowledge-base`                                    |                                                         |
| `manifestUrl` | 工具的 Manifest JSON 地址，需确保 Monkeys 服务环境能够访问到此连接。 | `http://monkey-tools-knowledge-base:5000/manifest.json` |

以下是一个示例：


```yaml
tools:
  - name: knowledge-base
    manifestUrl: http://monkey-tools-knowledge-base:5000/manifest.json
```

## 管理后台配置

自定义管理后台，比应用 ID、对外访问地址、标题、Logo、认证方式等。

| 参数                                      | 描述                                                                                               | 默认值                                                         |
| ----------------------------------------- | -------------------------------------------------------------------------------------------------- | -------------------------------------------------------------- |
| `admin.site.appId`                        | 此次部署服务的唯一 ID，将会作为数据库表、redis key 的前缀。必须要和 `server.site.appId` 保持一致。 | `monkeys`                                                      |
| `admin.site.customization.title`          | 网站标题。                                                                                         | `猴子无限`                                                     |
| `admin.site.customization.logo.light`     | 左上角 Logo 图标(Light 模型)。                                                                     | `https://static.infmonkeys.com/logo/InfMonkeys-logo-light.svg` |
| `admin.site.customization.logo.dark`      | 左上角 Logo 图标(Dark 模型)。                                                                      | `https://static.infmonkeys.com/logo/InfMonkeys-logo-dark.svg`  |
| `admin.site.customization.favicon`        | 浏览器 Favicon 图标                                                                                | `https://static.infmonkeys.com/logo/InfMonkeys-ICO.svg`        |
| `admin.site.customization.colors.primary` | 主颜色                                                                                             | `#52ad1f`                                                      |
| `admin.site.auth.enabled`                 | 是否开启认证                                                                                       | `true`                                                         |
| `admin.site.auth.defaultAdmin.email`      | 默认邮箱                                                                                           | `admin@example.com`                                            |
| `admin.site.auth.defaultAdmin.password`   | 默认密码。                                                                                         | `monkeys123`                                                   |


## Clash 代理

某些功能可能科学上网才能访问对应服务，比如 `github`、`huggingface` 模型等。

| 参数                    | 描述                                 | 默认值  |
| ----------------------- | ------------------------------------ | ------- |
| `clash.enabled`         | 是否启用 Clash 代理服务。            | `false` |
| `clash.subscriptionUrl` | Clash 订阅地址                       | `""`    |
| `clash.secret`          | Clash 订阅地址的密钥，没有可以不填。 | `""`    |


## 副本数

通过以下配置控制每个 Depolyment 的副本数：

| 参数                 | 描述             | 默认值 |
| -------------------- | ---------------- | ------ |
| `proxy.replicas`     | 副本数           | `1`    |
| `server.replicas`    | 副本数           | `1`    |
| `web.replicas`       | 前端副本数       | `1`    |
| `conductor.replicas` | Conductor 副本数 | `1`    |
| `clash.replicas`     | Clash 副本数     | `1`    |

## 中间件配置

### Postgres 数据库

#### 使用内置数据库

| 参数                                | 描述                                                                                                                              | 默认值       |
| ----------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| `postgresql.enabled`                | 是否启用内置数据库。如果设置为 true，将会创建一个新的 postgresql 实例（不保证高可用），如果你有其他现成的数据库，请设置为 false。 | `true`       |
| `postgresql.auth.postgresPassword`  | Postgres 用户密码                                                                                                                 | `monkeys123` |
| `postgresql.auth.username`          | 创建的用户名                                                                                                                      | `monkeys`    |
| `postgresql.auth.password`          | 创建用户的密码                                                                                                                    | `monkeys123` |
| `postgresql.auth.database`          | Monkeys Server 的 database                                                                                                        | `monkeys`    |
| `postgresql.auth.conductorDatabase` | Conductor 的 database                                                                                                             | `conductor`  |
| `postgresql.primary.initdb.scripts` | 初始化脚本，用于创建对应的数据库。                                                                                                | 见下文。     |

数据库初始化脚本：

```yaml
scripts:
  setup.sql: |
    CREATE DATABASE monkeys;
    CREATE DATABASE conductor;
```

#### 使用外置数据库

> monkeys-server 和 conductor 均需要使用 PG 数据库，建议分配不同的 database。

##### Monkeys 业务数据库

| 参数                          | 描述                 | 默认值  |
| ----------------------------- | -------------------- | ------- |
| `externalPostgresql.enabled`  | 是否使用外置的数据库 | `false` |
| `externalPostgresql.host`     | 域名或者 ip          | `""`    |
| `externalPostgresql.port`     | 端口                 | `5432`  |
| `externalPostgresql.username` | 用户名               | `""`    |
| `externalPostgresql.password` | 密码                 | `""`    |
| `externalPostgresql.database` | database             | `""`    |

##### Conductor 数据库

| 参数                                   | 描述                 | 默认值  |
| -------------------------------------- | -------------------- | ------- |
| `externalConductorPostgresql.enabled`  | 是否使用外置的数据库 | `false` |
| `externalConductorPostgresql.host`     | 域名或者 ip          | `""`    |
| `externalConductorPostgresql.port`     | 端口                 | `5432`  |
| `externalConductorPostgresql.username` | 用户名               | `""`    |
| `externalConductorPostgresql.password` | 密码                 | `""`    |
| `externalConductorPostgresql.database` | database             | `""`    |


### Elasticsearch 7 

我们会用 ES7 存储 Conductor 工作流的执行数据。

#### 使用内置 Elasticsearch 7


| 参数                               | 描述                                                                                                                                                       | 默认值                                          |
| ---------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| `elasticsearch.enabled`            | 是否启用内置的 Elasticsearch。如果设置为 true，将会创建一个新的 elasticsearch 7 实例（不保证高可用），如果你有其他现成的 elasticsearch 7，请设置为 false。 | `true`                                          |
| `elasticsearch.replicas`           | 副本数                                                                                                                                                     | `1`                                             |
| `elasticsearch.repository`         | 镜像地址                                                                                                                                                   | `docker.elastic.co/elasticsearch/elasticsearch` |
| `elasticsearch.imageTag`           | 版本号，大版本号必须为 7                                                                                                                                   | `7.17.3`                                        |
| `elasticsearch.minimumMasterNodes` | 最小 master 节点数                                                                                                                                         | `1`                                             |
| `elasticsearch.esMajorVersion`     | ES 大版本号，必须为 7。                                                                                                                                    | `7`                                             |
| `elasticsearch.secret.password`    | 密码                                                                                                                                                       | `monkeys123`                                    |
| `elasticsearch.indexReplicasCount` | 索引副本数                                                                                                                                                 | `0`                                             |
| `elasticsearch.clusterHealthColor` | 集群健康颜色指标                                                                                                                                           | `yellow`                                        |


#### 使用外置 Elasticsearch 7


| 参数                                       | 描述                                    | 默认值   |
| ------------------------------------------ | --------------------------------------- | -------- |
| `externalElasticsearch.enabled`            | 是否启用外置的 ES，要求大版本必须为 7。 | `true`   |
| `externalElasticsearch.indexReplicasCount` | 工作流数据副本数                        | `0`      |
| `externalElasticsearch.clusterHealthColor` | 集群健康颜色指标                        | `yellow` |
| `externalElasticsearch.url`                | 连接地址                                | `""`     |
| `externalElasticsearch.username`           | 用户名                                  | `""`     |
| `externalElasticsearch.password`           | 密码                                    | `""`     |


### Redis

#### 使用内置 Redis


| 参数                    | 描述                                                                                                                           | 默认值       |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ------------ |
| `redis.enabled`         | 是否启用内置的 Redis。如果设置为 true，将会创建一个新的 Redis 实例（不保证高可用），如果你有其他现成的 Redis，请设置为 false。 | `true`       |
| `redis.architecture`    | 部署架构，目前只支持 `standalone` 单机模式。                                                                                   | `standalone` |
| `redis.global.password` | 密码                                                                                                                           | `monkeys123` |


#### 使用外置 Redis

##### 单机 Redis

| 参数                    | 描述                                                                                                 | 默认值                     |
| ----------------------- | ---------------------------------------------------------------------------------------------------- | -------------------------- |
| `externalRedis.enabled` | 是否使用外置的 redis                                                                                 | `false`                    |
| `externalRedis.mode`    | Redis 部署架构                                                                                       | `standalone`               |
| `externalRedis.url`     | Redis 连接地址，如 `redis://@localhost:6379/0`，包含密码的示例: `redis://:password@localhost:6379/0` | `redis://localhost:6379/0` |

##### Redis 集群

| 参数                             | 描述                 | 默认值    |
| -------------------------------- | -------------------- | --------- |
| `externalRedis.enabled`          | 是否使用外置的 redis | `false`   |
| `externalRedis.mode`             | Redis 部署架构       | `cluster` |
| `externalRedis.nodes`            | Redis 集群节点列表   | `""`      |
| `externalRedis.options.password` | 密码                 | `""`      |

Redis 集群节点列表示例：

```yaml
nodes:
  - host: 127.0.0.1
    port: 7001
  - host: 127.0.0.1
    port: 7002
  - host: 127.0.0.1
    port: 7003
  - host: 127.0.0.1
    port: 7004
  - host: 127.0.0.1
    port: 7005
  - host: 127.0.0.1
    port: 7006
```

###### Redis sentinel

| 参数                             | 描述                 | 默认值     |
| -------------------------------- | -------------------- | ---------- |
| `externalRedis.enabled`          | 是否使用外置的 redis | `false`    |
| `externalRedis.mode`             | Redis 部署架构       | `sentinel` |
| `externalRedis.sentinels`        | Redis 哨兵节点列表   | `""`       |
| `externalRedis.sentinelName`     | Redis sentinel Name  | `""`       |
| `externalRedis.options.password` | 密码                 | `""`       |

Redis 哨兵节点列表示例：

```yaml
sentinels:
  - host: 127.0.0.1
    port: 7101
```

### MinIO(S3) 存储

#### 使用内置 Minio 存储

> 此模式会使用 root 用户和密码作为 accessKey，只推荐在快速测试时使用。

| 参数                              | 描述                                                                                                                                                          | 默认值                   |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `minio.enabled`                   | 是否启用内置的 Minio。如果设置为 true，将会创建一个新的 Minio 实例（不保证高可用），如果你有其他现成的 Minio 或者任意满足 S3 协议的对象存储，请设置为 false。 | `true`                   |
| `minio.isPrivate`                 | 是否为私有仓库                                                                                                                                                | `false`                  |
| `minio.mode`                      | 部署架构，目前只支持 `standalone` 单机模式。                                                                                                                  | `standalone`             |
| `minio.defaultBuckets`            | 默认创建的 Bucket Name，可以用逗号分隔。                                                                                                                      | `monkeys-static`         |
| `minio.auth.rootUser`             | Root 用户名                                                                                                                                                   | `minio`                  |
| `minio.auth.rootPassword`         | Root 用户密码                                                                                                                                                 | `monkeys123`             |
| `minio.service.type`              | Minio Service 模式，次 Minio 需要能够被外部（浏览器）访问，默认使用 `Nodeport` 模式。                                                                         | `NodePort`               |
| `minio.service.nodePorts.api`     | Minio API 端口挂载到宿主机的端口                                                                                                                              | `31900`                  |
| `minio.service.nodePorts.console` | Minio Console 端口使用宿主机的端口                                                                                                                            | `31901`                  |
| `minio.endpoint`                  | Minio API 端口对外可被访问到的地址。你可能需要改成宿主机服务器的 IP + API Node Port 端口                                                                      | `http://127.0.0.1:31900` |

启动之后，访问宿主机 IP + 端口（31901） 应该能够访问到 minio 的管理后台，账号密码为上述设置的密码。

> 注：如果你使用的是 minikube 搭建的集群，还需要手动 port forward minio service 的端口，如下所示：
>
> ```bash
> kubectl port-forward svc/monkeys-minio 31900:9000 -n monkeys
> kubectl port-forward svc/monkeys-minio 31901:9001 -n monkeys
> ```
> 并且注意需要开放宿主机的端口，外网才能访问。
> 详情请见 [https://stackoverflow.com/a/55110218](https://stackoverflow.com/a/55110218)。

#### 使用外部 S3 存储

| 参数                         | 描述                                                                                                                                                                                                                                                                                                                                                                              | 默认值  |
| ---------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `externalS3.enabled`         | 使用使用外部的满足你 S3 协议的对象存储，如 Minio、AWS S3 等。                                                                                                                                                                                                                                                                                                                     | `false` |
| `externalS3.proxy`           | 是否使用 Server 作为中转代理进行上传。在某些情况下，你的 S3 服务（比如 MinIO）无法对外直接访问，这个时候你可以设置为 `true`，通过 `server` 服务进行中转代理。                                                                                                                                                                                                                     | `true`  |
| `externalS3.isPrivate`       | 是否为私有仓库                                                                                                                                                                                                                                                                                                                                                                    | `false` |
| `externalS3.forcePathStyle`  | 是否使用 path-style endpoint, 当你使用 minio 时，一般都需要设置为 `true`                                                                                                                                                                                                                                                                                                          | `false` |
| `externalS3.accessKeyId`     | AccessKeyID                                                                                                                                                                                                                                                                                                                                                                       | `""`    |
| `externalS3.secretAccessKey` | Secret Access Key                                                                                                                                                                                                                                                                                                                                                                 | `""`    |
| `externalS3.region`          | 区域                                                                                                                                                                                                                                                                                                                                                                              | `""`    |
| `externalS3.bucket`          | Bucket 名称，请使用公开的 bucket，以便前端能够访问到。                                                                                                                                                                                                                                                                                                                            | `""`    |
| `externalS3.endpoint`        | S3 服务的 endpoint 地址。如果 `proxy` 为 `true`，则会在 `server` 服务内访问 s3，填此 s3 的内网地址；如果 `proxy` 为 `false`，将会从浏览器访问此地址，此地址必须对外网能够访问。示例：如果你使用的 `minio`，则需要填写的是 `minio` 的 `api` 端口，而非 `console` 端口；如果你使用的是云厂商提供的 s3 服务，填写对应的 `endpoint` 地址，如 `https://tos-s3-cn-beijing.volces.com`。 | `""`    |
| `externalS3.publicAccessUrl` | 注意：`publicAccessUrl` 和 `endpoint` 为两个不同的地址，此地址会作为上传得到的 URL 的前缀，必须对浏览器可访问，否则浏览器将无法正常显示上传的文件。如果你使用的是如 `aws`, `阿里云`, `火山云` 等云厂商提供的 s3 服务，并且给 bucket 配置了 CDN 加速地址，可以将此地址配置为 CDN 的地址，如 `https://static.infmonkeys.com`                                                        | `""`    |

## 服务监控

Monkeys 服务暴露的 Prometheus 详细指标以及配置过程请见 [https://inf-monkeys.github.io/docs/zh-cn/cluster/monitoring/prometheus-grafana/](https://inf-monkeys.github.io/docs/zh-cn/cluster/monitoring/prometheus-grafana/)。

### 安装 Prometheus Operator

如果你还没有安装 Prometheus Operator，可以通过下面的命令安装，这里设置的 namespace 为 `monitoring`:

```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring
```

检查安装状态:

```sh
kubectl get all -n monitoring
```

### 配置项

| 参数              | 描述                   | 默认值 |
| ----------------- | ---------------------- | ------ |
| `serviceMonitors` | 开启的 servicemonitors | `[]]`  |

由于不确定部署的环境是否安装了 Prometheus Operator，所以 `serviceMonitors` 默认为空数组。在你安装了 Prometheus Operator 之后，可以修改 `serviceMonitors` 配置如下：

- `namespace`: 修改为你的 Prometheus Operator 所在的 namespace。

```yaml
serviceMonitors:
  - name: monkeys-core-server
    namespace: monitoring
    selector:
      matchLabels:
        monkeys/app: server
    endpoints:
      - port: http-server
        interval: 5s
        path: /metrics
  - name: monkeys-core-conductor
    namespace: monitoring
    selector:
      matchLabels:
        monkeys/app: conductor
    endpoints:
      - port: http-conductor
        interval: 1s
        path: /actuator/prometheus
```

如果你在**当前 namespace** 下部署了 vllm 服务，可以类似添加新的 `serviceMonitor`，但是 Monkeys 的 helm charts 默认不提供。

## 其他

### Daocloud DCE 菜单配置

| 参数                                   | 描述                                                    | 默认值                                           |
| -------------------------------------- | ------------------------------------------------------- | ------------------------------------------------ |
| `GProductNavigator.enabled`            | 是否启用 Daocloud DCE 菜单                              | `false`                                          |
| `GProductNavigator.spec.name`          | 显示名称                                                | `流程编排`                                       |
| `GProductNavigator.spec.iconUrl`       | Logo                                                    | `https://static.infmonkeys.com/favicon-gray.svg` |
| `GProductNavigator.spec.localizedName` | 多语言名称配置                                          | `""`                                             |
| `GProductNavigator.spec.url`           | 点击菜单之后的跳转地址，请修改为 Monkeys 的方访问地址。 | `"https://ai.daocloud.cn/login"`                 |
| `GProductNavigator.spec.category`      | 类型                                                    | `modelapplication`                               |
| `GProductNavigator.spec.visible`       | 是否显示。                                              | `true`                                           |
| `GProductNavigator.spec.order`         | 排序，数字越大，越靠上。                                | `0`                                              |
| `GProductNavigator.spec.gproduct`      | gproduct 名称.                                          | `monkeys`                                        |
