class mysql {
  package { 'mysql-server':
    ensure => installed,
  }

  service { 'mysql':
    ensure     => running,
    enable     => true,
  }

  file { '/tmp/init-wordpress.sql':
    ensure  => file,
    source  => 'puppet:///modules/mysql/init-wordpress.sql',
    require => Package['mysql-server'],
  }

  exec { 'initialize-wordpress-db':
    command => 'mysql < /tmp/init-wordpress.sql',
    unless  => 'mysql -e "USE wordpress;"',
    path    => ['/usr/bin', '/bin'],
    require => [File['/tmp/init-wordpress.sql'], Service['mysql']],
  }
}
