#!/bin/bash

source /build/docker-yodle-base/profile

# Changes inspired by https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
# Fix chroot
# Speed up dpkg
dpkg-divert --local --rename --add /usr/bin/ischroot
ln -sf /bin/true /usr/bin/ischroot
mkdir -p /etc/container_environment
echo -n no > /etc/container_environment/INITRD
echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/02apt-speedup

# Fix some issues with APT packages.
# See https://github.com/dotcloud/docker/issues/1024
dpkg-divert --local --rename --add /sbin/initctl && ln -sf /bin/true /sbin/initctl

$apt_get update

# Add tools for apt https and repo mgmt
$apt_get install apt-transport-https ca-certificates software-properties-common

# Clean up locales (we only need en_US.UTF8)
echo localepurge localepurge/nopurge select en_US.UTF-8   | /usr/bin/debconf-set-selections
echo localepurge localepurge/use-dpkg-feature select true | /usr/bin/debconf-set-selections
$apt_get install localepurge
mkdir -p /var/lib/locales/supported.d
echo "en_US UTF-8" > /var/lib/locales/supported.d/en
locale-gen en_US
localepurge

$apt_get install rsync telnet screen man wget git
