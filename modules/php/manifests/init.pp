class php {
  package { ['php', 'php-mysql', 'libapache2-mod-php', 'php-curl', 'php-gd']:
    ensure  => installed,
    require => Package['apache2'], # Asegura que Apache esté instalado antes de PHP
  }
}
