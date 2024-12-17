# Lista de subdomínios comuns para scan
$subdomains = @("www", "mail", "ftp", "blog", "dev", "api", "shop", "app", "stage")

# Pede ao usuário para inserir o domínio alvo
$domain = Read-Host "Insira o domínio alvo (ex: exemplo.com)"

# Função para resolver DNS
function Test-Subdomain {
    param (
        [string]$subdomain,
        [string]$domain
    )

    try {
        # Faz a consulta DNS para o subdomínio
        $result = Resolve-DnsName -Name "$subdomain.$domain" -ErrorAction Stop
        Write-Output "$subdomain.$domain - Encontrado - Endereço IP: $($result.IPAddress)"
    }
    catch {
        Write-Output "$subdomain.$domain - Não encontrado"
    }
}

# Loop pelos subdomínios
foreach ($sub in $subdomains) {
    Test-Subdomain -subdomain $sub -domain $domain
}

Write-Output "Scan completo para o domínio $domain."
