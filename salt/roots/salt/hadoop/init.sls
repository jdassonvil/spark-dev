{% set hadoop_install_dir = '/opt/hadoop' %}
{% set hadoop_version = salt['pillar.get']('hadoop:version') %}
{% set hadoop_home = hadoop_install_dir + '/hadoop-' + hadoop_version  %}
{% set hadoop_downloadUrl = salt['pillar.get']('hadoop:downloadUrl') %}
{% set hadoop_hash = salt['pillar.get']('hadoop:sha256') %}
{% set java_home = '/usr/share/java/' + salt['pillar.get']('java:version') %}

include:
  - .users

hadoop_rsync:
  pkg.installed:
    - name: rsync

hadoop_mkdir:
  file.directory:
    - name: {{ hadoop_install_dir }} 
    - user: hadoop
    - group: hadoop
    - dir_mode: 755
    - makedirs: True

hadoop_dl-and-extract:
  archive.extracted:
    - name: {{ hadoop_install_dir }}
    - source: {{ hadoop_downloadUrl }}
    - source_hash: {{ hadoop_hash }}
    - archive_format: tar
    - user: hadoop
    - group: hadoop
    - if_missing: {{hadoop_home}} 
    - require:
      - hadoop_mkdir

hadoop_manage-env:
  file.managed:
    - name: {{hadoop_home}}/etc/hadoop/hadoop-env.sh
    - source: salt://hadoop/templates/hadoop-env.sh.tpl
    - template: jinja
    - user: hadoop
    - group: hadoop
    - context:
      java_home: {{java_home}}

hadoop_manager-core-site:
  file.managed:
    - name: {{hadoop_home}}/etc/hadoop/core-site.xml
    - source: salt://hadoop/files/core-site.xml
    - user: hadoop
    - group: hadoop

hadoop_manager-hdfs-site:
  file.managed:
    - name: {{hadoop_home}}/etc/hadoop/hdfs-site.xml
    - source: salt://hadoop/files/hdfs-site.xml
    - user: hadoop
    - group: hadoop

#hadoop_namenode-format:
#  cmd.run:
#    - name: {{hadoop_home}}/bin/hdfs namenode -format

{% if grains['osmajorrelease']=="7" %}
hdfs-namenode_systemd-config:
  file.managed:
    - name: /usr/lib/systemd/system/hdfs-namenode.service
    - source: salt://hadoop/templates/systemd/hdfs-namenode.service.tpl
    - mode: 644
    - template: jinja
    - context:
      hadoop_home: {{hadoop_home}}
{% endif %}

hdfs-namenode_service:
  service.running:
    - name: hdfs-namenode
    - enable: True

hdfs-namenode_configure-iptables-9000:
    iptables.insert:
    - position: 1
    - chain: INPUT
    - jump: ACCEPT
    - dport: 9000
    - proto: tcp
    - save: True

hdfs-namenode_configure-iptables-50070:
    iptables.insert:
    - position: 1
    - chain: INPUT
    - jump: ACCEPT
    - dport: 50070
    - proto: tcp
    - save: True
