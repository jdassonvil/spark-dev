tools_install-mlocate:
  pkg.installed:
    - name: mlocate

tools_init-mlocate:
  cmd.run:
    - name: updatedb
