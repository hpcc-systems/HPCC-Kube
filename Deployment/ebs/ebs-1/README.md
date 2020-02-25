# Deployment with EBS
Only one PersistentVolumeClaim created per Deployment yaml file

Need provide each PersistentVolumeClaim in Pod. Can't dynamically create volume and attach to scale-up Pod automatically. Instead use StatefulSet.
