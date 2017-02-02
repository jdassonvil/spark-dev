{% set zk_install_dir = '/opt/zookeeper' %}
{% set zk_version = salt['pillar.get']('zookeeper:version') %}
{% set zk_home = zk_install_dir + '/zookeeper-' + zk_version %}
{% set zk_downloadUrl = salt['pillar.get']('zookeeper:downloadUrl') %}
{% set zk_hash = salt['pillar.get']('zookeeper:sha256') %}

zk_create-group:
  group.present:
    - name: zookeeper

zk_create-user:
  user.present:
    - name: zookeeper
    - groups:
      - zookeeper
    - createhome: False

zk_mkdir:
  file.directory:
    - name: {{ zk_install_dir }}
    - user: zookeeper
    - group: zookeeper
    - dir_mode: 755
    - makedirs: True

zk_dl-and-extract:
  archive.extracted:
    - name: {{ zk_install_dir }}
    - source: {{ zk_downloadUrl }}
    - source_hash: {{ zk_hash }}
    - archive_format: tar
    - user: zookeeper
    - group: zookeeper
    - if_missing: {{ zk_home }}
    - require:
      - zk_mkdir

zk_release-link:
  cmd.run:
    - name: ln -f -s {{ zk_home }} {{ zk_install_dir }}/release

zk_create-data-dir:
  file.directory:
    - name: /var/lib/zookeeper
    - user: zookeeper
    - group: zookeeper
    - dir_mode: 755
    - makedirs: True

zk_create-log-dir:
  file.directory:
    - name: /var/log/zookeeper
    - user: zookeeper
    - group: zookeeper
    - dir_mode: 755
    - makedirs: True

zk_manage-conf:
  file.managed:
    - name: {{zk_home}}/conf/zoo.cfg
    - source: salt://zookeeper/files/zoo.cfg
    - user: zookeeper
    - group: zookeeper

zk_manage-log-conf:
  file.managed:
    - name: {{zk_home}}/conf/log4j.properties
    - source: salt://zookeeper/templates/log4j.properties
    - user: zookeeper
    - group: zookeeper
    - template: jinja
    - context:
      zk_log_dir: /var/log/zookeeper


{% if grains['osmajorrelease']=="7" %}
zk_systemd-config:
  file.managed:
    - name: /usr/lib/systemd/system/zookeeper.service
    - source: salt://zookeeper/templates/systemd/zookeeper.service.tpl
    - mode: 644
    - template: jinja
    - context:
      zk_home: {{ zk_home }}
{% endif %}

zk_service:
  service.running:
    - name: zookeeper
    - enable: True
    - user: zookeeper
