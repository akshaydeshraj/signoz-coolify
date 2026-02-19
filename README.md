# SigNoz on Coolify

Deploy [SigNoz](https://signoz.io) (open-source observability platform) on [Coolify](https://coolify.io) using Docker Compose.

## Architecture

- **SigNoz** - Main application (UI + API) on port `8082`
- **ClickHouse** - Telemetry data storage
- **ZooKeeper** - ClickHouse coordination
- **OTel Collector** - Receives traces, metrics, and logs via OTLP (gRPC `:4317`, HTTP `:4318`)
- **Schema Migrator** - Runs ClickHouse schema migrations on startup

## Deploying on Coolify

1. Push this repo to GitHub
2. In Coolify: **Projects** > select project > **+ New** > **Resource** > **Docker Compose**
3. Select your server and choose **Git Repository** as the source
4. Point it to this repo (branch: `main`)
5. Set Docker Compose file path to `docker-compose.yaml`
6. Hit **Deploy**

## Ports

| Port | Service |
|------|---------|
| `8082` | SigNoz UI |
| `4317` | OTLP gRPC receiver |
| `4318` | OTLP HTTP receiver |

## Sending Data to SigNoz

Configure your applications to send telemetry to the OTel Collector:

```
OTEL_EXPORTER_OTLP_ENDPOINT=http://<your-server-ip>:4317
```

## Configuration

Config files live in `configs/` and are directory-mounted into containers (Coolify does not support file-level bind mounts):

```
configs/
├── clickhouse-server/          # -> /etc/clickhouse-server
│   ├── config.xml
│   ├── users.xml
│   ├── custom-function.xml
│   ├── config.d/
│   │   └── cluster.xml
│   └── users.d/
├── clickhouse-user-scripts/    # -> /var/lib/clickhouse/user_scripts
├── signoz/                     # -> /root/config
│   ├── prometheus.yml
│   └── dashboards/
└── otel/                       # -> /etc/otel
    ├── otel-collector-config.yaml
    └── manager-config.yaml
```

## Based On

Official SigNoz Docker Compose from [SigNoz/signoz](https://github.com/SigNoz/signoz) (`deploy/docker/docker-compose.yaml`), adapted for Coolify compatibility:

- Removed `!!merge` YAML tags (unsupported by Coolify's parser)
- Used directory mounts instead of file mounts (Coolify creates missing file mounts as directories)
- Removed explicit `name:` from networks/volumes (avoids conflicts with Coolify's project scoping)
- Hardcoded image versions instead of env var defaults
- Removed Docker Swarm-specific features (`configs`, `deploy`, Go templates)
