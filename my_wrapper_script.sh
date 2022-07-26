#!/bin/bash

# Start the first process
./usr/sbin/postfix start-fg &
  
# Start the second process
./rsyslogd -n &
  
# Wait for any process to exit
wait -n
  
# Exit with status of process that exited first
exit $?
