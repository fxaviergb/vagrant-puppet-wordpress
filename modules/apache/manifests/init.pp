class apache {

  package { 'apache2':
    ensure => installed,
  }

  service { 'apache2':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    restart => "/usr/sbin/apachectl configtest && /usr/sbin/service apache2 reload",
  }

  file { '/etc/apache2/sites-available/wordpress.conf':
    ensure  => file,
    content => template('apache/virtual-hosts.conf.erb'),
    require => Package['apache2'],
  }

  exec { 'disable-default-site':
    command => 'a2dissite 000-default', # Deshabilita el sitio por defecto de apache
    unless  => 'test ! -L /etc/apache2/sites-enabled/000-default.conf', # siempre y cuando ese sitio se encuentre activo
    path    => ['/usr/bin', '/usr/sbin', '/bin', '/sbin'],
    require => File['/etc/apache2/sites-available/wordpress.conf'],
    notify  => Service['apache2'],
  }

  exec { 'enable-wordpress-site':
    command => 'a2ensite wordpress',
    path    => ['/usr/bin', '/usr/sbin', '/bin', '/sbin'],
    require => File['/etc/apache2/sites-available/wordpress.conf'],
    notify  => Service['apache2'],
  }
}
