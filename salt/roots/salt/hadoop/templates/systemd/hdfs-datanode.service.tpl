[Unit]
Description=Hadoop Distributed File System Datanode

[Service]
Type=simple
User=root
Group=root
ExecStart={{hadoop_home}}/bin/hadoop datanode
Restart=always

[Install]
WantedBy=multi-user.target
