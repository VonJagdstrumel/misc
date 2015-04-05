# Allow password authentication, disable reverse dns lookup, remove motd and restart ssh
sed -i -r 's/^#?PasswordAuthentication (yes|no)$/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo '' >> /etc/ssh/sshd_config
echo 'UseDNS no' >> /etc/ssh/sshd_config
echo '' > /etc/motd
service ssh restart

# Configure aptitude to use dotdeb and backports
wget http://www.dotdeb.org/dotdeb.gpg
apt-key add dotdeb.gpg
rm dotdeb.gpg
cat <<EOF >> /etc/apt/sources.list

deb http://ftp.debian.org/debian/ wheezy-backports main
deb-src http://ftp.debian.org/debian/ wheezy-backports main

deb http://packages.dotdeb.org/ wheezy all
deb-src http://packages.dotdeb.org/ wheezy all
deb http://packages.dotdeb.org/ wheezy-php56 all
deb-src http://packages.dotdeb.org/ wheezy-php56 all
EOF

# Lower timeout for aptitude
echo 'Acquire::http::Timeout "10";' > /etc/apt/apt.conf.d/99timeout
echo 'Acquire::ftp::Timeout "10";' >> /etc/apt/apt.conf.d/99timeout

# Update, upgrade and cleanup
apt-get -y purge rpcbind
apt-get -y update
apt-get -y dist-upgrade
apt-get -y autoclean
apt-get -y autoremove

# Install required software
apt-get -y install binutils build-essential chkconfig curl dfc dkms gawk git htop iftop iptraf linux-headers-amd64 nethogs rcconf screen subversion sudo sysstat unzip
apt-get -y install lua luarocks
apt-get -y install php-pear php5-cli php5-common php5-curl php5-fpm php5-gd php5-gmp php5-mcrypt php5-mysqlnd php5-pgsql php5-readline php5-sqlite php5-xsl
apt-get -y install postfix postgresql
apt-get -y install python python-pip
apt-get -y install ruby

# Grant sudo to vagrant user
echo '' >> /etc/sudoers
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Switch to vagrant user
su vagrant
cd

# Add insecure vagrant keys
wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
mkdir .ssh
chmod 700 .ssh
cat vagrant.pub > .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
rm vagrant.pub

# Enable aliases, color prompt and install liquidprompt
sed -i -r 's/^( *)# ?(alias)/\1\2/g' .bashrc
git clone https://github.com/nojhan/liquidprompt.git
cat <<EOF >> .bashrc

LP_ENABLE_TEMP=0
LP_ENABLE_BATT=0

# Only load Liquid Prompt in interactive shells, not from a script or from scp
[[ $- = *i* ]] && source ~/liquidprompt/liquidprompt
EOF
