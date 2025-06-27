$ErrorActionPreference = "Stop"

$domains = Import-Csv "domains.csv"
$config = Get-Content "config.json" | ConvertFrom-Json

foreach ($entry in $domains) {
    try {
        $hostname = ($entry.domain -replace "^https?://", "")
        $tcpClient = New-Object Net.Sockets.TcpClient($hostname, 443)
        $sslStream = New-Object Net.Security.SslStream($tcpClient.GetStream(), $false)
        $sslStream.AuthenticateAsClient($hostname)
        $cert = $sslStream.RemoteCertificate
        $cert2 = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 $cert
        $expiryDate = $cert2.NotAfter

        $remainingDays = ($expiryDate - (Get-Date)).Days

        if ($remainingDays -le $config.daysBeforeExpiry) {
            $subject = "⚠️ SSL Expiry Alert: $hostname"
            $body = "The SSL certificate for $hostname expires in $remainingDays days on $expiryDate.`nPlease take action."

            Write-Output $body

            Send-MailMessage `
                -From $config.smtp.from `
                -To $config.emailGroup `
                -Subject $subject `
                -Body $body `
                -SmtpServer $config.smtp.server `
                -Port $config.smtp.port `
                -UseSsl `
                -Credential (New-Object System.Management.Automation.PSCredential($config.smtp.username, (ConvertTo-SecureString $config.smtp.password -AsPlainText -Force)))
        } else {
            Write-Output "$hostname SSL valid: $expiryDate ($remainingDays days left)"
        }

        $sslStream.Close()
        $tcpClient.Close()
    } catch {
        Write-Output "⚠️ Failed to check $($entry.domain): $_"
    }
}
