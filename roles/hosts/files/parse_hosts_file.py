#!/usr/bin/env python

import subprocess

def run(cmd):
    cmd_process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    std_output, error_output = cmd_process.communicate()
    if cmd_process.returncode != 0:
        print cmd
        print std_output
        print error_output
        sys.exit(cmd_process.returncode)
    return std_output

def main():
    # get only hostnames
    hosts_list = [host for host in run("curl -s https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/hosts.txt | grep '^0\.0\.0\.0' | awk '{ print $2 }' | rev | sort | uniq").split('\n') if host]

    # keep only parrent domains
    for index in xrange(len(hosts_list)):
        try:
            current_host = hosts_list[index]
            subdomains = []
            for subdomain in hosts_list[index+1:]:
                if subdomain.startswith('%s' % current_host):
                    if subdomain.startswith('%s.' % current_host):
                        subdomains += [subdomain]
                else:
                    break
        except IndexError:
            break

        for host in subdomains:
            hosts_list.remove(host)

    # undo rev
    hosts_list = [host[::-1] for host in hosts_list]

    with open("/etc/unbound/local.d/ads.conf", "w") as text_file:
        for host in hosts_list:
            text_file.write('local-zone: "%s" always_nxdomain\n' % host)

    with open("/etc/NetworkManager/dnsmasq.d/ads.conf", "w") as text_file:
        for host in hosts_list:
            text_file.write("address=/%s/\n" % host)

main()
