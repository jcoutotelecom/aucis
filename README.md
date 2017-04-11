# aucis: 
Automatic Cisco Configuration Backup

This code is created under MIT Licence, and use a program called sshpass (Non-interactive ssh password auth) licenced under the GNU General Public License version 2.0 (GPLv2) by Shachar Shemesh, to make connections to a list of Cisco devices and make a backup of the start-up configuration file and the vlan configuration if there is any.

In able to use aucis, you shoud install sshpass.

This program is prepared to be scheduled on cron, and does not erase existing backups.

