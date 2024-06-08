<#
.SYNOPSIS
    Funcao do modulo CamControl para obter a listagem de cameras cadastradas.

.DESCRIPTION
    Funcao do modulo CamControl para obter a listagem de cameras cadastradas.

.PARAMETER Server
    E necessario indicar o parametro -Server para o servidor de destino da requisicao.
    
.PARAMETER Search
    Pode-se indicar o parametro -Search para informar uma palavra-chave de pesquisa para a requisicao.

.PARAMETER Pagina
    E necessario indicar o parametro -Pagina para informar a pagina da listagem de cameras a ser retornada.

.EXAMPLE
    Get-CamControlCameras -Server localhost -Search smseg -Pagina 2

.NOTES
    Esta funcao tem a finalidade de obter uma listagem das cameras cadastradas na aplicacao CamControl. Deve ser aberto uma sessao com a aplicacao previamente a utilizacao deste comando.

.LINK
    Nao ha Links para documentacao relacionada ou recursos adicionais. Solicitar ao mantenedor em caso de necessidade a documentacao da API.

#>
function Get-CamControlCameras {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Server,
        [string]$Search,
		[parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Pagina
    )

    process {
        # Verifique se a URL do servidor é válida
        if (-Not [System.Uri]::IsWellFormedUriString("http://$Server", [System.UriKind]::Absolute)) {
        		Write-Error "O nome do host não pôde ser analisado: $Server"
            return
        }

        $apiUrl = "http://${Server}/CAMCONTROL/rest/RestControllerListarCamera.php"
        
        $tokenFilePath = "C:\Users\marcelod.lima\Downloads\CamControlMod\AuthData.txt"    

        if (-Not (Test-Path -Path $tokenFilePath)) {
            Write-Error "Arquivo de token não encontrado: $tokenFilePath"
            return
        }

        $token = Get-Content -Path $tokenFilePath -Raw
        $token = $token.Trim()  # Remover espaços ou quebras de linha adicionais
        
        $params = @{
            pesquisa = "$Search"
			pagina = "$Pagina"
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

Export-ModuleMember -Function 'Get-CamControlCameras'
