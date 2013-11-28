# Simply installs the Mcollective agent on the master and nodes.
# No spaces allowed in title to keep filename and mco/LM sane.

define runyer::windows_command (
  $command, # the command to run
  $description = "Runs ${command} on windows agents"
  ) {

  $ddl_file = template('runyer/win_ddl.erb')
  $rb_file  = template('runyer/win_rb.erb')

  if $::kernel == 'windows' {

    file { "C:/ProgramData/PuppetLabs/mcollective/etc/plugins/mcollective/agent/${title}.ddl":
      ensure  => file,
      owner   => Administrator,
      group   => Administrators,
      mode    => '0644',
      content => $ddl_file,
      notify  => Service['pe-mcollective'],
    }

    file { "C:/ProgramData/PuppetLabs/mcollective/etc/plugins/mcollective/agent/${title}.rb":
      ensure  => file,
      owner   => Administrator,
      group   => Administrators,
      mode    => '0644',
      content => $rb_file,
      notify  => Service['pe-mcollective'],
    }

  }

  # For the Puppet Enterprise Master server
  elsif $::kernel == 'Linux' and
    ($::puppet_server == $::fqdn or
    $::puppet_server == $::hostname)
  {

    file { "/opt/puppet/libexec/mcollective/mcollective/agent/${title}.ddl":
      ensure  => file,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => $ddl_file,
      notify  => Service['pe-mcollective'],
    }

    file { "/opt/puppet/libexec/mcollective/mcollective/agent/${title}.rb":
      ensure  => file,
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
