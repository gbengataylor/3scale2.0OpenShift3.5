subscription-manager register --username $RH_USER_NAME
subscription-manager attach --pool=8a85f9815c9ec05f015c9f84fc70393d
subscription-manager repos --disable="*"
subscription-manager repos --enable="rhel-7-server-rpms" --enable="rhel-7-server-extras-rpms" --enable="rhel-7-server-ose-3.5-rpms" --enable="rhel-7-fast-datapath-rpms"
