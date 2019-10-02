# Deployment with EBS
Only one PersistentVolumeClaim created per Deployment yaml file

Need provide each PersistentVolumeClaim in Pod. Can't dynamically creat volume and attach to scale-up Pod automatically. Use StatefulSet instead unless there are some methods we are not aware.
