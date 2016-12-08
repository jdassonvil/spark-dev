{% set p  = salt['pillar.get']('java', {}) %}
{% set g  = salt['grains.get']('java', {}) %}

{%- set java_home            = salt['grains.get']('java_home', salt['pillar.get']('java_home', '/usr/lib/java')) %}

{%- set default_version_name = salt['pillar.get']('java:version') %}
{%- set default_prefix       = '/usr/share/java' %}
{%- set default_source_url   =  salt['pillar.get']('java:download_url') %}
{%- set default_source_hash  =  salt['pillar.get']('java:sha256') %}
{%- set default_jce_url      =  salt['pillar.get']('jce:download_url') %}
{%- set default_jce_hash     =  salt['pillar.get']('jce:sha256') %}
{%- set default_dl_opts      = '-b oraclelicense=accept-securebackup-cookie -L -s' %}

{%- set version_name         = g.get('version_name', p.get('version_name', default_version_name)) %}
{%- set source_url           = g.get('source_url', p.get('source_url', default_source_url)) %}

{%- if source_url == default_source_url %}
  {%- set source_hash        = default_source_hash %}
{%- else %}
  {%- set source_hash        = g.get('source_hash', p.get('source_hash', '')) %}
{%- endif %}

{%- set jce_url              = g.get('jce_url', p.get('jce_url', default_jce_url)) %}

{%- if jce_url == default_jce_url %}
  {%- set jce_hash           = default_jce_hash %}
{%- else %}
  {%- set jce_hash           = g.get('jce_hash', p.get('jce_hash', '')) %}
{%- endif %}

{%- set dl_opts              = g.get('dl_opts', p.get('dl_opts', default_dl_opts)) %}
{%- set prefix               = g.get('prefix', p.get('prefix', default_prefix)) %}
{%- set java_real_home       = prefix + '/' + version_name %}
{%- set jre_lib_sec          = java_real_home + '/jre/lib/security' %}

{%- set java = {} %}
{%- do java.update( { 'version_name'   : version_name,
                      'source_url'     : source_url,
                      'source_hash'    : source_hash,
                      'jce_url'        : jce_url,
                      'jce_hash'       : jce_hash,
                      'dl_opts'        : dl_opts,
                      'java_home'      : java_home,
                      'prefix'         : prefix,
                      'java_real_home' : java_real_home,
                      'jre_lib_sec'    : jre_lib_sec,
                    } ) %}
