SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\TextServicesFramework\MsCtfMonitor"
SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\WindowsUpdate\Scheduled Start"
SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan"
SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task"
SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\UpdateOrchestrator\Backup Scan"
SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\WaaSMedic\PerformRemediation"
sc stop UsoSvc
sc config UsoSvc start= disabled
sc stop WaaSMedicSvc
sc config WaaSMedicSvc start= disabled
sc stop wuauserv
sc config wuauserv start= disabled
sc stop DiagTrack
sc config DiagTrack start= disabled
sc stop lfsvc
sc config lfsvc start= disabled
sc stop TabletInputService
sc config TabletInputService start= disabled
sc stop TokenBroker
sc config TokenBroker start= disabled
sc stop WinDefend
sc config WinDefend start= disabled
sc stop WinHttpAutoProxySvc
sc config WinHttpAutoProxySvc start= disabled
sc stop WbioSrvc
sc config WbioSrvc start= disabled
sc stop WdNisSvc
sc config WdNisSvc start= disabled
