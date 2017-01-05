{% set maven_install_dir='/usr/local/apache-maven' %}
{% set maven_checksum='6e3e9c949ab4695a204f74038717aa7b2689b1be94875899ac1b3fe42800ff82' %}
{% set maven_baseurl='http://ftp.wayne.edu/apache/maven/maven-3/3.3.9/binaries' %}
{% set maven_version='3.3.9' %}

include:
  - java

maven_directory:
  file.directory:
    - name: {{maven_install_dir}}
    - user: root
    - group: root
    - dir_mode: 755
    - makedirs: True

maven_dl-and-extract:
  archive.extracted:
    - name: {{maven_install_dir}}
    - source_hash: sha256={{maven_checksum}}
    - source: {{maven_baseurl}}/apache-maven-{{maven_version}}-bin.tar.gz
    - archive_format: tar
    - options: v
    - if_missing: {{maven_install_dir}}/apache-maven-{{maven_version}}
    - require:
      - maven_directory

maven_alternatives:
  alternatives.install:
    - name: mvn
    - link: /usr/bin/mvn
    - path: {{maven_install_dir}}/apache-maven-{{maven_version}}/bin/mvn
    - priority: 100
