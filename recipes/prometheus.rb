remote_file '/tmp/prometheus-2.4.0.linux-amd64.tar.gz' do
  source 'https://github.com/prometheus/prometheus/releases/download/v2.4.0/prometheus-2.4.0.linux-amd64.tar.gz'
end

execute 'tar xvf /tmp/prometheus-2.4.0.linux-amd64.tar.gz' do
  cwd '/opt/'
end

link '/opt/prometheus' do
  to '/opt/prometheus-2.4.0.linux-amd64'
end

file '/opt/prometheus/prometheus.yml' do
  content <<EOF
global:
  scrape_interval: 15s
  external_labels:
    monitor: 'codelab-monitor'
scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'node'
    scrape_interval: 15s
    static_configs:
      - targets: ['localhost:9100']
  - job_name: 'es'
    scrape_interval: 15s
    static_configs:
      - targets: ['localhost:9108']
EOF
end

file '/etc/systemd/system/prometheus.service' do
  content <<EOF
[Unit]
Description=Prometheus

[Service]
User=root
ExecStart=/opt/prometheus/prometheus --config.file=/opt/prometheus/prometheus.yml

[Install]
WantedBy=multi-user.target
EOF
end

service 'prometheus' do
  action [:enable, :start]
end
