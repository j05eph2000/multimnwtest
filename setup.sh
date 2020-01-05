#/bin/bash

cd ~
echo "****************************************************************************"
echo "* Ubuntu 16.04 is the recommended opearting system for this install.       *"
echo "*                                                                          *"
echo "*                                                                          *"
echo "****************************************************************************"
echo && echo && echo
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!                                                 !"
echo "! Make sure you double check before hitting enter !"
echo "!                                                 !"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo && echo && echo



echo "Do you want to install all needed dependencies (no if you did it before)? [y/n]"
read DOSETUP

if [ $DOSETUP = "y" ]  
then
 
apt-get update -y
#DEBIAN_FRONTEND=noninteractive apt-get update 
#DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y -qq upgrade
apt install -y software-properties-common 
apt-add-repository -y ppa:bitcoin/bitcoin 
apt-get update -y
apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" make software-properties-common \
build-essential libtool autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev libboost-program-options-dev \
libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git wget pwgen curl libdb4.8-dev bsdmainutils libdb4.8++-dev \
libminiupnpc-dev libgmp3-dev ufw pkg-config libevent-dev  libdb5.3++ unzip 



fallocate -l 100G /wswapfile
chmod 600 /wswapfile
mkswap /wswapfile
swapon /wswapfile
swapon -s
echo "/wswapfile none swap sw 0 0" >> /etc/fstab

