<div align="center">

# Core Helm Chart<!-- omit in toc -->

</div>

[中文](./README_zh.md) | English


# Table of Contents<!-- omit in toc -->

- [Install](#install)
  - [Check status](#check-status)
  - [Visit the service](#visit-the-service)
  - [Update configuration](#update-configuration)
  - [Uninstall](#uninstall)
- [Images](#images)
- [Service Configuration](#service-configuration)
  - [ClusterIP Mode Example](#clusterip-mode-example)
  - [NodePort Mode Example](#nodeport-mode-example)
- [Site Configuration](#site-configuration)
- [Authentication](#authentication)
  - [OIDC Single Sign-On](#oidc-single-sign-on)
  - [Phone Number Verification Code Login](#phone-number-verification-code-login)
- [Built-IN LLM Models](#built-in-llm-models)
- [OneAPI Service Configuration](#oneapi-service-configuration)
  - [Using the Built-in OneAPI Service](#using-the-built-in-oneapi-service)
  - [Using an External OneAPI Service](#using-an-external-oneapi-service)
- [Pre-built Tools](#pre-built-tools)
  - [Tool Configuration Details](#tool-configuration-details)
- [Admin Dashboard Configuration](#admin-dashboard-configuration)
- [Clash Proxy](#clash-proxy)
- [Replicas](#replicas)
- [Middleware Configuration](#middleware-configuration)
  - [Postgres Database](#postgres-database)
    - [Using Built-in Database](#using-built-in-database)
    - [Using External Database](#using-external-database)
      - [Monkeys Business Database](#monkeys-business-database)
      - [Conductor Database](#conductor-database)
  - [Elasticsearch 7](#elasticsearch-7)
    - [Using Built-in Elasticsearch 7](#using-built-in-elasticsearch-7)
    - [Using External Elasticsearch 7](#using-external-elasticsearch-7)
  - [Redis](#redis)
    - [Using Built-in Redis](#using-built-in-redis)
    - [Using External Redis](#using-external-redis)
      - [Standalone Redis](#standalone-redis)
      - [Redis Cluster](#redis-cluster)
        - [Redis Sentinel](#redis-sentinel)
  - [MinIO(S3) Storage](#minios3-storage)
    - [Using Built-in Minio Storage](#using-built-in-minio-storage)
    - [Using External S3 Storage](#using-external-s3-storage)
- [Service Monitoring](#service-monitoring)
  - [Installing Prometheus Operator](#installing-prometheus-operator)
  - [Configuration](#configuration)


## Install

```sh
# Add the helm repo
helm repo add monkeys https://inf-monkeys.github.io/helm-charts

# Install monkeys core service
helm install monkeys monkeys/core -n monkeys --create-namespace
```

### Check status

> By default monkeys use internal middleware (postgres, elasticsearch, redis, etc), It may take some time to wait for middlewares startup.

Check installation progress by:

```sh
kubectl get pods -n monkeys
kubectl get svc -n monkeys
```

### Visit the service


By default `values.yaml` uses ClusterIP mode, you can visit monkeys web ui through **monkeys-proxy** service:

```sh
# Get current pod list
kubectl get pods 

# Port Forward monkey-core-proxy-xxxx-xxxx Pod, in this example use local machine's 8080 port.
kubectl port-forward --address 0.0.0.0 monkeys-core-proxy-xxxx-xxxx 8080:80 -n monkeys

# Try
curl http://localhost:8080
```

And if your service is behide a firewall, no forget to open that port.

### Update configuration

Create a new values file, `prod-core-values.yaml` for example.

For example if you want to modify server image version, add this to `prod-core-values.yaml`:

```yaml
images:
  server:
    tag: some-new-tag
```

Then run:

```sh
helm upgrade monkeys --values ./prod-core-values.yaml --namespace monkeys
```

For the complete list of configuration options, see: [Core Helm Chart](./charts/core/README.md)

### Uninstall

```sh
helm uninstall monkeys -n monkeys
```


## Images

| Parameter                      | Description                                                             | Default Value              |
| ------------------------------ | ----------------------------------------------------------------------- | -------------------------- |
| `images.server.registry`       | Docker Registry                                                         | `docker.io`                |
| `images.server.repository`     | [monkeys](https://github.com/inf-monkeys/monkeys) service Docker image  | `infmonkeys/monkeys`       |
| `images.server.tag`            | Version                                                                 | `latest`                   |
| `images.server.pullPolicy`     | Image pull policy                                                       | `IfNotPresent`             |
| `images.server.pullSecrets`    | Image pull secrets                                                      | `""`                       |
| `images.web.registry`          | Docker Registry                                                         | `docker.io`                |
| `images.web.repository`        | [Frontend](https://github.com/inf-monkeys/monkeys/tree/main/ui) image   | `infmonkeys/monkeys-ui`    |
| `images.web.tag`               | Version                                                                 | `latest`                   |
| `images.web.pullPolicy`        | Image pull policy                                                       | `IfNotPresent`             |
| `images.web.pullSecrets`       | Image pull secrets                                                      | `""`                       |
| `images.conductor.registry`    | Docker Registry                                                         | `docker.io`                |
| `images.conductor.repository`  | [conductor](https://github.com/inf-monkeys/conductor) engine image      | `infmonkeys/conductor-oss` |
| `images.conductor.tag`         | Version                                                                 | `latest`                   |
| `images.conductor.pullPolicy`  | Image pull policy                                                       | `IfNotPresent`             |
| `images.conductor.pullSecrets` | Image pull secrets                                                      | `""`                       |
| `images.oneapi.registry`       | Image Registry                                                          | `docker.io`                |
| `images.oneapi.repository`     | Image repository for [one-api](https://github.com/songquanpeng/one-api) | `justsong/one-api`         |
| `images.oneapi.tag`            | Version                                                                 | `latest`                   |
| `images.oneapi.pullPolicy`     | Image pull policy                                                       | `IfNotPresent`             |
| `images.oneapi.pullSecrets`    | Image pull secrets                                                      | `""`                       |
| `images.admin.registry`        | Docker Registry                                                         | `docker.io`                |
| `images.admin.repository`      | Admin dashboard image                                                   | `infmonkeys/monkeys-admin` |
| `images.admin.tag`             | Version                                                                 | `latest`                   |
| `images.admin.pullPolicy`      | Image pull policy                                                       | `IfNotPresent`             |
| `images.admin.pullSecrets`     | Image pull secrets                                                      | `""`                       |
| `images.clash.registry`        | Docker Registry                                                         | `docker.io`                |
| `images.clash.repository`      | Clash proxy service image                                               | `infmonkeys/clash`         |
| `images.clash.tag`             | Version                                                                 | `latest`                   |
| `images.clash.pullPolicy`      | Image pull policy                                                       | `IfNotPresent`             |
| `images.clash.pullSecrets`     | Image pull secrets                                                      | `""`                       |
| `images.busybox.registry`      | Docker Registry                                                         | `docker.io`                |
| `images.busybox.repository`    | BusyBox image                                                           | `busybox`                  |
| `images.busybox.tag`           | Version                                                                 | `latest`                   |
| `images.busybox.pullPolicy`    | Image pull policy                                                       | `IfNotPresent`             |
| `images.busybox.pullSecrets`   | Image pull secrets                                                      | `""`                       |
| `images.nginx.registry`        | Docker Registry                                                         | `docker.io`                |
| `images.nginx.repository`      | Nginx image                                                             | `nginx`                    |
| `images.nginx.tag`             | Version                                                                 | `latest`                   |
| `images.nginx.pullPolicy`      | Image pull policy                                                       | `IfNotPresent`             |
| `images.nginx.pullSecrets`     | Image pull secrets                                                      | `""`                       |


## Service Configuration

By default, the service uses ClusterIP mode and exposes services on port `80` of the `monkeys-core-proxy` (Nginx reverse proxy) `svc`.

| Parameter           | Description                  | Default Value |
| ------------------- | ---------------------------- | ------------- |
| `service.type`      | `ClusterIP` or `NodePort`    | `ClusterIP`   |
| `service.port`      | Proxy component (Nginx) port | `80`          |
| `service.clusterIP` | ClusterIP                    | `""`          |
| `service.nodePort`  | Node Port                    | `""`          |

### ClusterIP Mode Example

```yaml
service:
  type: ClusterIP
  port: 80
  clusterIP: ""
```

### NodePort Mode Example

```yaml
service:
  type: NodePort
  port: 80
  nodePort: 30080
```
## Site Configuration

Customize your site with Application ID, external URL, title, logo, authentication methods, etc.

| Parameter                                  | Description                                                                                 | Default Value                                                  |
| ------------------------------------------ | ------------------------------------------------------------------------------------------- | -------------------------------------------------------------- |
| `server.site.appId`                        | Unique ID for the deployment, used as prefix for database tables and redis keys.            | `monkeys`                                                      |
| `server.site.appUrl`                       | External URL, affects OIDC SSO and custom triggers, other functionalities are not affected. | `http://localhost:3000`                                        |
| `server.site.customization.title`          | Website title                                                                               | `Infinite Monkeys`                                             |
| `server.site.customization.logo.light`     | Top-left logo (Light mode)                                                                  | `https://static.infmonkeys.com/logo/InfMonkeys-logo-light.svg` |
| `server.site.customization.logo.dark`      | Top-left logo (Dark mode)                                                                   | `https://static.infmonkeys.com/logo/InfMonkeys-logo-dark.svg`  |
| `server.site.customization.favicon`        | Browser Favicon                                                                             | `https://static.infmonkeys.com/logo/InfMonkeys-ICO.svg`        |
| `server.site.customization.colors.primary` | Primary color                                                                               | `#52ad1f`                                                      |

## Authentication

Currently, the following three user authentication methods are supported:

- `password`: Email password authentication;
- `phone`: Phone number verification code authentication;
- `oidc`: OIDC Single Sign-On;

| Parameter             | Description                                                                                             | Default Value |
| --------------------- | ------------------------------------------------------------------------------------------------------- | ------------- |
| `server.auth.enabled` | Enabled authentication methods, default is password login only. Options are `password`, `oidc`, `phone` | `password`    |

### OIDC Single Sign-On

| Parameter                                       | Description                                                                                                                                                                    | Default Value    |
| ----------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------- |
| `server.auth.oidc.auto_signin`                  | Whether to automatically use OIDC for login when the user signs in. If set to `false`, users need to manually click the OIDC login button to proceed with OIDC authentication. | `false`          |
| `server.auth.oidc.issuer`                       | OIDC Issuer address, e.g., `https://console.d.run/auth/realms/ghippo`                                                                                                          | `""`             |
| `server.auth.oidc.client_id`                    | OIDC Client ID                                                                                                                                                                 | `""`             |
| `server.auth.oidc.client_secret`                | OIDC Client Secret                                                                                                                                                             | `""`             |
| `server.auth.oidc.scope`                        | Scope set during OIDC authorization. For Daocloud DEC, set to `openid profile email phone`                                                                                     | `openid profile` |
| `server.auth.oidc.button_text`                  | Text for the OIDC login button                                                                                                                                                 | `Use OIDC Login` |
| `server.auth.oidc.id_token_signed_response_alg` | OIDC ID Token encryption method                                                                                                                                                | `RS256`          |

### Phone Number Verification Code Login

| Parameter                                | Description                                                                                      | Default Value |
| ---------------------------------------- | ------------------------------------------------------------------------------------------------ | ------------- |
| `server.auth.sms.provider`               | SMS verification code service provider, currently only supports Aliyun SMS. Options are `dysms`. | `dysms`       |
| `server.auth.sms.config.accessKeyId`     | Aliyun accessKeyId                                                                               | `""`          |
| `server.auth.sms.config.accessKeySecret` | Aliyun accessKeySecret                                                                           | `""`          |
| `server.auth.sms.config.signName`        | SMS signature name                                                                               | `""`          |
| `server.auth.sms.config.templateCode`    | SMS template code                                                                                | `""`          |

## Built-IN LLM Models

You can configure the built-in large language model, which can be used by all teams within the system.​

| Parameter   | Description                                                                                                            | Default Value |
| ----------- | ---------------------------------------------------------------------------------------------------------------------- | ------------- |
| `llmModels` | Enabled language models, see [Language Model Configuration Details](#language-model-configuration-details) for details | `[]`          |


You can add any OpenAI-compatible LLMmodels with the following configuration:

| Parameter                      | Description                                                                                                                                                                                                                                                                                                                                                                                           | Default Value |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| `model`                        | Model name, e.g., `gpt-3.5-turbo`                                                                                                                                                                                                                                                                                                                                                                     |               |
| `baseURL`                      | Access URL, e.g., `https://api.openai.com/v1`                                                                                                                                                                                                                                                                                                                                                         |               |
| `apiKey`                       | API Key, optional                                                                                                                                                                                                                                                                                                                                                                                     |               |
| `type`                         | Model type, `chat_completions` or `completions`, for chat or text completion models. Leave empty to support both.                                                                                                                                                                                                                                                                                     | `""`          |
| `autoMergeConsecutiveMessages` | Should messages with the same role be automatically merged? When using a model deployed through VLLM, multiple consecutive messages with the same `role` cannot be transmitted. If there are multiple consecutive messages with the same role, they need to be automatically merged into a single message. If set to `true`, the messages will be automatically merged into one, separated by `\n\n`. | `false`       |
| `defaultParams`                | Default request parameters, e.g., `top` parameters for specific models like `Qwen/Qwen-7B-Chat-Int4`.                                                                                                                                                                                                                                                                                                 |               |

Here are an example: 

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


## OneAPI Service Configuration

If you need users to configure their own large language models, you need to deploy [one-api](https://github.com/songquanpeng/one-api) (this Helm Chart will automatically start the one-api service by default).

### Using the Built-in OneAPI Service

The default username and password for [one-api](https://github.com/songquanpeng/one-api) are `root` and `123456` (**cannot be customized, please do not modify.**). Monkeys will use this account and password to create a Token, thereby [making API calls](https://github.com/songquanpeng/one-api/blob/main/docs/API.md).

| Parameter             | Description                                     | Default Value |
| --------------------- | ----------------------------------------------- | ------------- |
| `oneapi.enabled`      | Whether to start the built-in `OneAPI` service. | `true`        |
| `oneapi.rootUsername` | Default root username                           | `root`        |
| `oneapi.rootPassword` | Default root password                           | `123456`      |

### Using an External OneAPI Service

You can also use an external OneAPI service:

| Parameter                  | Description                                                                                                                            | Default Value |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| `externalOneapi.enabled`   | Whether to start the built-in `OneAPI` service.                                                                                        | `false`       |
| `externalOneapi.baseURL`   | Service address, such as `http://127.0.0.1:3000`, do not include a trailing `\`.                                                       | `""`          |
| `externalOneapi.rootToken` | Root user's token, see [this document](https://github.com/songquanpeng/one-api/blob/main/docs/API.md) for details on how to obtain it. | `123456`      |

## Pre-built Tools

| Parameter | Description                                                                                     | Default Value |
| --------- | ----------------------------------------------------------------------------------------------- | ------------- |
| `tools`   | Enabled pre-built tools. (Different tools should be installed via their respective Helm Charts) | `[]`          |

### Tool Configuration Details

You can use other tools provided by Monkeys (usually prefixed with `monkey-tools-`) via Helm, or use existing online services that meet the [Monkeys standard](https://inf-monkeys.github.io/docs/zh-cn/tools/build-custom-tools/).

| Parameter     | Description                                                                                       | Default Value                                           |
| ------------- | ------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `name`        | Unique identifier for the tool, e.g., `knowledge-base`                                            |                                                         |
| `manifestUrl` | URL of the tool's Manifest JSON, ensure that the Monkeys service environment can access this URL. | `http://monkey-tools-knowledge-base:5000/manifest.json` |


Here are an example: 


```yaml
tools:
  - name: knowledge-base
    manifestUrl: http://monkey-tools-knowledge-base:5000/manifest.json
```


## Admin Dashboard Configuration

Customize the admin dashboard with Application ID, external URL, title, logo, authentication methods, etc.

| Parameter                                 | Description                                                                                                      | Default Value                                                  |
| ----------------------------------------- | ---------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------- |
| `admin.site.appId`                        | Unique ID for the deployment, used as prefix for database tables and redis keys. Must match `server.site.appId`. | `monkeys`                                                      |
| `admin.site.customization.title`          | Website title                                                                                                    | `Infinite Monkeys`                                             |
| `admin.site.customization.logo.light`     | Top-left logo (Light mode)                                                                                       | `https://static.infmonkeys.com/logo/InfMonkeys-logo-light.svg` |
| `admin.site.customization.logo.dark`      | Top-left logo (Dark mode)                                                                                        | `https://static.infmonkeys.com/logo/InfMonkeys-logo-dark.svg`  |
| `admin.site.customization.favicon`        | Browser Favicon                                                                                                  | `https://static.infmonkeys.com/logo/InfMonkeys-ICO.svg`        |
| `admin.site.customization.colors.primary` | Primary color                                                                                                    | `#52ad1f`                                                      |
| `admin.site.auth.enabled`                 | Enable authentication                                                                                            | `true`                                                         |
| `admin.site.auth.defaultAdmin.email`      | Default email                                                                                                    | `admin@example.com`                                            |
| `admin.site.auth.defaultAdmin.password`   | Default password                                                                                                 | `monkeys123`                                                   |

## Clash Proxy

Some functionalities might require internet access to reach specific services like `github` and `huggingface` models.

| Parameter               | Description                                      | Default Value |
| ----------------------- | ------------------------------------------------ | ------------- |
| `clash.enabled`         | Enable Clash proxy service.                      | `false`       |
| `clash.subscriptionUrl` | Clash subscription URL                           | `""`          |
| `clash.secret`          | Secret for the Clash subscription URL, optional. | `""`          |

## Replicas

Control the number of replicas for each deployment with the following configuration:

| Parameter            | Description        | Default Value |
| -------------------- | ------------------ | ------------- |
| `proxy.replicas`     | Number of replicas | `1`           |
| `server.replicas`    | Number of replicas | `1`           |
| `web.replicas`       | Frontend replicas  | `1`           |
| `conductor.replicas` | Conductor replicas | `1`           |
| `clash.replicas`     | Clash replicas     | `1`           |

## Middleware Configuration

### Postgres Database

#### Using Built-in Database

| Parameter                           | Description                                                                                                                                                 | Default Value |
| ----------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| `postgresql.enabled`                | Enable built-in database. If set to true, a new PostgreSQL instance will be created (not highly available). If you have an existing database, set to false. | `true`        |
| `postgresql.auth.postgresPassword`  | Postgres user password                                                                                                                                      | `monkeys123`  |
| `postgresql.auth.username`          | Username to be created                                                                                                                                      | `monkeys`     |
| `postgresql.auth.password`          | Password for the created user                                                                                                                               | `monkeys123`  |
| `postgresql.auth.monkeysDatabase`   | Monkeys Server Database                                                                                                                                     | `monkeys`     |
| `postgresql.auth.conductorDatabase` | Conductor Server Database                                                                                                                                   | `conductor`   |
| `postgresql.primary.initdb.scripts` | Init db scripts                                                                                                                                             | See below     |

Database init scripts:

```yaml
scripts:
  setup.sql: |
    CREATE DATABASE monkeys;
    CREATE DATABASE conductor;
```


#### Using External Database

> Both monkeys-server and conductor require a PG database, it's recommended to allocate different databases for each.

##### Monkeys Business Database

| Parameter                     | Description           | Default Value |
| ----------------------------- | --------------------- | ------------- |
| `externalPostgresql.enabled`  | Use external database | `false`       |
| `externalPostgresql.host`     | Host or IP address    | `""`          |
| `externalPostgresql.port`     | Port                  | `5432`        |
| `externalPostgresql.username` | Username              | `""`          |
| `externalPostgresql.password` | Password              | `""`          |
| `externalPostgresql.database` | Database              | `""`          |

##### Conductor Database

| Parameter                              | Description           | Default Value |
| -------------------------------------- | --------------------- | ------------- |
| `externalConductorPostgresql.enabled`  | Use external database | `false`       |
| `externalConductorPostgresql.host`     | Host or IP address    | `""`          |
| `externalConductorPostgresql.port`     | Port                  | `5432`        |
| `externalConductorPostgresql.username` | Username              | `""`          |
| `externalConductorPostgresql.password` | Password              | `""`          |
| `externalConductorPostgresql.database` | Database              | `""`          |

### Elasticsearch 7 

We use ES7 to store Conductor workflow execution data.

#### Using Built-in Elasticsearch 7

| Parameter                          | Description                                                                                                                                                                  | Default Value                                   |
| ---------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| `elasticsearch.enabled`            | Enable built-in Elasticsearch. If set to true, a new Elasticsearch 7 instance will be created (not highly available). If you have an existing Elasticsearch 7, set to false. | `true`                                          |
| `elasticsearch.replicas`           | Number of replicas                                                                                                                                                           | `1`                                             |
| `elasticsearch.repository`         | Image address                                                                                                                                                                | `docker.elastic.co/elasticsearch/elasticsearch` |
| `elasticsearch.imageTag`           | Version, must be version 7                                                                                                                                                   | `7.17.3`                                        |
| `elasticsearch.minimumMasterNodes` | Minimum number of master nodes                                                                                                                                               | `1`                                             |
| `elasticsearch.esMajorVersion`     | Major version of Elasticsearch, must be 7                                                                                                                                    | `7`                                             |
| `elasticsearch.secret.password`    | Password                                                                                                                                                                     | `monkeys123`                                    |
| `elasticsearch.indexReplicasCount` | Number of index replicas                                                                                                                                                     | `0`                                             |
| `elasticsearch.clusterHealthColor` | Cluster health color indicator                                                                                                                                               | `yellow`                                        |

#### Using External Elasticsearch 7

| Parameter                                  | Description                                      | Default Value |
| ------------------------------------------ | ------------------------------------------------ | ------------- |
| `externalElasticsearch.enabled`            | Enable external Elasticsearch, must be version 7 | `true`        |
| `externalElasticsearch.indexReplicasCount` | Number of workflow data replicas                 | `0`           |
| `externalElasticsearch.clusterHealthColor` | Cluster health color indicator                   | `yellow`      |
| `externalElasticsearch.url`                | Connection URL                                   | `""`          |
| `externalElasticsearch.username`           | Username                                         | `""`          |
| `externalElasticsearch.password`           | Password                                         | `""`          |


### Redis

#### Using Built-in Redis

| Parameter               | Description                                                                                                                                      | Default Value |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ | ------------- |
| `redis.enabled`         | Enable built-in Redis. If set to true, a new Redis instance will be created (not highly available). If you have an existing Redis, set to false. | `true`        |
| `redis.architecture`    | Deployment architecture, currently only supports `standalone` mode.                                                                              | `standalone`  |
| `redis.global.password` | Password                                                                                                                                         | `monkeys123`  |

#### Using External Redis

##### Standalone Redis

| Parameter               | Description                                                                                                          | Default Value              |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `externalRedis.enabled` | Use external Redis                                                                                                   | `false`                    |
| `externalRedis.mode`    | Redis deployment architecture                                                                                        | `standalone`               |
| `externalRedis.url`     | Redis connection URL, e.g., `redis://@localhost:6379/0`. Example with password: `redis://:password@localhost:6379/0` | `redis://localhost:6379/0` |

##### Redis Cluster

| Parameter                        | Description                   | Default Value |
| -------------------------------- | ----------------------------- | ------------- |
| `externalRedis.enabled`          | Use external Redis            | `false`       |
| `externalRedis.mode`             | Redis deployment architecture | `cluster`     |
| `externalRedis.nodes`            | Redis cluster nodes list      | `""`          |
| `externalRedis.options.password` | Password                      | `""`          |

Example of Redis cluster nodes list:

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

###### Redis Sentinel

| Parameter                        | Description                   | Default Value |
| -------------------------------- | ----------------------------- | ------------- |
| `externalRedis.enabled`          | Use external Redis            | `false`       |
| `externalRedis.mode`             | Redis deployment architecture | `sentinel`    |
| `externalRedis.sentinels`        | Redis sentinel nodes list     | `""`          |
| `externalRedis.sentinelName`     | Redis sentinel name           | `""`          |
| `externalRedis.options.password` | Password                      | `""`          |

Example of Redis sentinel nodes list:

```yaml
sentinels:
  - host: 127.0.0.1
    port: 7101
```


### MinIO(S3) Storage

#### Using Built-in Minio Storage

> This mode uses the root user and password as accessKey. Recommended for quick testing only.

| Parameter                         | Description                                                                                                                                                                   | Default Value            |
| --------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `minio.enabled`                   | Enable built-in Minio. If set to true, a new Minio instance will be created (not highly available). If you have an existing Minio or any S3-compatible storage, set to false. | `true`                   |
| `minio.isPrivate`                 | Is it a private repository                                                                                                                                                    | `false`                  |
| `minio.mode`                      | Deployment architecture, currently only supports `standalone` mode.                                                                                                           | `standalone`             |
| `minio.defaultBuckets`            | Default Bucket names to create, separated by commas.                                                                                                                          | `monkeys-static`         |
| `minio.auth.rootUser`             | Root username                                                                                                                                                                 | `minio`                  |
| `minio.auth.rootPassword`         | Root password                                                                                                                                                                 | `monkeys123`             |
| `minio.service.type`              | Minio Service mode, this Minio needs to be accessible externally (via browser), defaults to `Nodeport` mode.                                                                  | `NodePort`               |
| `minio.service.nodePorts.api`     | Minio API port mapped to the host port                                                                                                                                        | `31900`                  |
| `minio.service.nodePorts.console` | Minio Console port mapped to the host port                                                                                                                                    | `31901`                  |
| `minio.endpoint`                  | Minio API endpoint accessible externally. You might need to change it to the host server IP + API Node Port.                                                                  | `http://127.0.0.1:31900` |

After startup, you should be able to access the Minio management console at the host IP + port (31901) with the above set credentials.

> Note: If you are using a minikube cluster, you need to manually port forward the Minio service ports as follows:
>
> ```bash
> kubectl port-forward svc/monkeys-minio 31900:9000 -n monkeys
> kubectl port-forward svc/monkeys-minio 31901:9001 -n monkeys
> ```
> Also, make sure to open the host's ports to allow external access.
> See [https://stackoverflow.com/a/55110218](https://stackoverflow.com/a/55110218) for details.

#### Using External S3 Storage


| Parameter                    | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | Default |
| ---------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `externalS3.enabled`         | Use an external object storage that supports the S3 protocol, such as Minio, AWS S3, etc.                                                                                                                                                                                                                                                                                                                                                                                                                       | `false` |
| `externalS3.proxy`           | Use the Server as an intermediary proxy for uploads. In some cases, your S3 service (such as MinIO) may not be directly accessible from the outside.                                                                                                                                                                                                                                                                                                                                                            | `true`  |
| `externalS3.isPrivate`       | Whether it is a private repository.                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | `false` |
| `externalS3.forcePathStyle`  | Use path-style endpoint. When using Minio, this usually needs to be set to `true`.                                                                                                                                                                                                                                                                                                                                                                                                                              | `false` |
| `externalS3.accessKeyId`     | AccessKeyID                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | `""`    |
| `externalS3.secretAccessKey` | Secret Access Key                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | `""`    |
| `externalS3.region`          | Region                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | `""`    |
| `externalS3.bucket`          | Bucket name. Please use a public bucket so that it can be accessed by the front end.                                                                                                                                                                                                                                                                                                                                                                                                                            | `""`    |
| `externalS3.endpoint`        | S3 service endpoint address. If `proxy` is `true`, the S3 will be accessed within the `server` service using this internal address; if `proxy` is `false`, this address must be accessible from the browser. Example: If you are using `minio`, the `api` port should be specified, not the `console` port; if using a cloud provider's S3 service, specify the corresponding `endpoint` address, such as `https://tos-s3-cn-beijing.volces.com`.                                                               | `""`    |
| `externalS3.publicAccessUrl` | Note: `publicAccessUrl` and `endpoint` are different addresses. This address will be used as the prefix of the URL obtained after uploading, and must be accessible by the browser, otherwise, the uploaded files will not be displayed correctly. If you are using an S3 service provided by a cloud provider such as AWS, Alibaba Cloud, Volcano Engine, and have configured a CDN acceleration address for the bucket, you can set this address to the CDN address, such as `https://static.infmonkeys.com`. | `""`    |


## Service Monitoring

For detailed Prometheus metrics exposed by the Monkeys service, please refer to [https://inf-monkeys.github.io/docs/en-us/cluster/monitoring/prometheus-grafana/](https://inf-monkeys.github.io/docs/en-us/cluster/monitoring/prometheus-grafana/).

### Installing Prometheus Operator

If you haven't installed Prometheus Operator yet, you can install it using the following commands, setting the namespace to `monitoring`:

```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring
```

Check the installation status:

```sh
kubectl get all -n monitoring
```

### Configuration

| Parameter         | Description              | Default |
| ----------------- | ------------------------ | ------- |
| `serviceMonitors` | Enabled service monitors | `[]`    |

As the deployment environment may not have Prometheus Operator installed by default, `serviceMonitors` is initially set to an empty array. Once Prometheus Operator is installed, you can configure `serviceMonitors` as follows:

- `namespace`: Modify it to the namespace where your Prometheus Operator is deployed.

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

If you deploy a `vllm` service in the **current namespace**, you can add a new `serviceMonitor` similarly, though Monkeys' Helm charts do not provide this by default.
