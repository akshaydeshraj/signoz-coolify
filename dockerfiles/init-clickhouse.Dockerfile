FROM clickhouse/clickhouse-server:25.5.6
COPY configs/clickhouse-user-scripts/ /var/lib/clickhouse/user_scripts/
