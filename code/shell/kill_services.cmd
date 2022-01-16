SCHTASKS /Change /DISABLE /tn "\AMDInstallLauncher"
SCHTASKS /Change /DISABLE /tn "\ASUS\ASUS AISuiteIII"
SCHTASKS /Change /DISABLE /tn "\ASUS\Ez Update"
SCHTASKS /Change /DISABLE /tn "\Adobe Acrobat Update Task"
SCHTASKS /Change /DISABLE /tn "\CCleaner Update"
SCHTASKS /Change /DISABLE /tn "\MicrosoftEdgeUpdateTaskMachineCore"
SCHTASKS /Change /DISABLE /tn "\MicrosoftEdgeUpdateTaskMachineUA"
SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\HelloFace\FODCleanupTask"
SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\TextServicesFramework\MsCtfMonitor"
SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\UNP\RunUpdateNotificationMgr"
SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\UpdateOrchestrator\Backup Scan"
SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\UpdateOrchestrator\MusUx_LogonUpdateResults"
SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\UpdateOrchestrator\Reboot_AC"
SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\UpdateOrchestrator\Reboot_Battery"
SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\UpdateOrchestrator\Report policies"
SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task"
SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan"
SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\UpdateOrchestrator\Schedule Work"
SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker"
SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\UpdateOrchestrator\UpdateModelTask"
SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\WaaSMedic\PerformRemediation"
SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance"
SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\Windows Defender\Windows Defender Cleanup"
SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan"
SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\Windows Defender\Windows Defender Verification"
SCHTASKS /Change /DISABLE /tn "\Microsoft\Windows\WindowsUpdate\Scheduled Start"
SCHTASKS /Change /DISABLE /tn "\Microsoft\XblGameSave\XblGameSaveTask"
SCHTASKS /Change /DISABLE /tn "\StartCN"
sc stop AdobeARMservice
sc config AdobeARMservice start= disabled
sc stop DiagTrack
sc config DiagTrack start= disabled
sc stop TabletInputService
sc config TabletInputService start= disabled
sc stop TokenBroker
sc config TokenBroker start= disabled
sc stop UsoSvc
sc config UsoSvc start= disabled
sc stop WaaSMedicSvc
sc config WaaSMedicSvc start= disabled
sc stop WbioSrvc
sc config WbioSrvc start= disabled
sc stop WdNisSvc
sc config WdNisSvc start= disabled
sc stop WinDefend
sc config WinDefend start= disabled
sc stop WinHttpAutoProxySvc
sc config WinHttpAutoProxySvc start= disabled
sc stop edgeupdate
sc config edgeupdate start= disabled
sc stop edgeupdatem
sc config edgeupdatem start= disabled
sc stop lfsvc
sc config lfsvc start= disabled
sc stop uhssvc
sc config uhssvc start= disabled
sc stop wuauserv
sc config wuauserv start= disabled
