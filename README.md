runyer
======
For PE 3.2.x and above

Automagically create mco/Live Management tasks for *nix or Windows machines.

Make modules (for example see my 'acts' module's linux.pp and win.pp below) with your desired actions. Classify master and agents. A Windows node will skip a *nix action and vice versa.

**No spaces allowed in $action_name param (defaults to resource $title) to keep filename and mco/LM sane. Best to use [a-z] and '_' (underscore).** For now anyway.
```puppet
# a simple class with two actions. apply to master and linux agents.
class acts {
  include runyer

  runyer::nix_command { 'ls':
    command => 'ls -al',
  }

  runyer::nix_command { 'du':
    command => 'du -k',
  }
}
```
A more complicated example (repo <https://github.com/jpadams/acts>):
```puppet
# init.pp for defaults
class acts {
  #set your param defaults here or use runyer's defaults
  
  #include runyer
  class { 'runyer':
    author_name  => 'Jeremy Adams',
    author_email => 'jeremy@puppetlabs.com',
    license      => 'Apache v2',
    version      => '1.0',
    project_url  => 'http://www.puppetlabs.com',
    timeout      => 25,
  }
}
======
# master.pp for the master
class acts::master {
  include acts::linux
  include acts::win
}
======
# linux.pp for the linux nodes
class acts::linux {
  include acts

  runyer::nix_command { 'ls':
    command => 'ls -al',
  }
 
  runyer::nix_command { 'du':
    command => 'du -k',
  }
}
======
# win.pp for the windows nodes
class acts::win {
  include acts
 
  runyer::windows_command { 'stuff':
    command => 'mkdir c:\foobar',
  }
      
  runyer::windows_command { 'stuff and nonsense':
    command     => 'mkdir c:\jaberwocky',
    action_name => 's_and_n',
  }
 
  runyer::windows_command { 'gone':
    ensure  => 'absent',
    command => 'mkdir c:\you_later',
  }
}
```

After you run puppet agent, your nodes (including the master, if you listened to me above) will have the necessary ddl and rb files. Just browse to the Live Management tab and go! Alternatively, use the mco command line.

    # su - peadmin
    
    $ mco rpc stuff run -I mywindowsnode


