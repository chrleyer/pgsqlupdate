# pgsqlupdate
###Upgrade PostgeSQL database server from 9.3 to 9.6 on CentOS 6.x for odoo 8

####Install new version of PostgreSQL
First we will install the PostgreSQL version 9.6. We use the repository rather than simply downloading an RPM because it’s easier to keep up to date with important security and maintenance updates. This command will add the PostgreSQL repository to your server:

```
rpm -ivh https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-6-x86_64/pgdg-centos96-9.6-3.noarch.rpm
```

It’s important to exclude postgresql from the official CentOS repository files, otherwise we will encounter problems when we run updates:

```
sed -i 's/^gpgkey.*/&\nexclude=postgresql*/' /etc/yum.repos.d/CentOS-Base.repo
```

Installing PostgreSQL and some associated libraries is now straightforward. We then need to initialise the database.

```
yum -y install postgresql96 postgresql96-server postgresql96-devel postgresql96-libs
```

```
service postgresql-9.6 initdb
```

Next we need to configure PostgreSQL so it will accept connections using MD5 hashed passwords so it’s compatible with the Python modules:

```
sed -i "/^host/s/ident/md5/g" /var/lib/pgsql/9.6/data/pg_hba.conf
```

Now stop the old PostgreSQL service and deactivate the service level.

```
service postgresql-9.3 stop
chkconfig --level 35 postgresql-9.3 off
```

The pg_upgrade command must be run as postgres user:

```
sudo postgres
```

Use pg_update to move data from old 9.x to 9.6 version:

```
/usr/pgsql-9.6/bin/pg_upgrade -b /usr/pgsql-9.3/bin/ -B /usr/pgsql-9.6/bin/ -d /var/lib/pgsql/9.3/data/ -D /var/lib/pgsql/9.6/data/
```

Now start the new 9.6 service

This must be done as root, better user new shell window.

```
service postgresql-9.6 start
chkconfig --level 35 postgresql-9.6 on
```
Cleanup database (run as user postgres)

```
./analyze_new_cluster.sh
./delete_old_cluster.sh
```

Now we need to edit the PATH in /etc/profile

```
export PATH=/usr/pgsql-9.6/bin:$PATH
```

Finally check the /bin PATH in backup and restore routines, like CRON jobs etc.

Check Backup function and odoo database connection / backup etc.



