#Title 	:	Set a raid 5
#Author :	nicolas.glassey@cpnv.ch
#Source :   https://support.clustrix.com/hc/en-us/articles/203655739-How-to-make-the-mdadm-RAID-volume-persists-after-reboot
#Prereq :   super user
#           mdadm available
#			e2label available
#			
#How to :   before using this script, do not forget to update
#           -disk name present on your instance (ls -l /dev/xv*)
#			-label name
#			-type of RAID you want to use
#Version :  30.09.2017

#create raid device on md0 or whatever name
yes | mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/xvdd /dev/xvdb /dev/xvde

# make FS
mkfs -t ext4 /dev/md0
mkdir -p /ebs

# Give the partition a label
e2label /dev/md0 RAID5-DATA

# Edit fstab to mount it by label instead of device name. This is necessary as the raid array maybe
# assigned a different device name (in this case md127)
echo 'LABEL=RAID5-DATA /ebs ext4 defaults,noatime,nodiratime 0 2' >> /etc/fstab

# test fstab by running mount:
mount -a

# The filesystem should be mounted now. Verify with : 
df -H

# Backup mdadm config to its config file. (optional)
mdadm --verbose --detail --scan >> /etc/mdadm.conf