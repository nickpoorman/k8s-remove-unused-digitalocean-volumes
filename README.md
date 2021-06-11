# k8s-remove-unused-digitalocean-volumes

When you have a DigitalOcean Kubernetes storage class such as the following, the volumes will remain even after the pv and pvc are deleted from Kubernetes.

```
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: do-block-storage-persist
  annotations:
    storageclass.kubernetes.io/is-default-class: false
    name: do-block-storage-persist
    provisioner: dobs.csi.digitalocean.com
provisioner: dobs.csi.digitalocean.com
reclaimPolicy: Retain
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true
```

To help clean them up, run the following bash script.

```
./cleanup-volumes.sh
```

This script is very verbose and propmpts before deleting each volume.

```
==== doctl output ====
b36c7b21-c9f5-11eb-ba95-0a58ac144b91    pvc-04fjd73n-0e38-4e21-bd1b-92203e443f79    64 GiB     nyc1      ext4                                   [249902752]    k8s:34a5hboy-269h-2956-3j71-4c9i70b17824
066cf372-cac7-11eb-a910-0a58ac144fg2    pvc-7ld73bse-8bd6-492d-810e-101881158631    15 GiB     nyc1      ext4                                                  k8s:34a5hboy-269h-2956-3j71-4c9i70b17824
afd9f579-c3a3-11eb-b027-0a58ac144k3i    pvc-840nd74g-b64c-4c34-ae26-fa733eb536c7    15 GiB     nyc1      ext4                                                  k8s:34a5hboy-269h-2956-3j71-4c9i70b17824
dfae93c3-csf5-11eb-b027-0a58ac1448jw    pvc-dl38xj57-7fff-458d-b209-0e33dc495809    64 GiB     nyc1      ext4                                   [249902754]    k8s:34a5hboy-269h-2956-3j71-4c9i70b17824
10ee9807-c1f5-11eb-ba95-0a58ac144l2x    pvc-ak48bc57-f9c3-42d1-b076-72c5288f6d42    64 GiB     nyc1      ext4                                   [249902753]    k8s:34a5hboy-269h-2956-3j71-4c9i70b17824
0eba7408-c1f6-11eb-a910-0a58ac149n2x    pvc-lf94h672-2dec-4990-9bc0-11f44149b013    250 GiB    nyc1      ext4                                   [249903546]    k8s:34a5hboy-269h-2956-3j71-4c9i70b17824
4d143583-cx16-11eb-a701-0a58ac14593n    pvc-a93jmalq-7529-4b14-9487-6d2f21cc3b26    15 GiB     nyc1      ext4                                                  k8s:34a5hboy-269h-2956-3j71-4c9i70b17824
2156add6-c322-11eb-b027-0a58ac39jsca    pvc-p9cek29d-d210-4efd-bfcb-8a60be62804b    15 GiB     nyc1      ext4                                                  k8s:34a5hboy-269h-2956-3j71-4c9i70b17824
f19cf402-c9f8-11eb-ba95-0a58ac093sjz    pvc-sl38101s-622e-4071-bc51-486da92be7b0    250 GiB    nyc1      ext4                                   [249903547]    k8s:34a5hboy-269h-2956-3j71-4c9i70b17824
4117b270-c321-11eb-b13c-0a58ac156mda    pvc-ebed6c0c-d31c-40a7-9b22-3d494jsqo320    15 GiB     nyc1      ext4                                                  k8s:34a5hboy-269h-2956-3j71-4c9i70b17824
b006d95a-c678-11eb-b13c-0a58al13f9za    pvc-ed9dae0e-284e-4108-993a-a3303jnvzldw    1 GiB      nyc1      ext4                                                  k8s:34a5hboy-269h-2956-3j71-4c9i70b17824
2f194cb2-c311-11eb-a910-0a58393jdx82    pvc-f41114c6-4671-490c-924d-15583msw8n01    15 GiB     nyc1      ext4                                                  k8s:34a5hboy-269h-2956-3j71-4c9i70b17824
d70d27f1-c9k2-11eb-b027-0a58398sj398    pvc-f98f2242-26c2-4186-9e5f-f6sl3p391yfs    250 GiB    nyc1      ext4                                   [249903548]    k8s:34a5hboy-269h-2956-3j71-4c9i70b17824

===kube volumes===
pvc-04fjd73n-0e38-4e21-bd1b-92203e443f79
pvc-dl38xj57-7fff-458d-b209-0e33dc495809
pvc-ak48bc57-f9c3-42d1-b076-72c5288f6d42
pvc-lf94h672-2dec-4990-9bc0-11f44149b013
pvc-sl38101s-622e-4071-bc51-486da92be7b0
pvc-f98f2242-26c2-4186-9e5f-f6sl3p391yfs

===do volumes===
pvc-04fjd73n-0e38-4e21-bd1b-92203e443f79
pvc-7ld73bse-8bd6-492d-810e-101881158631
pvc-840nd74g-b64c-4c34-ae26-fa733eb536c7
pvc-dl38xj57-7fff-458d-b209-0e33dc495809
pvc-ak48bc57-f9c3-42d1-b076-72c5288f6d42
pvc-lf94h672-2dec-4990-9bc0-11f44149b013
pvc-a93jmalq-7529-4b14-9487-6d2f21cc3b26
pvc-p9cek29d-d210-4efd-bfcb-8a60be62804b
pvc-sl38101s-622e-4071-bc51-486da92be7b0
pvc-ebed6c0c-d31c-40a7-9b22-3d494jsqo320
pvc-ed9dae0e-284e-4108-993a-a3303jnvzldw
pvc-f41114c6-4671-490c-924d-15583msw8n01
pvc-f98f2242-26c2-4186-9e5f-f6sl3p391yfs

===do volumes ids===
b36c7b21-c9f5-11eb-ba95-0a58ac144b91
066cf372-cac7-11eb-a910-0a58ac144fg2
afd9f579-c3a3-11eb-b027-0a58ac144k3i
dfae93c3-c9f5-11eb-b027-0a58ac1448jw
10ee9807-c1f5-11eb-ba95-0a58ac144l2x
0eba7408-c1f6-11eb-a910-0a58ac149n2x
4d143583-c316-11eb-a701-0a58ac14593n
2156add6-c322-11eb-b027-0a58ac39jsca
f19cf402-c9f8-11eb-ba95-0a58ac093sjz
4117b270-c321-11eb-b13c-0a58ac156mda
b006d95a-c620-11eb-b13c-0a58al13f9za
2f194cb2-c311-11eb-a910-0a58393jdx82
d70d27f1-c9k2-11eb-b027-0a58398sj398

===volumes to cleanup===
Removing:
=>id: 066cf372-cac7-11eb-a910-0a58ac144fg2
=>pvc: pvc-7ld73bse-8bd6-492d-810e-101881158631
doctl line:
=>066cf372-cac7-11eb-a910-0a58ac144fg2    pvc-7ld73bse-8bd6-492d-810e-101881158631    15 GiB     nyc1      ext4                                                  k8s:34a5hboy-269h-2956-3j71-4c9i70b17824
Are you sure? [y/N] y
Warning: Are you sure you want to delete this volume? (y/N) ? y

Removing:
=>id: afd9f579-c3a3-11eb-b027-0a58ac144k3i
=>pvc: pvc-840nd74g-b64c-4c34-ae26-fa733eb536c7
doctl line:
=>afd9f579-c3a3-11eb-b027-0a58ac144k3i    pvc-840nd74g-b64c-4c34-ae26-fa733eb536c7    15 GiB     nyc1      ext4                                                  k8s:34a5hboy-269h-2956-3j71-4c9i70b17824
Are you sure? [y/N] y
Warning: Are you sure you want to delete this volume? (y/N) ? y

Removing:
=>id: 4d143583-c316-11eb-a701-0a58ac14593n
=>pvc: pvc-a93jmalq-7529-4b14-9487-6d2f21cc3b26
doctl line:
=>4d143583-cx16-11eb-a701-0a58ac14593n    pvc-a93jmalq-7529-4b14-9487-6d2f21cc3b26    15 GiB     nyc1      ext4                                                  k8s:34a5hboy-269h-2956-3j71-4c9i70b17824
Are you sure? [y/N] y
Warning: Are you sure you want to delete this volume? (y/N) ? y

Removing:
=>id: 2156add6-c322-11eb-b027-0a58ac39jsca
=>pvc: pvc-p9cek29d-d210-4efd-bfcb-8a60be62804b
doctl line:
=>2156add6-c322-11eb-b027-0a58ac39jsca    pvc-p9cek29d-d210-4efd-bfcb-8a60be62804b    15 GiB     nyc1      ext4                                                  k8s:34a5hboy-269h-2956-3j71-4c9i70b17824
Are you sure? [y/N] y
Warning: Are you sure you want to delete this volume? (y/N) ? y

Removing:
=>id: 4117b270-c321-11eb-b13c-0a58ac156mda
=>pvc: pvc-ebed6c0c-d31c-40a7-9b22-3d494jsqo320
doctl line:
=>4117b270-c321-11eb-b13c-0a58ac156mda    pvc-ebed6c0c-d31c-40a7-9b22-3d494jsqo320    15 GiB     nyc1      ext4                                                  k8s:34a5hboy-269h-2956-3j71-4c9i70b17824
Are you sure? [y/N] y
Warning: Are you sure you want to delete this volume? (y/N) ? y

Removing:
=>id: b006d95a-c620-11eb-b13c-0a58al13f9za
=>pvc: pvc-ed9dae0e-284e-4108-993a-a3303jnvzldw
doctl line:
=>b006d95a-c678-11eb-b13c-0a58al13f9za    pvc-ed9dae0e-284e-4108-993a-a3303jnvzldw    1 GiB      nyc1      ext4                                                  k8s:34a5hboy-269h-2956-3j71-4c9i70b17824
Are you sure? [y/N] y
Warning: Are you sure you want to delete this volume? (y/N) ? y

Removing:
=>id: 2f194cb2-c311-11eb-a910-0a58393jdx82
=>pvc: pvc-f41114c6-4671-490c-924d-15583msw8n01
doctl line:
=>2f194cb2-c311-11eb-a910-0a58393jdx82    pvc-f41114c6-4671-490c-924d-15583msw8n01    15 GiB     nyc1      ext4                                                  k8s:34a5hboy-269h-2956-3j71-4c9i70b17824
Are you sure? [y/N] y
Warning: Are you sure you want to delete this volume? (y/N) ? y

removed 7 unused volumes
066cf372-cac7-11eb-a910-0a58ac144fg2
afd9f579-c3a3-11eb-b027-0a58ac144k3i
4d143583-c316-11eb-a701-0a58ac14593n
2156add6-c322-11eb-b027-0a58ac39jsca
4117b270-c321-11eb-b13c-0a58ac156mda
b006d95a-c620-11eb-b13c-0a58al13f9za
2f194cb2-c311-11eb-a910-0a58393jdx82
done.
```
