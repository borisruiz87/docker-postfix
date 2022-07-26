#!/bin/bash

# Start the first process
./rsyslogd -n &

# Start the second process
./usr/sbin/postfix start-fg

# Wait for any process to exit
wait -n
  
# Exit with status of process that exited first
exit $?
