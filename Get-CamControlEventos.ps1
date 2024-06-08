<#
.SYNOPSIS
    Funcao do modulo CamControl para obter a listagem de eventos relacionado a uma camera.

.DESCRIPTION
    Funcao do modulo CamControl para obter a listagem de eventos relacionado a uma camera.

.PARAMETER Server
    E necessario indicar o parametro -Server para o servidor de destino da requisicao.
    
.PARAMETER Search
    Pode-se indicar o parametro -CameraId para informar o id de uma camera, o id da camera por ser obtido com o comando Get-CamControlCameras.

.PARAMETER Pagina
    E necessario indicar o parametro -Pagina para informar a pagina da listagem de eventos a ser retornada.

.EXAMPLE
    Get-CamControlEventos -Server localhost -CameraId 1 -Pagina 2

.NOTES
    Esta funcao tem a finalidade de obter uma listagem dos eventos de cameras cadastradas na aplicacao CamControl. Deve ser aberto uma sessao com a aplicacao previamente a utilizacao deste comando.

.LINK
    Nao ha Links para documentacao relacionada ou recursos adicionais. Solicitar ao mantenedor em caso de necessidade a documentacao da API.

#>
function Get-CamControlEventos {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Server,
		[parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$CameraId,
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

        $apiUrl = "http://${Server}/CAMCONTROL/rest/RestControllerListarEventos.php"
        
        $tokenFilePath = "C:\Users\marcelod.lima\Downloads\CamControlMod\AuthData.txt"    

        if (-Not (Test-Path -Path $tokenFilePath)) {
            Write-Error "Arquivo de token não encontrado: $tokenFilePath"
            return
        }

        $token = Get-Content -Path $tokenFilePath -Raw
        $token = $token.Trim()  # Remover espaços ou quebras de linha adicionais
        
        $params = @{
            camera_id = "$CameraId"
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

Export-ModuleMember -Function 'Get-CamControlEventos'
