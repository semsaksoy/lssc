mkdir /opt/lssc
cd ..
/bin/cp -rf controllers models views console.rb env.rb run.rb /opt/lssc/
/bin/cp -n config.json /opt/lssc/

rpm -ivh setup/libyaml-0.1.3-4.el6_6.x86_64.rpm
rpm -ivh setup/ruby-2.4.9-1.el7.centos.x86_64.rpm
/bin/cp -f lssc.service /lib/systemd/system -v

cd /opt/lssc
vi config.json

systemctl start lssc
systemctl enable lssc
systemctl daemon-reload
systemctl status lssc

