{% set spark_install_dir = '/opt/spark' %}
{% set spark_downloadUrl = salt['pillar.get']('spark:downloadUrl') %}
{% set spark_hash = salt['pillar.get']('spark:sha256') %}
{% set spark_home = spark_install_dir + '/spark-' + salt['pillar.get']('spark:version') + '-bin-hadoop2.7' %}

include:
  - .users

spark_mkdir:
  file.directory:
    - name: {{ spark_install_dir }} 
    - user: spark
    - group: spark
    - dir_mode: 755
    - makedirs: True

spark_dl-and-extract:
  archive.extracted:
    - name: {{ spark_install_dir }}
    - source: {{ spark_downloadUrl }}
    - source_hash: {{ spark_hash }}
    - archive_format: tar
    - user: spark
    - group: spark
    - if_missing: {{spark_home}}

spark_hdfs-log-dir:
  cmd.run:
    - name: /opt/hadoop/release/bin/hdfs dfs -mkdir -p /shared/spark-logs
