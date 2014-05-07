# Simply installs the Mcollective agent on the master and nodes.
# No spaces allowed in $action_name (defaults to $title) to keep filename and mco/LM sane.

define runyer::windows_command (
    $command, # the command to run
    $description  = "Runs ${command} on windows agents",
    $action_name  = $title,
    $ensure       = 'present', # 'present' or 'absent'
    $author_name  = $runyer::author_name,
    $author_email = $runyer::author_email,
    $license      = $runyer::license,
    $version      = $runyer::version,
    $project_url  = $runyer::project_url,
    $timeout      = $runyer::timeout,
    $validation   = $runyer::validation,
    $args_length  = $runyer::args_length,
    $args         = false,
  ) {

  # The base class must be included first because it is used by parameter defaults
  if ! defined(Class['runyer']) {
    fail('You must include the runyer base class before using any runyer defined resources')
  }

  validate_re($action_name, '^\S*$', 'action_name param may not contain spaces')
  validate_re($ensure, ['present', 'absent'], 'ensure param must be \'absent\' or \'present\'')
  validate_re($timeout, '^\d*$', 'timeout param must be an integer (number of seconds)')
  validate_bool($args)
  $activate_condition = 'Facts["kernel"] == "windows"'
  $cmd_prefix = 'cmd /c'
  $ddl_file    = template('runyer/ddl.erb')
  $rb_file     = template('runyer/rb.erb')
   
  if $::kernel == 'windows' {

    file { "C:/ProgramData/PuppetLabs/mcollective/etc/plugins/mcollective/agent/${action_name}.ddl":
      ensure  => $ensure,
      owner   => Administrator,
      group   => Administrators,
      mode    => '0644',
      content => $ddl_file,
      notify  => Service['pe-mcollective'],
    }

    file { "C:/ProgramData/PuppetLabs/mcollective/etc/plugins/mcollective/agent/${action_name}.rb":
      ensure  => $ensure,
      owner   => Administrator,
      group   => Administrators,
      mode    => '0644',
      content => $rb_file,
      notify  => Service['pe-mcollective'],
    }

  }

  # For the Puppet Enterprise Master server
  elsif $::kernel == 'Linux' and
    ($settings::server == $::fqdn or
     $settings::server == $::hostname or
     $settings::server == $::ec2_hostname)
  {

    file { "/opt/puppet/libexec/mcollective/mcollective/agent/${action_name}.ddl":
      ensure  => $ensure,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => $ddl_file,
      notify  => Service['pe-mcollective'],
    }

    file { "/opt/puppet/libexec/mcollective/mcollective/agent/${action_name}.rb":
      ensure  => $ensure,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => $rb_file,
      notify  => Service['pe-mcollective'],
    }

  }

  else {
    notify { "runyer::windows_command ${action_name} only supported on Linux master and Windows agent nodes": }
  }

}
