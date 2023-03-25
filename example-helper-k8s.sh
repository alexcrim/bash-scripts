#!/bin/bash

echo -e "\033[1;33mВведите адрес registry:\033[0m\r"
read address
echo -e "\033[1;33mВведите логин для registry:\033[0m\r"
read login
echo -e "\033[1;33mВведите пароль для registry:\033[0m\r"
read -s pwd
echo -ne "\033[1;33mСоздание Secret для загрузки образов\033[0m ... \r"
kubectl create secret docker-registry regcred \
  --docker-username=$login \
  --docker-password=$pwd \
  --docker-server=$address >/dev/null
echo -ne "\033[1;33mСоздание Secret для загрузки образов\033[0m ... \033[1;32mDone\033[0m\r"
echo -ne "\n"


echo -e "\033[1;33mВведите путь к pfx сертификату\033[0m\r"
read path
echo -ne "\033[1;33mСоздание Secret для pfx сертификата\033[0m ... \r"
kubectl create secret generic pfx-certificate \
   --from-file=$path >/dev/null
echo -ne "\033[1;33mСоздание Secret для pfx сертификата\033[0m ... \033[1;32mDone\033[0m\r"
echo -ne "\n"


for node in $(kubectl get nodes | awk '{if ($3!="control-plane" && $3!="ROLES") print $1}')
do
  echo -ne "\033[1;33mСоздание директорий на Node: \033[0m"$node" ...\r"
  ssh root@$node "cd /opt/; mkdir rabbitmq-data"
  echo -ne "\033[1;33mСоздание директорий на Node: \033[0m"$node" ... \033[1;32mDone\033[0m\r"
  echo -ne "\n"
done