runyer
======
Automagically create mco/Live Management tasks for POSIX or Windows machines.

Put stuff on master and agents. Use a group!

POSIX nodes can return the results of stdout. Windows nodes can't right now. Windows is fire and forget!


    class acts {
 
      runyer::posix_command { 'ls':
        command => 'ls -al',
      }
 
      runyer::posix_command { 'du':
        command => 'du -k',
      }
 
      runyer::windows_command { 'stuff':
        command => 'mkdir c:/foobar',
      }
 
    }
