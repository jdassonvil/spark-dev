{% set spark_install_dir = '/opt/spark' %}
{% set spark_home = spark_install_dir + '/spark-' + salt['pillar.get']('spark:version') + '-bin-hadoop2.7' %}

{% if grains['osmajorrelease']=="7" %}
spark-history-server_systemd-config:
  file.managed:
    - name: /usr/lib/systemd/system/spark-history-server.service
    - source: salt://spark/templates/systemd/spark-history-server.service.tpl
    - mode: 644
    - template: jinja
    - context:
      spark_home: {{spark_home}}
{% endif %}

spark-history-server_service:
  service.running:
    - name: spark-history-server
    - enable: True
    - user: spark
