[Unit]
Description=Hadoop Distributed File System Namenode

[Service]
Type=simple
User=root
Group=root
ExecStart={{hadoop_home}}/bin/hadoop namenode
Restart=always

[Install]
WantedBy=multi-user.target
