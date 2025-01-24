# metallb

![Version: 0.14.8](https://img.shields.io/badge/Version-0.14.8-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.14.8](https://img.shields.io/badge/AppVersion-0.14.8-informational?style=flat-square)

A network load-balancer implementation for Kubernetes using standard routing protocols

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://metallb.github.io/metallb | metallb | 0.14.8 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.imagePullSecrets | list | `[]` |  |
| global.imageRegistry | string | `""` |  |
| global.storageClass | string | `""` |  |
| instances.arp.interfaces | list | `[]` |  |
| instances.arp.ipAddressPools | list | `["default-pool"]` | list of ip-address pools via arp advertisement |
| instances.arp.name | string | `"default-l2advertisement"` | default arp advertisement name |
| instances.arp.nodeSelectors.key | string | `"node.spidernet.io/include-metallb-l2-loadbalancer"` |  |
| instances.arp.nodeSelectors.value | string | `"true"` |  |
| instances.enabled | bool | `false` | enable default ip-address pool |
| instances.ipAddressPools.addresses | list | `[]` |  |
| instances.ipAddressPools.autoAssign | bool | `true` |  |
| instances.ipAddressPools.avoidBuggyIPs | bool | `true` |  |
| instances.ipAddressPools.name | string | `"default-pool"` | default ip-address pool name |
| instances.ipAddressPools.shared | bool | `false` | list of addresses pool, include ipv4/ipv6 shared ippool, if true, the each ip of the pool is  shared ip |
| metallb.controller.affinity | object | `{}` |  |
| metallb.controller.enabled | bool | `true` |  |
| metallb.controller.extraContainers | list | `[]` |  |
| metallb.controller.image.pullPolicy | string | `nil` |  |
| metallb.controller.image.registry | string | `"quay.m.daocloud.io"` |  |
| metallb.controller.image.repository | string | `"metallb/controller"` |  |
| metallb.controller.image.tag | string | `"v0.14.8"` |  |
| metallb.controller.labels | object | `{}` |  |
| metallb.controller.livenessProbe.enabled | bool | `true` |  |
| metallb.controller.livenessProbe.failureThreshold | int | `3` |  |
| metallb.controller.livenessProbe.initialDelaySeconds | int | `10` |  |
| metallb.controller.livenessProbe.periodSeconds | int | `10` |  |
| metallb.controller.livenessProbe.successThreshold | int | `1` |  |
| metallb.controller.livenessProbe.timeoutSeconds | int | `1` |  |
| metallb.controller.logLevel | string | `"info"` | Controller log level. Must be one of: `all`, `debug`, `info`, `warn`, `error` or `none` |
| metallb.controller.nodeSelector | object | `{}` |  |
| metallb.controller.podAnnotations | object | `{}` |  |
| metallb.controller.priorityClassName | string | `""` |  |
| metallb.controller.readinessProbe.enabled | bool | `true` |  |
| metallb.controller.readinessProbe.failureThreshold | int | `3` |  |
| metallb.controller.readinessProbe.initialDelaySeconds | int | `10` |  |
| metallb.controller.readinessProbe.periodSeconds | int | `10` |  |
| metallb.controller.readinessProbe.successThreshold | int | `1` |  |
| metallb.controller.readinessProbe.timeoutSeconds | int | `1` |  |
| metallb.controller.resources.limits.cpu | string | `"500m"` |  |
| metallb.controller.resources.limits.memory | string | `"500Mi"` |  |
| metallb.controller.resources.requests.cpu | string | `"50m"` |  |
| metallb.controller.resources.requests.memory | string | `"100Mi"` |  |
| metallb.controller.runtimeClassName | string | `""` |  |
| metallb.controller.securityContext.fsGroup | int | `65534` |  |
| metallb.controller.securityContext.runAsNonRoot | bool | `true` |  |
| metallb.controller.securityContext.runAsUser | int | `65534` |  |
| metallb.controller.serviceAccount.annotations | object | `{}` |  |
| metallb.controller.serviceAccount.create | bool | `true` |  |
| metallb.controller.serviceAccount.name | string | `""` |  |
| metallb.controller.strategy.type | string | `"RollingUpdate"` |  |
| metallb.controller.tlsCipherSuites | string | `""` |  |
| metallb.controller.tlsMinVersion | string | `"VersionTLS12"` |  |
| metallb.controller.tolerations | list | `[]` |  |
| metallb.crds.enabled | bool | `true` |  |
| metallb.crds.validationFailurePolicy | string | `"Fail"` |  |
| metallb.frrk8s.enabled | bool | `false` |  |
| metallb.frrk8s.external | bool | `false` |  |
| metallb.frrk8s.namespace | string | `""` |  |
| metallb.fullnameOverride | string | `""` |  |
| metallb.imagePullSecrets | list | `[]` |  |
| metallb.loadBalancerClass | string | `""` |  |
| metallb.nameOverride | string | `""` |  |
| metallb.prometheus.controllerMetricsTLSSecret | string | `""` |  |
| metallb.prometheus.metricsPort | int | `7472` |  |
| metallb.prometheus.namespace | string | `""` |  |
| metallb.prometheus.podMonitor.additionalLabels | object | `{}` |  |
| metallb.prometheus.podMonitor.annotations | object | `{}` |  |
| metallb.prometheus.podMonitor.enabled | bool | `false` |  |
| metallb.prometheus.podMonitor.interval | string | `nil` |  |
| metallb.prometheus.podMonitor.jobLabel | string | `"app.kubernetes.io/name"` |  |
| metallb.prometheus.podMonitor.metricRelabelings | list | `[]` |  |
| metallb.prometheus.podMonitor.relabelings | list | `[]` |  |
| metallb.prometheus.prometheusRule.additionalLabels."operator.insight.io/managed-by" | string | `"insight"` |  |
| metallb.prometheus.prometheusRule.addressPoolExhausted.enabled | bool | `true` |  |
| metallb.prometheus.prometheusRule.addressPoolExhausted.labels.severity | string | `"alert"` |  |
| metallb.prometheus.prometheusRule.addressPoolUsage.enabled | bool | `true` |  |
| metallb.prometheus.prometheusRule.addressPoolUsage.thresholds[0].labels.severity | string | `"warning"` |  |
| metallb.prometheus.prometheusRule.addressPoolUsage.thresholds[0].percent | int | `75` |  |
| metallb.prometheus.prometheusRule.addressPoolUsage.thresholds[1].labels.severity | string | `"warning"` |  |
| metallb.prometheus.prometheusRule.addressPoolUsage.thresholds[1].percent | int | `85` |  |
| metallb.prometheus.prometheusRule.addressPoolUsage.thresholds[2].labels.severity | string | `"alert"` |  |
| metallb.prometheus.prometheusRule.addressPoolUsage.thresholds[2].percent | int | `95` |  |
| metallb.prometheus.prometheusRule.annotations | object | `{}` |  |
| metallb.prometheus.prometheusRule.bgpSessionDown.enabled | bool | `true` |  |
| metallb.prometheus.prometheusRule.bgpSessionDown.labels.severity | string | `"alert"` |  |
| metallb.prometheus.prometheusRule.configNotLoaded.enabled | bool | `true` |  |
| metallb.prometheus.prometheusRule.configNotLoaded.labels.severity | string | `"warning"` |  |
| metallb.prometheus.prometheusRule.enabled | bool | `false` |  |
| metallb.prometheus.prometheusRule.extraAlerts | list | `[]` |  |
| metallb.prometheus.prometheusRule.staleConfig.enabled | bool | `true` |  |
| metallb.prometheus.prometheusRule.staleConfig.labels.severity | string | `"warning"` |  |
| metallb.prometheus.rbacPrometheus | bool | `false` |  |
| metallb.prometheus.rbacProxy.pullPolicy | string | `nil` |  |
| metallb.prometheus.rbacProxy.registry | string | `"gcr.m.daocloud.io"` |  |
| metallb.prometheus.rbacProxy.repository | string | `"kubebuilder/kube-rbac-proxy"` |  |
| metallb.prometheus.rbacProxy.tag | string | `"v0.12.0"` |  |
| metallb.prometheus.scrapeAnnotations | bool | `false` |  |
| metallb.prometheus.serviceAccount | string | `""` |  |
| metallb.prometheus.serviceMonitor.controller.additionalLabels."operator.insight.io/managed-by" | string | `"insight"` |  |
| metallb.prometheus.serviceMonitor.controller.annotations | object | `{}` |  |
| metallb.prometheus.serviceMonitor.controller.tlsConfig.insecureSkipVerify | bool | `true` |  |
| metallb.prometheus.serviceMonitor.enabled | bool | `false` |  |
| metallb.prometheus.serviceMonitor.interval | string | `nil` |  |
| metallb.prometheus.serviceMonitor.jobLabel | string | `"app.kubernetes.io/name"` |  |
| metallb.prometheus.serviceMonitor.metricRelabelings | list | `[]` |  |
| metallb.prometheus.serviceMonitor.relabelings | list | `[]` |  |
| metallb.prometheus.serviceMonitor.speaker.additionalLabels."operator.insight.io/managed-by" | string | `"insight"` |  |
| metallb.prometheus.serviceMonitor.speaker.annotations | object | `{}` |  |
| metallb.prometheus.serviceMonitor.speaker.tlsConfig.insecureSkipVerify | bool | `true` |  |
| metallb.prometheus.speakerMetricsTLSSecret | string | `""` |  |
| metallb.rbac.create | bool | `true` |  |
| metallb.speaker.affinity | object | `{}` |  |
| metallb.speaker.enabled | bool | `true` |  |
| metallb.speaker.excludeInterfaces.enabled | bool | `true` |  |
| metallb.speaker.extraContainers | list | `[]` |  |
| metallb.speaker.frr.enabled | bool | `false` |  |
| metallb.speaker.frr.image.pullPolicy | string | `nil` |  |
| metallb.speaker.frr.image.registry | string | `"quay.m.daocloud.io"` |  |
| metallb.speaker.frr.image.repository | string | `"frrouting/frr"` |  |
| metallb.speaker.frr.image.tag | string | `"9.1.0"` |  |
| metallb.speaker.frr.metricsPort | int | `7473` |  |
| metallb.speaker.frr.resources | object | `{}` |  |
| metallb.speaker.frrMetrics.resources | object | `{}` |  |
| metallb.speaker.ignoreExcludeLB | bool | `false` |  |
| metallb.speaker.image.pullPolicy | string | `nil` |  |
| metallb.speaker.image.registry | string | `"quay.m.daocloud.io"` |  |
| metallb.speaker.image.repository | string | `"metallb/speaker"` |  |
| metallb.speaker.image.tag | string | `"v0.14.8"` |  |
| metallb.speaker.labels | object | `{}` |  |
| metallb.speaker.livenessProbe.enabled | bool | `true` |  |
| metallb.speaker.livenessProbe.failureThreshold | int | `3` |  |
| metallb.speaker.livenessProbe.initialDelaySeconds | int | `10` |  |
| metallb.speaker.livenessProbe.periodSeconds | int | `10` |  |
| metallb.speaker.livenessProbe.successThreshold | int | `1` |  |
| metallb.speaker.livenessProbe.timeoutSeconds | int | `1` |  |
| metallb.speaker.logLevel | string | `"info"` | Speaker log level. Must be one of: `all`, `debug`, `info`, `warn`, `error` or `none` |
| metallb.speaker.memberlist.enabled | bool | `true` |  |
| metallb.speaker.memberlist.mlBindAddrOverride | string | `""` |  |
| metallb.speaker.memberlist.mlBindPort | int | `7946` |  |
| metallb.speaker.memberlist.mlSecretKeyPath | string | `"/etc/ml_secret_key"` |  |
| metallb.speaker.nodeSelector | object | `{}` |  |
| metallb.speaker.podAnnotations | object | `{}` |  |
| metallb.speaker.priorityClassName | string | `""` |  |
| metallb.speaker.readinessProbe.enabled | bool | `true` |  |
| metallb.speaker.readinessProbe.failureThreshold | int | `3` |  |
| metallb.speaker.readinessProbe.initialDelaySeconds | int | `10` |  |
| metallb.speaker.readinessProbe.periodSeconds | int | `10` |  |
| metallb.speaker.readinessProbe.successThreshold | int | `1` |  |
| metallb.speaker.readinessProbe.timeoutSeconds | int | `1` |  |
| metallb.speaker.reloader.resources | object | `{}` |  |
| metallb.speaker.resources.limits.cpu | string | `"200m"` |  |
| metallb.speaker.resources.limits.memory | string | `"300Mi"` |  |
| metallb.speaker.resources.requests.cpu | string | `"60m"` |  |
| metallb.speaker.resources.requests.memory | string | `"80Mi"` |  |
| metallb.speaker.runtimeClassName | string | `""` |  |
| metallb.speaker.securityContext | object | `{}` |  |
| metallb.speaker.serviceAccount.annotations | object | `{}` |  |
| metallb.speaker.serviceAccount.create | bool | `true` |  |
| metallb.speaker.serviceAccount.name | string | `""` |  |
| metallb.speaker.startupProbe.enabled | bool | `true` |  |
| metallb.speaker.startupProbe.failureThreshold | int | `30` |  |
| metallb.speaker.startupProbe.periodSeconds | int | `5` |  |
| metallb.speaker.tolerateMaster | bool | `true` |  |
| metallb.speaker.tolerations | list | `[]` |  |
| metallb.speaker.updateStrategy.type | string | `"RollingUpdate"` |  |

----------------------------------------------

## Configuration and installation details

### Quick Install

```shell
helm repo add daocloud-system https://release.daocloud.io/chartrepo/addon
helm install metallb daocloud-system/metallb  -n metallb-system
```

### ARP Mode

ARP Mode can be enabled when helm installing. Please refer to the following command:

#### Init ARP Mode

```shell
helm install metallb daocloud-system/metallb --set instances.enabled=true \
--set instances.ipAddressPools.addresses="{192.168.1.0/24,172.16.20.1-172.16.20.100}" \
-n metallb-system \
--wait
```

- `instances.enabled`: enable init arp mode, Default to `false`.
- `ipAddressPools.addresses`: Configure the address pool list(Cidr,Range,IPv6). Metallb assign IP addresses from the pool list.

> **Note**: flag **--wait**  is required when the arp mode is enabled. Otherwise, It may fail to initialize arp mode.

#### Specify interface for announce lb IPs

```shell
helm install metallb daocloud-system/metallb --set instances.enabled=true \
--set instances.ipAddressPools.addresses="{192.168.1.0/24,172.16.20.1-172.16.20.100}" \
--set instances.arp.interfaces="{ens192}"
-n metallb-system \
--wait
```

`--set instances.arp.interfaces="{ens192}"`: The LB IP will be announced only from interface 'ens192'.

### BGP Mode

BGP Mode requires with special hardware support, Such as BGP Router. If you want to enable bgp mode, In addition to having a BGP Router, You also need to configure
`BGPAdvertisement` and `BGPPeer`. For more details, Please refer to the doc: [advanced_bgp_configuration](https://metallb.universe.tf/configuration/_advanced_bgp_configuration/).

### Upgrade

If you want to upgrade **metallb**, Such as image version used. You should use the following command：

```shell
helm upgrade metallb daocloud-system/metallb  --set metallb.controller.image.tag=0.13.10
```

> **Note**: There is no support at this time for upgrading or deleting CRDs using Helm. So if you enabled arp mode when helm installing. And also you want to upgrade the CR resources(update address pool),
Please update the CR resources directly instead of updating it via helm upgrade.
