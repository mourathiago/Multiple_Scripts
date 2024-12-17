#!/bin/bash

#Extração de URLs com Google Dorks

# Verifica se um termo foi passado
if [ -z "$1" ]; then
  echo "Uso: $0 'termo de busca'"
  exit 1
fi

termo=$(echo $1 | sed 's/ /+/g')

# Configura o Lynx para busca no Google usando dork específico
lynx -dump "https://www.google.com/search?q=site:*.$termo" | grep "https://" | sed 's/^.*https/https/' | sort -u




