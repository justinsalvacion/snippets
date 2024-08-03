$iisDetailState = Get-Website | ForEach-Object {
    $iibindings = if ($_.Bindings.Collection.Count -eq 0) {
        "No bindings"
    } else {
        $_.Bindings.Collection | ForEach-Object {
            $bindingInfo = "$($_.protocol)://$($_.bindingInformation)"
            if ($_.protocol -eq "https") {
                $sslDetails = @()
                if ($_.sslFlags -band 1) { $sslDetails += "SNI" }
                if ($_.sslFlags -band 2) { $sslDetails += "CentralCertStore" }
                $cert = Get-Item "cert:/LocalMachine/My/$($_.CertificateHash)"
                if ($cert) {
                    $certDetails = "Certificate Name: $($cert.FriendlyName), Thumbprint: $($cert.Thumbprint), Expiration: $($cert.NotAfter)"
                    $bindingInfo += " (SSL binding: $($sslDetails -join ', '), $certDetails)"
                } else {
                    $bindingInfo += " (SSL binding: $($sslDetails -join ', '))"
                }
            }
            $bindingInfo
        }
    }
    $bindingString = $iibindings -join ', '

    [PSCustomObject]@{
        Name = $_.Name
        ID = $_.Id
        Status = $_.State
        Bindings = $bindingString
        PhysicalPath = $_.PhysicalPath
    }
} 

$iisDetailState

