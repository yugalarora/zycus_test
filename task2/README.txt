Requirements

python 3.x
sudo apt-get install python3-dev
pip3 install cryptography
pip3 install paramiko
pip3 install parallel-ssh

Usage:

python3 python.py <comma separated hosts>


Assumes passwordless connectivity - refer to the references 
Assumes the usernames to be ubuntu for all hosts

Ref: 

1. http://www.tecmint.com/ssh-passwordless-login-using-ssh-keygen-in-5-easy-steps/
2. http://www.linuxproblem.org/art_9.html