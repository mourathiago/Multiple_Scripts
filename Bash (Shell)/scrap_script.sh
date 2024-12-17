#!/bin/bash

## script em Shell para automatizar o web scraping de várias fontes e salvar os resultados nos formatos .txt, .csv e .html. 


# --- Configurações ---
URLS=(
    "https://example.com/news"
    "https://example.org/blog"
    "https://example.net/articles"
)

# Termo de busca específico
SEARCH_TERM="tecnologia"

# Diretório para salvar os resultados
OUTPUT_DIR="/home/$USER/scraping_results"
mkdir -p "$OUTPUT_DIR"

# Formatos de saída
TXT_FILE="$OUTPUT_DIR/results.txt"
CSV_FILE="$OUTPUT_DIR/results.csv"
HTML_FILE="$OUTPUT_DIR/results.html"

# Limpar arquivos antigos
> "$TXT_FILE"
> "$CSV_FILE"
> "$HTML_FILE"

# Função para extrair dados de uma URL
do_scraping() {
    local url=$1
    echo "Scraping $url..."

    # Fazer download do conteúdo da página
    content=$(curl -s "$url")

    # Filtrar linhas que contenham o termo de busca
    results=$(echo "$content" | grep -i "$SEARCH_TERM")

    # Se encontrar resultados, salvar nos arquivos
    if [[ -n "$results" ]]; then
        echo "Resultados encontrados em $url:" >> "$TXT_FILE"
        echo "$results" >> "$TXT_FILE"
        echo "" >> "$TXT_FILE"

        # Salvar em formato CSV
        echo "URL,Resultado" >> "$CSV_FILE"
        while IFS= read -r line; do
            echo "$url,\"$line\"" >> "$CSV_FILE"
        done <<< "$results"

        # Salvar em formato HTML
        echo "<h2>Resultados de <a href=\"$url\">$url</a></h2>" >> "$HTML_FILE"
        echo "<pre>$results</pre>" >> "$HTML_FILE"
    else
        echo "Nenhum resultado encontrado em $url."
    fi
}

# Loop através de todas as URLs para scraping
for url in "${URLS[@]}"; do
    do_scraping "$url"
done

# Mensagem final
echo "Scraping concluído. Resultados salvos em $OUTPUT_DIR."
