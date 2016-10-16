!#/bin/bash
rpm -ivh https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-6-x86_64/pgdg-centos96-9.6-3.noarch.rpm
sed -i 's/^gpgkey.*/&\nexclude=postgresql*/' /etc/yum.repos.d/CentOS-Base.repo
yum -y install postgresql96 postgresql96-server postgresql96-devel postgresql96-libs
service postgresql-9.6 initdb
sed -i "/^host/s/ident/md5/g" /var/lib/pgsql/9.6/data/pg_hba.conf
service postgresql-9.3 stop
chkconfig --level 35 postgresql-9.3 off
su - postgres
/usr/pgsql-9.6/bin/pg_upgrade -b /usr/pgsql-9.3/bin/ -B /usr/pgsql-9.6/bin/ -d /var/lib/pgsql/9.3/data/ -D /var/lib/pgsql/9.6/data/
exit
service postgresql-9.6 start
chkconfig --level 35 postgresql-9.6 on
su - postgres
./analyze_new_cluster.sh
exit
export PATH=/usr/pgsql-9.6/bin:$PATH
exit 0
