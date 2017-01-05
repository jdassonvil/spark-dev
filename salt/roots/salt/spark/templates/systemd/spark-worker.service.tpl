[Unit]
Description=Spark Worker
Wants=network.target network-online.target
After=network.target network-online.target

[Service]
Type=forking
User=spark
ExecStart={{ spark_home }}/bin/spark-class org.apache.spark.deploy.worker.Worker spark://localhost:7077
Restart=on-abort

[Install]
WantedBy=multi-user.target
