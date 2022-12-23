# QuorumFix
brute forces the Proxmox quorum for HA-clusters comprised of even numbered nodes (**Use at your own risk**)

### Installation
log in as root user

download QuorumFix.sh and place it in /root/ or any other accessible directory by a privileged user

create a new cron job with ```crontab -e```

add ```*/1 * * * * /bin/bash -c "/root/QuorumFix.sh"```

---
 

bear in mind to adjust /bin/bash to your path of Bash

To find out, where your Bash is installed, use ```which bash```
