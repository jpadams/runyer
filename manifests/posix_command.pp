# Simply installs the Mcollective agent on the master and nodes.
# No spaces allowed in title to keep filename and mco/LM sane.

define runyer::posix_command (
  $command, # the command to run
  $description = "Runs ${command} on posix agents"
  ) {

  $ddl_file    = template('runyer/posix_ddl.erb')
  $rb_file     = template('runyer/posix_rb.erb')
  $action_name = $title

  # For the Unix/Linux agents and the Puppet Enterprise Master server
  if $::kernel != 'windows' {

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
    notify { "runyer::posix_command ${action_name} only supported on Linux master and Unix/Linux agent nodes": }
  }

}
