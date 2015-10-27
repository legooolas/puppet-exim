class exim ( 
  $qualify_domain,
  $listen_interfaces       = [ '127.0.0.1' ],
  $accept_hosts            = [ '127.0.0.1' ],
  $redirect_root           = undef,
  $extra_hostnames         = [],
  $redirect_root_usernames = [],
  $direct_delivery         = false,
  $packages_install        = [],
  $packages_remove         = [],
  # TODO : Debian/Ubuntu support to re-add via setting these...
  $service_name            = "exim",
  $config                  = '/etc/exim/exim.conf',
  $rewrites                = {},
  $smarthost               = undef,
  $port                    = '25',
  $dkim_disable_verify     = false,
)
{
  # Install new before removing unwanted as many things depend on there being an MTA:
  package { $packages_install:
    ensure => present
  }
  ->
  package { $packages_remove:
    ensure => absent
  }
  ->
  templatedfile { "exim.conf":
    mode => '644', owner => root, group => root,
    path => $config,
    module => "exim",
  }
  ~>
  service { $service_name:
    ensure => running,
    enable => true,
  }
}

