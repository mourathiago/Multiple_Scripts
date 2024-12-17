#!/bin/bash

#Funcionalidades:
#Resolução de IP de domínios.
#Consulta WHOIS para informações de registro.
#Scan de portas abertas com nmap.
#Busca de links indexados com Google Dorks.
#Extração de metadados de arquivos PDF, DOCX e JPEG.

# Verifica se o domínio foi fornecido
if [ -z "$1" ]; then
  echo "Uso: $0 <dominio>"
  exit 1
fi

domain=$1
output_txt="osint_report.txt"
output_html="osint_report.html"

echo "Iniciando coleta de informações sobre o domínio: $domain" > "$output_txt"
echo "<html><body><h1>Relatório de OSINT para $domain</h1>" > "$output_html"

# 1. Resolução de IP
echo "\n[+] Resolvendo IP do domínio..." | tee -a "$output_txt"
ip=$(dig +short "$domain")
echo "IP: $ip" | tee -a "$output_txt"
echo "<h2>Resolução de IP</h2><p>IP: $ip</p>" >> "$output_html"

# 2. WHOIS
echo "\n[+] Coletando informações WHOIS..." | tee -a "$output_txt"
whois_info=$(whois "$domain")
echo "$whois_info" >> "$output_txt"
echo "<h2>Informações WHOIS</h2><pre>$whois_info</pre>" >> "$output_html"

# 3. Scan de portas com Nmap
echo "\n[+] Escaneando portas abertas..." | tee -a "$output_txt"
nmap_result=$(nmap -F "$domain")
echo "$nmap_result" >> "$output_txt"
echo "<h2>Scan de Portas</h2><pre>$nmap_result</pre>" >> "$output_html"

# 4. Fazer a Busca de links indexados com Google Dorks / Google Hacking
echo "\n[+] Coletando links indexados..." | tee -a "$output_txt"
google_dork="site:$domain"
links=$(lynx --dump "https://www.google.com/search?q=$google_dork" | grep -o 'http[s]*://[^ ]*' | uniq)
echo "$links" >> "$output_txt"
echo "<h2>Links Indexados</h2><ul>" >> "$output_html"
for link in $links; do
  echo "<li><a href='$link'>$link</a></li>" >> "$output_html"
done
echo "</ul>" >> "$output_html"

# 5. Extração de metadados (PDF,DOC, imagens(JPEG e JPG)

echo "\n[+] Extraindo metadados de arquivos encontrados..." | tee -a "$output_txt"
mkdir -p downloads
echo "$links" | grep -E '\.(pdf|docx|jpg|jpeg)$' | while read -r file_url; do
  wget -q "$file_url" -P downloads
  filename=$(basename "$file_url")
  if [[ "$filename" =~ \.pdf$ ]]; then
    metadata=$(pdfinfo "downloads/$filename")
  elif [[ "$filename" =~ \.docx$ ]]; then
    metadata=$(exiftool "downloads/$filename")
  elif [[ "$filename" =~ \.jpe?g$ ]]; then
    metadata=$(exiftool "downloads/$filename")
  fi
  echo "\nMetadados de $filename:" | tee -a "$output_txt"
  echo "$metadata" | tee -a "$output_txt"
  echo "<h2>Metadados de $filename</h2><pre>$metadata</pre>" >> "$output_html"
done

# Finalizando relatório HTML
echo "</body></html>" >> "$output_html"

echo "\nRelatório salvo em $output_txt e $output_html"
