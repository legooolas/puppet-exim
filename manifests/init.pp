class exim ( 
  $qualify_domain,
  $listen_interfaces       = [ '127.0.0.1' ],
  $accept_hosts            = [ '127.0.0.1' ],
  $redirect_root           = undef,
  $extra_hostnames         = [],
  $redirect_root_usernames = [],
  $direct_delivery         = false,
  $rewrites                = {},
  $smarthost               = undef,
  $port                    = '25',
  $dkim_disable_verify     = false,
)
{
  # TODO : Better distro support rather than specifying in here explicitly...
  case $::osfamily {
    'RedHat': {
      $packages_install        = [ 'exim' ],
      $packages_remove         = [ 'sendmail', 'postfix', 'sendmail-cf' ],
      $service_name            = 'exim',
      $config                  = '/etc/exim/exim.conf',
    },
    'Debian': {
      $packages_install        = [ 'exim4' ],
      $packages_remove         = [ 'sendmail', 'postfix' ],
      $service_name            = 'exim4',
      $config                  = '/etc/exim4/exim4.conf',
    },
    default: {
      fail("Module ${module_name} is not supported on ${::osfamily} yet!")
    }
  }

  # Install new before removing unwanted as many things depend on there being an MTA:
  package { $packages_install:
    ensure => present
  }
  ->
  package { $packages_remove:
    ensure => absent
  }
  ->
  file { "exim.conf":
    mode => '644', owner => root, group => root,
    path => $config,
    content => template('exim/exim.conf'),
  }
  ~>
  service { $service_name:
    ensure => running,
    enable => true,
  }
}

