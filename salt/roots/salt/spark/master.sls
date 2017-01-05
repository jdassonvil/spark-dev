{% set spark_install_dir = '/opt/spark' %}
{% set spark_home = spark_install_dir + '/spark-' + salt['pillar.get']('spark:version') + '-bin-hadoop2.7' %}

spark-master_configure-iptables-8080:
  iptables.insert:
    - position: 1
    - chain: INPUT
    - jump: ACCEPT
    - dport: 8080
    - proto: tcp
    - save: True

{% if grains['osmajorrelease']=="7" %}
spark-master_systemd-config:
  file.managed:
    - name: /usr/lib/systemd/system/spark-master.service
    - source: salt://spark/templates/systemd/spark-master.service.tpl
    - mode: 644
    - template: jinja
    - context:
      spark_home: {{spark_home}}
{% endif %}

spark-master_service:
  service.running:
    - name: spark-master
    - enable: True
    - user: spark
