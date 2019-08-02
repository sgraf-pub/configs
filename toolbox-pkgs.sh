#!/usr/bin/bash
sudo dnf update -y
sudo dnf install -y \
    mc \
    vim \
    lftp \
    htop \
    krb5-workstation \
    lm_sensors \
    cyrus-sasl-gssapi \
    openldap-clients \
    gnome-tweaks \
    pciutils \
    bind-utils \
    ansible \
    policycoreutils \
    smartmontools \
    lshw \
    rpm-build \
    screenfetch

