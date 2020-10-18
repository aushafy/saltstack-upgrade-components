stop_salt_master:
  service.stop:
    - name: salt-master

saltstack_amazon_repo:
  pkgrepo.managed:
    - humanname: SaltStack repo for Amazon Linux 2
    - baseurl: https://repo.saltstack.com/py3/amazon/2/$basearch/archive/3001.1
    #- comments:
    #    - 'https://repo.saltstack.com/index.html#amzn'
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/SALTSTACK-GPG-KEY
    - require_in:
      - pkg: salt-master

updates_repo:
  cmd.run:
    - name: 'yum update -y'
    - user: root
    - group: root
    - require: 
      - saltstack_amazon_repo

install_updates:
  pkg.installed:
    - name: salt-master 
    - version: 3001.1-1.amzn2
    - order: last
    - require:
      - updates_repo

restart_master:
  cmd.run:
    - name: 'salt-run salt.cmd service.restart salt-master'
    - user: root
    - group: root
    - require:
      - install_updates
