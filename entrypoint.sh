#!/bin/bash

postmap /etc/postfix/domains/transport
postmap /etc/postfix/domains/relay_domains
postmap /etc/postfix/domains/virtual
postalias /etc/postfix/aliases


exec "$@"
