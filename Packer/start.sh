#!/bin/bash

sudo mkfs.ext4 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/disk/by-id/scsi-0Google_PersistentDisk_persistent-disk-1
sudo mount -o discard,defaults /dev/disk/by-id/scsi-0Google_PersistentDisk_persistent-disk-1 /mnt/traefik-acme
sudo touch /mnt/traefik-acme/acme.json
sudo chmod 600 /mnt/traefik-acme/acme.json
sudo umount /mnt/traefik-acme