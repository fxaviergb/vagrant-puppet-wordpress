class wordpress (
  String $wordpress_path = '/var/www/html/wordpress',
) {

  package { 'wget':
    ensure => installed,
  }

  exec { 'install-wp-cli':
    command => 'curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp', # Cliente wordpress para crear posts desde consola
    path    => ['/usr/bin', '/bin'],
    creates => '/usr/local/bin/wp',
  }

  exec { 'download-wordpress':
    command => 'wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz && tar -xzvf /tmp/wordpress.tar.gz -C /var/www/html/',
    path    => ['/usr/bin', '/bin'],
    creates => "${wordpress_path}",
    require => Package['wget'],
  }

  file { "${wordpress_path}/wp-config.php":
    ensure  => file,
    content => template('wordpress/wp-config.php.erb'),
    require => Exec['download-wordpress'],
    notify  => Service['apache2'],
  }

  file { '/tmp/sample-post-puppet.html':
    ensure  => file,
    source  => 'puppet:///modules/wordpress/sample-post-puppet.html',
    require => Exec['download-wordpress'],
  }

  exec { 'set-permissions':
    command => "chown -R www-data:www-data ${wordpress_path} && chmod -R 755 ${wordpress_path}",
    path    => ['/usr/bin', '/bin'],
    require => File["${wordpress_path}/wp-config.php"],
    notify  => Service['apache2'],
  }

  exec { 'install-wordpress-core':
    command => "sudo -u www-data wp core install --url='http://localhost:8080' --title='My Master Site [FXAVIERGB]' --admin_user='admin' --admin_password='password' --admin_email='admin@example.com' --path=${wordpress_path}",
    path    => [' /usr/local/bin', '/usr/bin', '/bin'],
    require => [Exec['download-wordpress'], Exec['initialize-wordpress-db']],
  }

  file { "${wordpress_path}/wp-content/plugins/redirect-to-latest-post.php":
    ensure  => file,
    source  => 'puppet:///modules/wordpress/redirect-to-latest-post.php',
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    require => Exec['install-wordpress-core'],
  }

  exec { 'activate-redirect-plugin':
    command => "sudo -u www-data wp plugin activate redirect-to-latest-post --path=${wordpress_path}",
    path    => ['/usr/local/bin', '/usr/bin', '/bin'],
    require => File["${wordpress_path}/wp-content/plugins/redirect-to-latest-post.php"],
  }

  exec { 'install-wordpress-theme':
    command => "sudo -u www-data wp theme install astra --activate --path=${wordpress_path}",
    path    => ['/usr/local/bin', '/usr/bin', '/bin'],
    unless  => "sudo -u www-data /usr/local/bin/wp theme list --path=${wordpress_path} | grep -q 'astra.*Active'",
    require => Exec['install-wordpress-core'],
  }

  exec { 'create-wordpress-user':
    command => "sudo -u www-data wp user create fernando 'fxaviergb@gmail.com' --role=author --user_pass='securepassword' --first_name='Fernando' --last_name='Garnica' --path=${wordpress_path}",
    path    => ['/usr/local/bin', '/usr/bin', '/bin'],
    unless  => "sudo -u www-data /usr/local/bin/wp user get fernando --path=${wordpress_path}",
    require => Exec['install-wordpress-core'],
  }

  exec { 'create-devops-category':
    command => "sudo -u www-data wp term create category 'DEVOPS' --path=${wordpress_path}",
    path    => ['/usr/local/bin', '/usr/bin', '/bin'],
    unless  => "sudo -u www-data /usr/local/bin/wp term list category --path=${wordpress_path} | grep -q 'DEVOPS'",
    require => Exec['install-wordpress-core'],
  }

  exec { 'create-wordpress-post':
    command => "sudo -u www-data wp post create --post_title='Puppet for configuration management' --post_content=\"$(cat /tmp/sample-post-puppet.html)\" --post_status=publish --post_author=$(sudo -u www-data /usr/local/bin/wp user get fernando --field=ID --path=${wordpress_path}) --post_category=$(sudo -u www-data /usr/local/bin/wp term list category --field=term_id --name='DEVOPS' --path=${wordpress_path}) --path=${wordpress_path}",
    path    => ['/usr/local/bin', '/usr/bin', '/bin'],
    require => [Exec['create-wordpress-user'], Exec['create-devops-category'], File['/tmp/sample-post-puppet.html']],
  }

  exec { 'set-homepage-to-post':
    command => "sudo -u www-data wp option update show_on_front 'posts' --path=${wordpress_path}",
    path    => [' /usr/local/bin', '/usr/bin', '/bin'],
    require => Exec['create-wordpress-post'],
  }
}
