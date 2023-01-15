#!/bin/bash

cp /etc/postfix/domains/transport /etc/postfix/ && postmap /etc/postfix/transport
cp /etc/postfix/domains/relay_domains /etc/postfix/ && postmap /etc/postfix/relay_domains
cp /etc/postfix/domains/virtual /etc/postfix/ && postmap /etc/postfix/virtual
postalias /etc/postfix/aliases


exec "$@"
