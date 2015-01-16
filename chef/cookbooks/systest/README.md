systest Cookbook
================
This cookbook prepare a fresh wordpress installation with some features required.

Requirements
------------
No requirements for use this cookbook. Tested only in ubuntu linux 14.04.

Attributes
----------
Only a few attributes:

#### systest::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['wordpress']['database']</tt></td>
    <td>Varchar</td>
    <td>Set database name for wordpress</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['wordpress']['path']</tt></td>
    <td>Varchar</td>
    <td>Set path for wordpress installation</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['wordpress']['db_username']</tt></td>
    <td>Varchar</td>
    <td>Set database username for wordpress</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['systest']['server_name']</tt></td>
    <td>Varchar</td>
    <td>Servername to access webserver</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Directories
-----------
- `attributes` - default attributes
- `files` - folder with certificates for apache2
- `recipes` - common recipes
- `templates` - commong templates

Cookbooks
---------
- apache2
- apt
- build-essential
- chef_handler
- chef-sugar
- database
- iis
- iptables
- logrotate
- mariadb
- mysql
- mysql2_chef_gem
- openssl
- php
- postgresql
- rbac
- smf
- sudo
- windows
- xml
- yum
- yum-epel
- yum-mysql-community

Usage
-----
#### systest::default
Include `systest` in your node's `run_list`. You must specify a root password for `MySQL` and password for wordpress user:

```json
{
  "name": "my_node",
  "mysql": {"server_root_password": "Ch4ng3me"},
  "wordpress": {"db_password": "wordpresssecuritysucks"},
  "run_list": [ "recipe[systest]" ]
}

```

License and Authors
-------------------
Authors: me! 
