<#
.SYNOPSIS
    Funcao do modulo CamControl para obter os detalhes de um item da listagem de relatorios resumidos.

.DESCRIPTION
    Funcao do modulo CamControl para obter os detalhes de um item da listagem de relatorios resumidos.

.PARAMETER Server
    E necessario indicar o parametro -Server para o servidor de destino da requisicao.
    
.PARAMETER CamId
    Pode-se indicar o parametro -Id para informar o id de um relatorio, o id da camera pode ser obtido com o comando Get-CamControlCameras, o relatorio resumido é único por camera.

.EXAMPLE
    Get-CamControlDetalhesRelatorio -Server localhost -CamId 1

.NOTES
    Esta funcao tem a finalidade de obter os detalhes de um item da listagem de relatorios resumidos. Deve ser aberto uma sessao com a aplicacao previamente a utilizacao deste comando.

.LINK
    Nao ha Links para documentacao relacionada ou recursos adicionais. Solicitar ao mantenedor em caso de necessidade a documentacao da API.

#>
function Get-CamControlDetalhesRelatorio {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Server,
		[parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$CamId
		)

    process {
        # Verifique se a URL do servidor é válida
        if (-Not [System.Uri]::IsWellFormedUriString("http://$Server", [System.UriKind]::Absolute)) {
        		Write-Error "O nome do host não pôde ser analisado: $Server"
            return
        }

        $apiUrl = "http://${Server}/CAMCONTROL/rest/RestControllerDetalhesRelatorio.php"
        
        $tokenFilePath = "C:\Users\marcelod.lima\Downloads\CamControlMod\AuthData.txt"    

        if (-Not (Test-Path -Path $tokenFilePath)) {
            Write-Error "Arquivo de token não encontrado: $tokenFilePath"
            return
        }

        $token = Get-Content -Path $tokenFilePath -Raw
        $token = $token.Trim()  # Remover espaços ou quebras de linha adicionais
        
        $params = @{
            id = "$CamId"
        }
        
        $queryString = ($params.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&"
        $fullUrl = $apiUrl + "?" + $queryString

        $headers = @{
            Authorization = "Bearer $token"
        }
        
        try {
            $response = Invoke-RestMethod -Uri $fullUrl -Method Get -Headers $headers
            Write-Output $response
        }
        catch {
			Write-Host "$fullUrl"
            Write-Error "Erro ao fazer a solicitacao: $_"
        }
    }
}

Export-ModuleMember -Function 'Get-CamControlDetalhesRelatorio'
