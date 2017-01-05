spark_create-group:
  group.present:
    - name: spark

spark_create-user:
  user.present:
    - name: spark
    - groups:
      - spark
      - hadoop
    - createhome: False
