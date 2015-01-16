# Steps to solve problems on vagrant instance

1- Unable to ping www.google.com

Remove /etc/hosts www.google.com entry and add dns on nsswitch.conf. Clues were that only ping command don't work (nslookup it's working) and remember nsswitch.conf file (because I used long time ago with Windows AD integrations)

2- Unable to successfully run the command mysql < /tmp/world.sql 

Change owner of /var/lib/mysql/World and change permission of World files. Restart mysql. Clues were that 13 error it's always permission so I saw that mysql user can't access to their mysql files. After change I had a read only error with one table, I was not sure what permissions are best so I check with another mysql server and put the same. 

3- The user problemz cannot write to the file /home/problemz/tasks.txt 

With root user chattr -i task.txt. Clues: It's second time that I have used this. Long time ago I used for secure files for backup purpouse.

4- The disk mounted at /mnt/saysfullbutnot cannot be written to despite claiming to have space available

inodes were full. With ext4 it's not possible change inode size after it's created. It's a common error when you have a partition on ext3/4 and have a tons of files. Sometimes these files are small and don't have problems with physical storage but you have problems with inodes number.

5- The user someadmin cannot sudo up to root

someadmin user it's not in sudo group: usermod -aG sudo someadmin with root user. I'm not sure if this was the problem or I understood bad. Just add someadmin user to sudo group after check in groups that this user it's not from sudo.

6- The software raid array under /dev/mda is reporting an error

One of the two disk from raid1 has removed from raid so raid1 (mirroring) it's functional but it's not secure (degraded). Just add again the loop disk to the raid: mdadm --manage /dev/md0 --add /dev/loop7 After check mdadm --detail /dev/md0 command to see what kind of raid, I could see that one of the two disks was degrade. I was checking syslog and confirm this theory so just add loop device again without problems. 

7- A server error is produced when loading http://172.16.2.12

Change fpm nginx configuration to use socket and not tcp port. Changed permissions to allow access from nginx to socket file. Put more memory for PHP on php.ini file of fpm configuration. It's a common error when using nginx as proxy so in configuration I saw that was a fpm-php module pointing to tcp port. In fpm-php it's configure a socket so I have changed on nginx vhost configuration. Then I have changed permission on socket creation to allow access from nginx user. Finally I have added more memory for run a phpinfo because 10K it's not enough.
