#!/bin/bash

# Verifica se um domínio foi passado como argumento
if [ -z "$1" ]; then
  echo "Uso: $0 dominio.com"
  exit 1
fi

# Variável para o domínio
dominio=$1

# Consulta WHOIS
echo "---- WHOIS ----"
whois $dominio

# Consulta de DNS
echo "---- DNS ----"
dig $dominio ANY +noall +answer

# Consulta de servidores de e-mail
echo "---- MX ----"
dig $dominio MX +short

# Consulta de IPs associados
echo "---- IP ----"
host $dominio | grep "has address"

# Finaliza o script
echo "Consulta concluída para $dominio"
