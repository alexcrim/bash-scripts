#!/bin/bash

STACK=<stack_name>
DEPLOY=(
  "<service_name>:<YAML_name>.yml"
)


for ACTIVE in "${DEPLOY[@]}"
do
  KEY=${ACTIVE%%:*}
  VALUE=${SERVICE#*:}
  docker service rm $STACK"_"$KEY >/dev/null
done
echo -ne "\033[1;33mУдаление всех сервисов "$STACK":\033[0m ... \r"
sleep 10
echo -ne "\033[1;33mУдаление всех сервисов "$STACK"\033[0m ... \033[1;32mDone\033[0m\n"


for SERVICE in "${DEPLOY[@]}"
do
  KEY=${SERVICE%%:*}
  VALUE=${SERVICE#*:}
  env $(cat conf.env | grep ^[A-Z] | xargs) docker stack deploy -c $VALUE $STACK >/dev/null
  for (( time=0; time<=4; time++ ))
  do
    echo -ne "\033[1;33mЗапуск сервиса: \033[0m"$KEY" ... \r"
    sleep 1
  done
  echo -ne "\033[1;33mЗапуск сервиса: \033[0m"$KEY" ... \033[1;32mDone\033[0m\n"
done

echo -e "\033[1;33mДеплоймент завершен\033[0m"