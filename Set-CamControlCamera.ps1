<#
.SYNOPSIS
    Funcao do modulo CamControl para cadastrar uma camera no sistema CamControl.

.DESCRIPTION
    Funcao do modulo CamControl para cadastrar uma camera no sistema CamControl.

.PARAMETER Server
    E necessario indicar o parametro -Server para o servidor de destino da requisicao.

.PARAMETER Nome
    Nome da camera.

.PARAMETER ClienteNome
    Cliente a quem pertence a camera.

.PARAMETER Endereco
    Endereco de localizacao da camera.

.PARAMETER IP
    Endereco IP da camera.

.PARAMETER Descricao
    Descricao ou comentario sobre a camera.

.PARAMETER Status
    Status da camera, 1 para OK e 2 para PENDENTE.

.EXAMPLE
    Set-CamControlCamera -Server localhost -Nome cam001 -ClienteNome clienteA -Endereco "rua a, 123" -IP 192.168.1.200 -Descricao "Câmera de segurança do patio da frente" -Status 2

.NOTES
    Esta funcao tem a finalidade de cadastrar uma camera na aplicacao CamControl. Deve ser aberto uma sessao com a aplicacao previamente a utilizacao deste comando.

.LINK
    Nao ha Links para documentacao relacionada ou recursos adicionais. Solicitar ao mantenedor em caso de necessidade a documentacao da API.

#>
function Set-CamControlCamera {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Server,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Nome,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$ClienteNome,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Endereco,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$IP,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Descricao,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [int]$Status
    )

    process {
        if (-Not [System.Uri]::IsWellFormedUriString("http://$Server", [System.UriKind]::Absolute)) {
            Write-Error "O nome do host não pôde ser analisado: $Server"
            return
        }

        $apiUrl = "http://${Server}/CAMCONTROL/rest/RestControllerCadastroCamera.php"
        
        $tokenFilePath = "C:\Users\marcelod.lima\Downloads\CamControlMod\AuthData.txt"    

        if (-Not (Test-Path -Path $tokenFilePath)) {
            Write-Error "Arquivo de token não encontrado: $tokenFilePath"
            return
        }

        $token = Get-Content -Path $tokenFilePath -Raw
        $token = $token.Trim()
        
        $body = @{
            nome = "${Nome}"
            cliente_nome = "${ClienteNome}"
            endereco = "${Endereco}"
            ip = "${IP}"
            descricao = "${Descricao}"
		status = "${Status}"
        }

        $jsonBody = $body | ConvertTo-Json
        
        $headers = @{
            Authorization = "Bearer $token"
            'Content-Type' = 'application/json'
        }

        try {

            $response = Invoke-WebRequest -Uri $apiUrl -Method Post -Body $jsonBody -Headers $headers -ContentType "application/json"
			$jsonContent = $response.Content | ConvertFrom-Json
            Write-Output $jsonContent.message
        }
        catch {
            Write-Error "Erro ao fazer a solicitacao: $_"
        }
    }
}

Export-ModuleMember -Function Set-CamControlCamera
