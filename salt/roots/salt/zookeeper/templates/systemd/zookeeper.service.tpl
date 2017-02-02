[Unit]
Description=Zookeeper Key Value storage

[Service]
Type=simple
User=zookeeper
Group=zookeeper
ExecStart={{zk_home}}/bin/zkServer.sh start
Restart=always

[Install]
WantedBy=multi-user.target
