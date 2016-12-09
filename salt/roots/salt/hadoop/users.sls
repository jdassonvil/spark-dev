hadoop_create-group:
  group.present:
    - name: hadoop

hadoop_create-user:
  user.present:
   - name: hadoop
   - groups:
     - hadoop
