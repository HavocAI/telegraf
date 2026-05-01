# ![tiger](assets/TelegrafTigerSmall.png "tiger") Telegraf

[![GoDoc](https://img.shields.io/badge/doc-reference-00ADD8.svg?logo=go)](https://godoc.org/github.com/influxdata/telegraf)
[![Docker pulls](https://img.shields.io/docker/pulls/library/telegraf.svg)](https://hub.docker.com/_/telegraf/)
[![Go Report Card](https://goreportcard.com/badge/github.com/influxdata/telegraf)](https://goreportcard.com/report/github.com/influxdata/telegraf)
[![Circle CI](https://circleci.com/gh/influxdata/telegraf.svg?style=svg)](https://circleci.com/gh/influxdata/telegraf)

Telegraf is an agent for collecting, processing, aggregating, and writing
metrics, logs, and other arbitrary data.

* Offers a comprehensive suite of over 300 plugins, covering a wide range of
  functionalities including system monitoring, cloud services, and message
  passing
* Enables the integration of user-defined code to collect, transform, and
  transmit data efficiently
* Compiles into a standalone static binary without any external dependencies,
  ensuring a streamlined deployment process
* Utilizes TOML for configuration, providing a user-friendly and unambiguous
  setup experience
* Developed with contributions from a diverse community of over 1,200
  contributors

Users can choose plugins from a wide range of topics, including but not limited
to:

* Devices: [OPC UA][], [Modbus][]
* Logs: [File][], [Tail][], [Directory Monitor][]
* Messaging: [AMQP][], [Kafka][], [MQTT][]
* Monitoring: [OpenTelemetry][], [Prometheus][]
* Networking: [Cisco TelemetryMDT][], [gNMI][]
* System monitoring: [CPU][], [Memory][], [Disk][], [Network][], [SMART][],
  [Docker][], [Nvidia SMI][], etc.
* Universal: [Exec][], [HTTP][], [HTTP Listener][], [SNMP][], [SQL][]
* Windows: [Event Log][], [Management Instrumentation][],
  [Performance Counters][]

## 🔨 Installation

For binary builds, Docker images, RPM & DEB packages, and other builds of
Telegraf, please see the [install guide](/docs/INSTALL_GUIDE.md).

See the [releases documentation](/docs/RELEASES.md) for details on versioning
and when releases are made.

## 💻 Usage

Users define a TOML configuration with the plugins and settings they wish to
use, then pass that configuration to Telegraf. The Telegraf agent then
collects data from inputs at each interval and sends data to outputs at each
flush interval.

For a basic walkthrough see [quick start](/docs/QUICK_START.md).

## 📖 Documentation

For a full list of documentation including tutorials, reference and other
material, start with the [/docs directory](/docs/README.md).

Additionally, each plugin has its own README that includes details about how to
configure, use, and sometimes debug or troubleshoot. Look under the
[/plugins directory](/plugins/) for specific plugins.

Here are some commonly used documents:

* [Changelog](/CHANGELOG.md)
* [Configuration](/docs/CONFIGURATION.md)
* [FAQ](/docs/FAQ.md)
* [Releases](https://github.com/influxdata/telegraf/releases)
* [Security](/SECURITY.md)

## ❤️ Contribute

[![Contribute](https://img.shields.io/badge/contribute-to_telegraf-blue.svg?logo=influxdb)](https://github.com/influxdata/telegraf/blob/master/CONTRIBUTING.md)

We love our community of over 1,200 contributors! Many of the plugins included
in Telegraf were originally contributed by community members. Check out
our [contributing guide](CONTRIBUTING.md) if you are interested in helping out.
Also, join us on our [Community Slack](https://influxdata.com/slack) or
[Community Forums](https://community.influxdata.com/) if you have questions or
comments for our engineering teams.

If you are completely new to Telegraf and InfluxDB, you can also enroll for free
at [InfluxDB university](https://www.influxdata.com/university/) to take courses
to learn more.

## ℹ️ Support

[![Slack](https://img.shields.io/badge/slack-join_chat-blue.svg?logo=slack)](https://www.influxdata.com/slack)
[![Forums](https://img.shields.io/badge/discourse-join_forums-blue.svg?logo=discourse)](https://community.influxdata.com/)

Please use the [Community Slack](https://influxdata.com/slack) or
[Community Forums](https://community.influxdata.com/) if you have questions or
comments for our engineering teams. GitHub issues are limited to actual issues
and feature requests only.

## 🐳 Docker (Havoc)

This fork publishes a multi-arch image (`linux/amd64`, `linux/arm64`) to GHCR that replaces the standard Telegraf binary with one compiled from this repo, including the MAVLink input plugin.

### Pulling a published image

```bash
# Specific semver release
docker pull ghcr.io/havocai/telegraf:v1.35.0-havoc.1

# Latest stable
docker pull ghcr.io/havocai/telegraf:latest-havoc

# Pinned to a commit SHA
docker pull ghcr.io/havocai/telegraf:sha-e1f7aeeb
```

### Building locally

Requires a GitHub token with read access to `github.com/HavocAI/mavlink-dialect` (your `gh` CLI session token works):

```bash
GITHUB_TOKEN=$(gh auth token) docker buildx build \
  --secret id=GITHUB_TOKEN,env=GITHUB_TOKEN \
  --build-arg GIT_TAG="" \
  --build-arg COMMIT=$(git rev-parse --short=8 HEAD) \
  --build-arg BRANCH=$(git rev-parse --abbrev-ref HEAD) \
  --load \
  -t telegraf-havoc:local \
  .
```

To tag a release build, set `GIT_TAG` to the semver tag (drives the version string embedded in the binary):

```bash
  --build-arg GIT_TAG=v1.35.0-havoc.1 \
```

### Verifying the image

```bash
# Binary runs and reports version
docker run --rm telegraf-havoc:local --version

# MAVLink plugin is compiled in
docker run --rm telegraf-havoc:local telegraf --usage mavlink

# Config parses cleanly (connection refused to 127.0.0.1:5760 is expected)
docker run --rm \
  -v "$PWD/plugins/inputs/mavlink/sample.conf:/etc/telegraf/telegraf.conf:ro" \
  telegraf-havoc:local \
  --config /etc/telegraf/telegraf.conf \
  --test
```

### CI tags

| Trigger | Tags applied |
|---|---|
| Push to `master` | `sha-<commit>` |
| Tag push `v*.*.*-havoc.*` | `v1.35.0-havoc.1`, `sha-<commit>`, `latest-havoc` |
| Manual dispatch with `stable: true` | `sha-<commit>`, `latest-havoc` |

## 📜 License

[![MIT](https://img.shields.io/badge/license-MIT-blue)](https://github.com/influxdata/telegraf/blob/master/LICENSE)

[OPC UA]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/opcua
[Modbus]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/modbus
[File]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/file
[Tail]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/tail
[Directory Monitor]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/directory_monitor
[AMQP]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/amqp_consumer
[Kafka]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/kafka_consumer
[MQTT]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/mqtt_consumer
[OpenTelemetry]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/opentelemetry
[Prometheus]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/prometheus
[Cisco TelemetryMDT]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/cisco_telemetry_mdt
[gNMI]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/gnmi
[CPU]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/cpu
[Memory]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/mem
[Disk]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/disk
[Network]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/net
[SMART]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/smartctl
[Docker]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/docker
[Nvidia SMI]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/nvidia_smi
[Exec]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/exec
[HTTP]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/http
[HTTP Listener]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/http_listener_v2
[SNMP]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/snmp
[SQL]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/sql
[Event Log]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/win_eventlog
[Management Instrumentation]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/win_wmi
[Performance Counters]: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/win_perf_counters