fi
  #wget https://github.com/wagerr/wagerr/releases/download/v3.0.1/wagerr-3.0.1-x86_64-linux-gnu.tar.gz
  
  #wget https://github.com/wagerr/Wagerr-Blockchain-Snapshots/releases/download/Block-826819/826819.zip -O bootstrap.zip
  export fileid=1VqdvSvolhpwOoYgaoSHkZkmRla2kl27R
  export filename=wagerr-3.1.0-x86_64-linux-gnu.tar.gz
  wget --save-cookies cookies.txt 'https://docs.google.com/uc?export=download&id='$fileid -O- \
     | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1/p' > confirm.txt

  wget --load-cookies cookies.txt -O $filename \
     'https://docs.google.com/uc?export=download&id='$fileid'&confirm='$(<confirm.txt)

  export fileid=13rUf6dApIrtyWuiBvLWwRARJh1opG6Xj
  export filename=wbootstrap.zip
  wget --save-cookies cookies.txt 'https://docs.google.com/uc?export=download&id='$fileid -O- \
     | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1/p' > confirm.txt

  wget --load-cookies cookies.txt -O $filename \
     'https://docs.google.com/uc?export=download&id='$fileid'&confirm='$(<confirm.txt)
  tar xvzf wagerr-3.1.0-x86_64-linux-gnu.tar.gz
  
  
  chmod +x wagerr-3.1.0/bin/*
  sudo mv  wagerr-3.1.0/bin/* /usr/local/bin
  rm -rf wagerr-3.1.0-x86_64-linux-gnu.tar.gz

  sudo apt install -y ufw
  sudo ufw allow ssh/tcp
  sudo ufw limit ssh/tcp
  sudo ufw logging on
  echo "y" | sudo ufw enable
  sudo ufw status

  mkdir -p ~/bin
  echo 'export PATH=~/bin:$PATH' > ~/.bash_aliases
  source ~/.bashrc
  
  touch masternode.conf


 ## Setup conf
 IP=$(curl -s4 api.ipify.org)
 mkdir -p ~/bin
 echo ""
 echo "Configure your masternodes now!"
 echo "Detecting IP address:$IP"

echo ""
echo "How many nodes do you want to create on this server? [min:1 Max:20]  followed by [ENTER]:"
read MNCOUNT


for i in `seq 1 1 $MNCOUNT`; do
  #echo ""
  #echo "Enter alias for new node"
  #read ALIAS  

  #echo ""
  #echo "Enter port for node $ALIAS"
  #read PORT

  #echo ""
  #echo "Enter masternode private key for node $ALIAS"
  #read PRIVKEY
  
  ALIAS=$'mn'$i
  PORT=$[56000+i]
  
  RPCPORT=$(($PORT*10))
  echo "The RPC port is $RPCPORT"

  ALIAS=${ALIAS}
  CONF_DIR=~/.wagerr_$ALIAS
  
  # Create swap
  #fallocate -l 1.5G /swapfile$i
  #chmod 600 /swapfile$i
  #mkswap /swapfile$i
  #swapon /swapfile$i
  #swapon -s
  #echo "/swapfile$i none swap sw 0 0" >> /etc/fstab


  # Create scripts
  echo '#!/bin/bash' > ~/bin/wagerrd_$ALIAS.sh
  echo "wagerrd -daemon -conf=$CONF_DIR/wagerr.conf -datadir=$CONF_DIR "'$*' >> ~/bin/wagerrd_$ALIAS.sh
  echo '#!/bin/bash' > ~/bin/wagerr-cli_$ALIAS.sh
  echo "wagerr-cli -conf=$CONF_DIR/wagerr.conf -datadir=$CONF_DIR "'$*' >> ~/bin/wagerr-cli_$ALIAS.sh
  echo '#!/bin/bash' > ~/bin/wagerr-tx_$ALIAS.sh
  echo "wagerr-tx -conf=$CONF_DIR/wagerr.conf -datadir=$CONF_DIR "'$*' >> ~/bin/wagerr-tx_$ALIAS.sh 
  chmod 755 ~/bin/wagerr*.sh

  mkdir -p $CONF_DIR
  unzip  wbootstrap.zip -d $CONF_DIR
  echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` >> wagerr.conf_TEMP
  echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> wagerr.conf_TEMP
  echo "rpcallowip=127.0.0.1" >> wagerr.conf_TEMP
  echo "port=$PORT" >> wagerr.conf_TEMP
  echo "listen=1" >> wagerr.conf_TEMP
  echo "server=1" >> wagerr.conf_TEMP
  echo "daemon=1" >> wagerr.conf_TEMP
  echo "addnode=101.160.14.230" >> wagerr.conf_TEMP
  echo "addnode=104.248.38.16" >> wagerr.conf_TEMP
  echo "addnode=108.61.223.36" >> wagerr.conf_TEMP
  echo "addnode=110.47.182.205" >> wagerr.conf_TEMP
  echo "addnode=115.188.31.96" >> wagerr.conf_TEMP
  echo "addnode=128.199.184.113" >> wagerr.conf_TEMP
  echo "addnode=134.209.148.133" >> wagerr.conf_TEMP
  echo "addnode=134.209.155.64" >> wagerr.conf_TEMP
  echo "addnode=134.209.28.174" >> wagerr.conf_TEMP
  echo "addnode=139.99.159.178" >> wagerr.conf_TEMP
  echo "addnode=142.93.132.177" >> wagerr.conf_TEMP
  echo "addnode=142.93.148.215" >> wagerr.conf_TEMP
  echo "addnode=142.93.156.97" >> wagerr.conf_TEMP
  echo "addnode=142.93.230.225" >> wagerr.conf_TEMP
  echo "addnode=149.90.37.197" >> wagerr.conf_TEMP
  echo "addnode=157.230.245.81" >> wagerr.conf_TEMP
  echo "addnode=159.65.53.49" >> wagerr.conf_TEMP
  echo "addnode=159.69.195.149" >> wagerr.conf_TEMP
  echo "addnode=159.89.169.209" >> wagerr.conf_TEMP
  echo "addnode=163.172.51.207" >> wagerr.conf_TEMP
  echo "addnode=165.22.17.223" >> wagerr.conf_TEMP
  echo "addnode=165.22.195.243" >> wagerr.conf_TEMP
  echo "addnode=165.22.217.176" >> wagerr.conf_TEMP
  echo "addnode=165.22.232.137" >> wagerr.conf_TEMP
  echo "addnode=165.22.234.242" >> wagerr.conf_TEMP
  echo "addnode=165.22.58.21" >> wagerr.conf_TEMP
  echo "addnode=167.71.208.148" >> wagerr.conf_TEMP
  echo "addnode=167.71.222.120" >> wagerr.conf_TEMP
  echo "addnode=167.71.62.63" >> wagerr.conf_TEMP
  echo "addnode=167.71.72.217" >> wagerr.conf_TEMP
  echo "addnode=167.71.72.30" >> wagerr.conf_TEMP
  echo "addnode=167.99.138.63" >> wagerr.conf_TEMP
  echo "addnode=167.99.185.183" >> wagerr.conf_TEMP
  echo "addnode=170.250.57.160" >> wagerr.conf_TEMP
  echo "addnode=172.83.8.194" >> wagerr.conf_TEMP
  echo "addnode=173.239.232.165" >> wagerr.conf_TEMP
  echo "addnode=178.128.117.6" >> wagerr.conf_TEMP
  echo "addnode=178.128.174.170" >> wagerr.conf_TEMP
  echo "addnode=178.128.29.104" >> wagerr.conf_TEMP
  echo "addnode=178.62.111.122" >> wagerr.conf_TEMP
  echo "addnode=178.62.30.244" >> wagerr.conf_TEMP
  echo "addnode=178.76.223.124" >> wagerr.conf_TEMP
  echo "addnode=185.80.130.54" >> wagerr.conf_TEMP
  echo "addnode=188.166.22.50" >> wagerr.conf_TEMP
  echo "addnode=188.42.252.253" >> wagerr.conf_TEMP
  echo "addnode=193.28.233.91" >> wagerr.conf_TEMP
  echo "addnode=198.199.75.101" >> wagerr.conf_TEMP
  echo "addnode=206.189.125.215" >> wagerr.conf_TEMP
  echo "addnode=206.189.53.236" >> wagerr.conf_TEMP
  echo "addnode=209.250.248.176" >> wagerr.conf_TEMP
  echo "addnode=213.142.96.220" >> wagerr.conf_TEMP
  echo "addnode=213.194.177.65" >> wagerr.conf_TEMP
  echo "addnode=24.27.40.198" >> wagerr.conf_TEMP
  echo "addnode=45.76.221.227" >> wagerr.conf_TEMP
  echo "addnode=46.101.183.58" >> wagerr.conf_TEMP
  echo "addnode=47.185.158.205" >> wagerr.conf_TEMP
  echo "addnode=68.183.192.142" >> wagerr.conf_TEMP
  echo "addnode=68.183.193.228" >> wagerr.conf_TEMP
  echo "addnode=68.183.198.193" >> wagerr.conf_TEMP
  echo "addnode=68.183.2.165" >> wagerr.conf_TEMP
  echo "addnode=68.183.219.48" >> wagerr.conf_TEMP
  echo "addnode=71.202.226.56" >> wagerr.conf_TEMP
  echo "addnode=75.83.187.235" >> wagerr.conf_TEMP
  echo "addnode=85.165.245.64" >> wagerr.conf_TEMP
  echo "addnode=90.185.118.67" >> wagerr.conf_TEMP
  echo "addnode=91.204.138.4" >> wagerr.conf_TEMP
  echo "addnode=91.204.190.190" >> wagerr.conf_TEMP
  echo "addnode=95.183.51.133" >> wagerr.conf_TEMP
  echo "addnode=95.216.26.28" >> wagerr.conf_TEMP
  echo "addnode=95.216.46.167" >> wagerr.conf_TEMP
  echo "addnode=95.216.74.6" >> wagerr.conf_TEMP
  echo "addnode=95.217.62.35" >> wagerr.conf_TEMP
  
  cat << EOF > /etc/systemd/system/wagerr_$ALIAS.service
[Unit]
Description=wagerr_$ALIAS service
After=network.target
[Service]
User=root
Group=root
Type=forking
ExecStart=/usr/local/bin/wagerrd -daemon -conf=$CONF_DIR/wagerr.conf -datadir=$CONF_DIR
ExecStop=/usr/local/bin/wagerr-cli -conf=$CONF_DIR/wagerr.conf -datadir=$CONF_DIR stop
Restart=always
PrivateTmp=true
TimeoutStartSec=10m
StartLimitInterval=0
[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 10
  systemctl start wagerr_$ALIAS.service
  systemctl enable wagerr_$ALIAS.service >/dev/null 2>&1
  sleep 30
  
  
  PRIVKEY=$(wagerr-cli -conf=$CONF_DIR/wagerr.conf -datadir=$CONF_DIR createmasternodekey)
  systemctl stop wagerr_$ALIAS.service
  
  sleep 10
  #rm -rf ~/.wagerr_$ALIAS/wagerr.conf
  
  echo "maxconnections=256" >> wagerr.conf_TEMP
  echo "masternode=1" >> wagerr.conf_TEMP
  echo "" >> wagerr.conf_TEMP

  echo "" >> wagerr.conf_TEMP
  
  echo "rpcport=$RPCPORT" >> wagerr.conf_TEMP
  echo "logtimestamps=1" >> wagerr.conf_TEMP
  echo "masternodeaddr=$IP:55002" >> wagerr.conf_TEMP
  echo "masternodeprivkey=$PRIVKEY" >> wagerr.conf_TEMP
  sudo ufw allow $PORT/tcp
  
  echo "$ALIAS $IP:55002 $PRIVKEY " >> masternode.conf
  
  mv wagerr.conf_TEMP $CONF_DIR/wagerr.conf
  
  #sh ~/bin/wagerrd_$ALIAS.sh
  systemctl start wagerr_$ALIAS.service
  systemctl enable wagerr_$ALIAS.service >/dev/null 2>&1
  sleep 30
  echo -e " Wait for $[100+$i*10] secs "
  date
  sleep $[100+$i*10]
  date
  
  #(crontab -l 2>/dev/null; echo "@reboot sh ~/bin/wagerrd_$ALIAS.sh") | crontab -
#	   (crontab -l 2>/dev/null; echo "@reboot sh /root/bin/wagerrd_$ALIAS.sh") | crontab -
#	   sudo service cron reload
  
done

rm -rf bootstrap.zip
