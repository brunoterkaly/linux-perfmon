apt-get update
apt-get --assume-yes upgrade
sudo apt-get --assume-yes update  
sudo apt-get --assume-yes install freetds-dev freetds-bin  
sudo apt-get --assume-yes install python-dev python-pip  
sudo apt-get --assume-yes install python3-pip
pip install --upgrade pip
sudo apt-get --assume-yes install freetds-dev
sudo pip3 install PyMySQL
echo "installing tools with pymssql"
curl http://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl http://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
sudo ACCEPT_EULA=Y apt-get install msodbcsql=13.1.4.0-1 mssql-tools-14.0.3.0-1 unixodbc-dev
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc
apt-get --assume-yes update
apt-get --assume-yes install freetds-dev freetds-bin
apt-get --assume-yes install python-dev python-pip
pip install pymssql
apt --assume-yes install python3-pip
pip install --upgrade pip
pip3 install pymssql
apt-get update
apt-get --assume-yes install freetds-dev
pip3 install pymssql==2.1.1
apt-get --assume-yes install ifstat
apt-get --assume-yes install sysstat
sudo apt-get --assume-yes install iotop
