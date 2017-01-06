[Unit]
Description=Spark History Server
Wants=network.target network-online.target
After=network.target network-online.target

[Service]
Type=forking
User=spark
ExecStart={{ spark_home }}/sbin/start-history-server.sh
Restart=on-abort

[Install]
WantedBy=multi-user.target
