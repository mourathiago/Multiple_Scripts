#!/bin/bash

# Verifica se o IP foi passado como argumento
if [ -z "$1" ]; then
  echo "Uso: $0 192.168.1.1"
  exit 1
fi

# IP para verificar
ip=$1

# Lista de blacklists comuns
blacklists=("b.barracudacentral.org" "bl.spamcop.net" "cbl.abuseat.org" "zen.spamhaus.org")

echo "Verificando $ip em blacklists públicas..."

for blacklist in "${blacklists[@]}"; do
  reverse_ip=$(echo $ip | awk -F. '{print $4"."$3"."$2"."$1}')
  result=$(dig +short "$reverse_ip.$blacklist")
  
  if [ -n "$result" ]; then
    echo "$ip está listado em $blacklist"
  else
    echo "$ip não está listado em $blacklist"
  fi
done
