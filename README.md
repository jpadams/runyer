runyer
======
Automagically create mco/Live Management tasks for POSIX or Windows machines.

Put stuff on master and agents. Use a group!

POSIX nodes can return the results of stdout. Windows nodes can't right now. Windows is fire and forget!

**_No spaces allowed in title to keep filename and mco/LM sane._** For now anyway.

    class acts {
 
      runyer::posix_command { 'ls':
        command => 'ls -al',
      }
 
      runyer::posix_command { 'du':
        command => 'du -k',
      }
 
      runyer::windows_command { 'stuff':
        command => 'mkdir c:\foobar',
      }
 
    }

After you run puppet agent, your nodes (including the master, if you listened to me above) will have the necessary ddl and rb files. Just browse to the Live Management tab and go! Alternatively, use the mco command line.

    # su - peadmin
    
    $ mco rpc stuff run -I mywindowsnode
