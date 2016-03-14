# Simply installs the Mcollective agent on the master and nodes.
# No spaces allowed in $action_name (defaults to $title) to keep filename and mco sane.

define runyer::nix_command (
    String $command, # the command to run
    String $description               = "Runs ${command} on *nix agents",
    String $action_name               = $title,
    Enum['present', 'absent'] $ensure = 'present',
    String $author_name               = $runyer::author_name,
    String $author_email              = $runyer::author_email,
    String $license                   = $runyer::license,
    String $version                   = $runyer::version,
    String $project_url               = $runyer::project_url,
    Integer $timeout                  = $runyer::timeout,
  ) {

  # The base class must be included first because it is used by parameter defaults
  if ! defined(Class['runyer']) {
    fail('You must include the runyer base class before using any runyer defined resources')
  }

  validate_re($action_name, '^\S*$', 'action_name param may not contain spaces')
  $activate_condition = 'Facts["kernel"] != "windows"'
  $cmd_prefix = ''
  $ddl_file = template('runyer/ddl.erb')
  $rb_file = template('runyer/rb.erb')

  # For the Unix/Linux agents and the Puppet Enterprise Master Linux server
  if $::kernel != 'windows' {

    file { "/opt/puppetlabs/mcollective/plugins/mcollective/agent/${action_name}.ddl":
      ensure  => $ensure,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => $ddl_file,
      notify  => Service['mcollective'],
    }

    file { "/opt/puppetlabs/mcollective/plugins/mcollective/agent/${action_name}.rb":
      ensure  => $ensure,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => $rb_file,
      notify  => Service['mcollective'],
    }

  }

  else {
    notify { "runyer::nix_command ${action_name} only supported on Linux master and Unix/Linux agent nodes": }
  }

}
