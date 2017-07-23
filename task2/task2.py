import sys
import paramiko
import os
from pssh.pssh_client import ParallelSSHClient

if len(sys.argv) < 2:
        print('No hostIDs mentioned')
else:
        hostList = sys.argv[1].split(',')
        #we will be adding it automatically to the list of known hosts
        for hostId in hostList:
                ssh = paramiko.SSHClient()
                ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
                ssh.load_host_keys(os.path.expanduser(os.path.join("~", ".ssh", "known_hosts")))
        #connecting and executing the command remotely
        client = ParallelSSHClient(hostList, user="ubuntu")
        cmd = input('Pl enter the command to be executed on the remote host ')
        output = client.run_command(cmd, stop_on_errors=False)
        for host in output:
                for line in output[host]['stdout']:
                        print("Host %s - output: %s" % (host, line))
                for line in output[host]['stderr']:
                        print("Host %s - output: %s" % (host,line))