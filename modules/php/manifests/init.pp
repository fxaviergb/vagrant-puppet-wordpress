class php {
  package { ['php', 'php-mysql', 'libapache2-mod-php', 'php-curl', 'php-gd']:
    ensure  => installed,
    require => Package['apache2'],
  }
}
