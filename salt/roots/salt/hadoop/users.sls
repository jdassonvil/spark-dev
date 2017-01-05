hadoop_create-group:
  group.present:
    - name: hadoop

hadoop_create-user:
  user.present:
   - name: hadoop
   - groups:
     - hadoop
   - createhome: False

hduser_create-user:
  user.present:
   - name: hduser
   - groups:
     - hadoop
