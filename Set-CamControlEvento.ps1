<#
.SYNOPSIS
    Funcao do modulo CamControl para cadastrar um evento no sistema CamControl.

.DESCRIPTION
    Funcao do modulo CamControl para cadastrar um evento no sistema CamControl.

.PARAMETER Server
    E necessario indicar o parametro -Server para o servidor de destino da requisicao.

.PARAMETER Evento
    Nome do evento de camera.

.PARAMETER CameraID
    ID da camera para o qual sera registrado o evento.

.PARAMETER IT2M
    Numero do chamado IT2M que gerou o evento.

.PARAMETER FMAN
    Numero da FMAN relacionada ao evento.

.PARAMETER VManut
    Numero da requisicao de video manutencao relacionada ao evento.

.PARAMETER DataAbertura
    Data de abertura do evento.

.PARAMETER DataFechamento
    Data de fechamento do evento.

.PARAMETER Responsavel
    Responsavel pelo evento.

.PARAMETER Problema
    Problema a ser resolvido ou abordado no evento.

.PARAMETER Acao
    Acao a ser tomada para a resolucao do evento, ou ultima acao tomada.

.EXAMPLE
    Set-CamControlEvento -Server localhost -Evento "Fibra de ligacao rompida" -CameraID "1" -IT2M "123" -FMAN "192" -VManut "333" -DataAbertura "2/2/2024" -DataFechamento "2/2/2024" -Responsavel ICP -Problema "Fibra rompida esta causando indisponibilidade" -Acao "Acionar terceirizada responsavel pelo cabeamento"

.NOTES
    Esta funcao tem a finalidade de cadastrar um evento de camera na aplicacao CamControl. Deve ser aberto uma sessao com a aplicacao previamente a utilizacao deste comando.

.LINK
    Nao ha Links para documentacao relacionada ou recursos adicionais. Solicitar ao mantenedor em caso de necessidade a documentacao da API.

#>
function Set-CamControlEvento {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Server,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Evento,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$CameraID,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$IT2M,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$FMAN,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$VManut,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$DataAbertura,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$DataFechamento,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Responsavel,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Problema,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Acao
    )

    process {
        if (-Not [System.Uri]::IsWellFormedUriString("http://$Server", [System.UriKind]::Absolute)) {
            Write-Error "O nome do host não pôde ser analisado: $Server"
            return
        }

        $apiUrl = "http://${Server}/CAMCONTROL/rest/RestControllerCadastroEvento.php"
        
        $tokenFilePath = "C:\Users\marcelod.lima\Downloads\CamControlMod\AuthData.txt"    

        if (-Not (Test-Path -Path $tokenFilePath)) {
            Write-Error "Arquivo de token não encontrado: $tokenFilePath"
            return
        }

        $token = Get-Content -Path $tokenFilePath -Raw
        $token = $token.Trim()
        
		$body = @{
			evento = "${Evento}"
			camera_id = "${CameraID}"
			it2m = "${IT2M}"
			fman = "${FMAN}"
			vmanut = "${VManut}"
			data_abertura = "${DataAbertura}"
			data_fechamento = "${DataFechamento}"
			responsavel = "${Responsavel}"
			problema = "${Problema}"
			acao = "${Acao}"
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

Export-ModuleMember -Function Set-CamControlEvento
