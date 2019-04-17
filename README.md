# classroom_support_pi

## Initial install
If the pi still has the default password of raspberry, change it with passwd

* git clone https://github.com/kfriedberg/classroom_support_pi.git
* cd classroom_support_pi
* cp classroom_support_pi.conf.example classroom_support_pi.conf
* nano classroom_support_pi.conf

Fill in values in classroom_support_pi.conf

* chmod +x install.sh
* sudo ./install.sh

Reboot


## Update
* cd classroom_support_pi
* sudo git reset --hard
* sudo git pull
* sudo chmod +x install.sh
* sudo ./install.sh
