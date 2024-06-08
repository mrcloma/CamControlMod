<#
.SYNOPSIS
    Funcao do modulo CamControl para abrir uma nova sessao com a aplicacao CamControl.

.DESCRIPTION
    Funcao do modulo CamControl para abrir uma nova sessao com a aplicacao CamControl.

.PARAMETER Server
    E necessario indicar o parametro -Server para que a sessao seja aberta em um servidor em especifico.
	
.PARAMETER User
    E necessario indicar o parametro -User para abrir a sessao.

.PARAMETER Pass
    E necessario indicar o parametro -Pass para abrir a sessao.

.EXAMPLE
    New-CamControlSession -Server localhost -User abc -Pass passabc

.NOTES
    Esta funcao deve iniciar a interacao com a aplicacao CamControl, a sessao dura 1 hora.

.LINK
    Nao ha Links para documentacao relacionada ou recursos adicionais. Solicitar ao mantenedor em caso de necessidade a documentacao da API.

#>
function New-CamControlSession {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Server,
		[parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
		[string]$User,
		[parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
		[string]$Pass
    )

    process {
		
		$body = @{
			username = "${User}"
			password = "${Pass}"
		}
		
		$jsonBody = $body | ConvertTo-Json
		
		try {
			$apiEndpoint = "http://${Server}/CAMCONTROL/rest/RestGenerateToken.php"
	
			$authInfo = Invoke-RestMethod -Uri $apiEndpoint -Method Post -Body $jsonBody -ContentType "application/json"

			$token = $authInfo.access_token

			$caminhoAuthData = "C:\Users\marcelod.lima\Downloads\CamControlMod\AuthData.txt"

			Set-Content -Path $caminhoAuthData -Value $token
		}
        catch {
            Write-Error "Erro ao obter informacoes de autenticacao: $_"
        }
    }
}

Export-ModuleMember -Function 'New-CamControlSession'