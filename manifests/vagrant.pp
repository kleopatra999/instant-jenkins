node default {
  include stdlib
  include firewall

  notice("Hello from ${hostname}")

  firewall {
    '000 accept all icmp':
      proto   => 'icmp',
      action  => 'accept';

    '001 accept all to lo interface':
      proto   => 'all',
      iniface => 'lo',
      action  => 'accept';

    '002 accept related established rules':
      proto   => 'all',
      ctstate => ['RELATED', 'ESTABLISHED'],
      action  => 'accept';

    '100 allow ssh access':
      port   => [22],
      proto  => tcp,
      action => accept;

    '999 drop all':
      proto   => 'all',
      action  => 'drop';
  }
}

node /^.*jenkinsmaster$/ inherits default {
  class {
    'apt':
      always_apt_update => true;

    'jenkins':
        configure_firewall => false;
  }

  Package {
    require => Class['apt']
  }
}