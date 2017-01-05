{% set spark_install_dir = '/opt/spark' %}
{% set spark_home = spark_install_dir + '/spark-' + salt['pillar.get']('spark:version') + '-bin-hadoop2.7' %}

{% if grains['osmajorrelease']=="7" %}
spark-worker_systemd-config:
  file.managed:
    - name: /usr/lib/systemd/system/spark-worker.service
    - source: salt://spark/templates/systemd/spark-worker.service.tpl
    - mode: 644
    - template: jinja
    - context:
      spark_home: {{spark_home}}
{% endif %}

spark-worker_service:
  service.running:
    - name: spark-worker
    - enable: True
    - user: spark
