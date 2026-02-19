FROM signoz/signoz-otel-collector:v0.142.0
COPY configs/otel/otel-collector-config.yaml /etc/otel-collector-config.yaml
COPY configs/otel/manager-config.yaml /etc/manager-config.yaml
