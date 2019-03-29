# Thanks for YT channel ProgrammingKnowledge, you teach one more thing
[https://www.youtube.com/watch?v=-LwI4HMR_Eg](Please subscribe)

## INSTALLATION
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
```

## DESINSTALLATION
```bash
dpkg -l | grep postgres
sudo apt --purge remove libreoffice-sdbc-postgresql postgresql postgresql-9.6 postgresql-client-9.6 postgresql-client-common postgresql-common postgresql-contrib postgresql-contrib-9.6
```

## OUTPUT OF INSTALLATION
```
A processar 'triggers' para systemd (232-25+deb9u9) ...
Configurando postgresql-common (181+deb9u2) ...
Adicionando usuário postgres ao grupo ssl-cert

Creating config file /etc/postgresql-common/createcluster.conf with new version

Creating config file /etc/logrotate.d/postgresql-common with new version
Building PostgreSQL dictionaries from installed myspell/hunspell packages...
  en_us
  pt_br
Removing obsolete dictionary files:
Created symlink /etc/systemd/system/multi-user.target.wants/postgresql.service → /lib/systemd/system/postgresql.service.
A processar 'triggers' para man-db (2.7.6.1-2) ...
Configurando postgresql-client-9.6 (9.6.11-0+deb9u1) ...
update-alternatives: a usar /usr/share/postgresql/9.6/man/man1/psql.1.gz para disponibilizar /usr/share/man/man1/psql.1.gz (psql.1.gz) em modo auto
Configurando postgresql-9.6 (9.6.11-0+deb9u1) ...
Creating new cluster 9.6/main ...
  config /etc/postgresql/9.6/main
  data   /var/lib/postgresql/9.6/main
  locale pt_BR.UTF-8
  socket /var/run/postgresql
  port   5432
update-alternatives: a usar /usr/share/postgresql/9.6/man/man1/postmaster.1.gz para disponibilizar /usr/share/man/man1/postmaster.1.gz (postmaster.1.gz) em modo auto
Configurando postgresql (9.6+181+deb9u2) ...
Configurando postgresql-contrib-9.6 (9.6.11-0+deb9u1) ...
Configurando postgresql-contrib (9.6+181+deb9u2) ...
A processar 'triggers' para systemd (232-25+deb9u9) ...

```

## CHECK IF EVERYTHING WORK
```bash
ls /etc/postgresql/9.6/main
environment  pg_ctl.conf  pg_hba.conf  pg_ident.conf  postgresql.conf  start.conf
```

> The main configuration file is __postgresql.conf__.

## PARAMETERS FOR Postgres SERVICE
```bash
sudo service postgresql
Usage: /etc/init.d/postgresql {start|stop|restart|reload|force-reload|status} [version ..]
```

## CHECKING STATUS OF SERVICE
```bash
➜  / sudo service postgresql status
● postgresql.service - PostgreSQL RDBMS
   Loaded: loaded (/lib/systemd/system/postgresql.service; enabled; vendor preset: enabled)
   Active: active (exited) since Fri 2019-03-29 00:09:24 -03; 4min 7s ago
 Main PID: 6646 (code=exited, status=0/SUCCESS)
      CPU: 782us
   CGroup: /system.slice/postgresql.service

mar 29 00:09:24 Unbootable systemd[1]: Starting PostgreSQL RDBMS...
mar 29 00:09:24 Unbootable systemd[1]: Started PostgreSQL RDBMS.
```

## LOGIN AS postgres, ENTER In psql BASH, LIST DATABASES AND LIST ROLES
```bash
sudo su postgres
psql
\l
\du
```

## CHANGE PASSWORD FOR ROLE postgres INSIDE psql BASH AND CREATE A NEW ROLE AS SUPERUSER
```bash
ALTER USER postgres WITH PASSWORD 'postgres6543';
ALTER ROLE
CREATE USER bode WITH PASSWORD 'piriguito$$23';
CREATE ROLE
ALTER USER bode WITH SUPERUSER;
ALTER ROLE
```

## DELETE ROLES
```bash
DROP USER bode;
DROP ROLE
```

## ACCESSING THE MAN OF psql BASH
```bash
man psql
```

## DOWNLOAD pgADMIN III
Open the Software Cente of your distro and search for pgADMIN III.


___ 
[https://stackoverflow.com/questions/11388786/how-does-one-drop-a-template-database-from-postgresql](StackOverflow Drop template database)

postgres=# create database tempDB is_template true;
CREATE DATABASE
postgres=# drop database tempDB;
ERROR:  cannot drop a template database
postgres=# alter database tempDB is_template false;
ALTER DATABASE
postgres=# drop database tempDB;
DROP DATABASE
postgres=# 

Documentation
shareimprove this answer
edited Apr 4 '17 at 8:44
answered Aug 9 '16 at 20:05
VynlJunkie
785917

This solution works and is far less complicated than the selected solution. – Brad Oct 4 '16 at 16:26
1
This is >=9.5 only.. – amoe Apr 3 '17 at 15:29
@amoe Great spot. Edited to add documentation link – VynlJunkie Apr 4 '17 at 8:45
Thank god you exist man. All the other solutions didn't work. Thanks! – koullislp Apr 26 '18 at 16:09
This works, but make sure to add single quotes around 'false' POSTGRES v10 – Luis Villavicencio May 20 '18 at 0:17
___
[https://stackoverflow.com/questions/1134848/is-it-safe-to-delete-the-3-default-databases-created-during-a-postgresql-install](StackOverflow)
postgres database is here as a non-template database with reasonable guarantee that it exists - so any script that doesn't know where to connect to, can connect there.

if you will remove template1 - you will lose the ability to create new databases (at least easily).

template0 is there as a backup, in case your template1 got damaged.

While I can theoretically imagine a working database with no template* and postgres databases, the thing that bugs me is that i have no idea what (security-wise) you want to achieve by removing them.

