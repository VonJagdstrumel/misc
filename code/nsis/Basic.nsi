;--------------------------------
;Includes

  !include "MUI2.nsh"
  !include "FileFunc.nsh"

;--------------------------------
;General

  !define APPNAME "App Name"
  !define COMPANYNAME "Company Name"
  !define VERSION "1.0"
  !define ABOUTURL "http://www.google.fr/"

  Name "${APPNAME}"
  OutFile "${APPNAME} ${VERSION}.exe"
  InstallDir "$LOCALAPPDATA\${APPNAME}"
  InstallDirRegKey HKCU "Software\${APPNAME}" ""
  RequestExecutionLevel admin

;--------------------------------
;Variables

  Var StartMenuFolder

;--------------------------------
;Interface Settings

  !define MUI_HEADERIMAGE
  !define MUI_FINISHPAGE_NOAUTOCLOSE
  !define MUI_UNFINISHPAGE_NOAUTOCLOSE
  !define MUI_ABORTWARNING

  !define MUI_WELCOMEFINISHPAGE_BITMAP "monkey1.bmp"
  !define MUI_UNWELCOMEFINISHPAGE_BITMAP "monkey1.bmp"
  !define MUI_HEADERIMAGE_RIGHT
  !define MUI_HEADERIMAGE_BITMAP "monkey2.bmp"
  !define MUI_HEADERIMAGE_UNBITMAP "monkey2.bmp"

;--------------------------------
;Language Selection Dialog Settings

  !define MUI_LANGDLL_REGISTRY_ROOT "HKCU" 
  !define MUI_LANGDLL_REGISTRY_KEY "Software\${APPNAME}" 
  !define MUI_LANGDLL_REGISTRY_VALUENAME "Installer Language"

;--------------------------------
;Pages

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "${NSISDIR}\Docs\Modern UI\License.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU"
  !define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\${APPNAME}"
  !define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"
  !insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder
  !insertmacro MUI_PAGE_INSTFILES
; !define MUI_FINISHPAGE_RUN exe_file
; !define MUI_FINISHPAGE_SHOWREADME file/url
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "French"
  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Reserve Files

  !insertmacro MUI_RESERVEFILE_LANGDLL

;--------------------------------
;Language Strings

  LangString TYPE_Full ${LANG_FRENCH} "Complète"
  LangString TYPE_Full ${LANG_ENGLISH} "Full"
  LangString TYPE_Typical ${LANG_FRENCH} "Typique"
  LangString TYPE_Typical ${LANG_ENGLISH} "Typical"
  LangString TYPE_Minimal ${LANG_FRENCH} "Minimale"
  LangString TYPE_Minimal ${LANG_ENGLISH} "Minimal"

  LangString SEC_Main ${LANG_FRENCH} "Principal"
  LangString SEC_Main ${LANG_ENGLISH} "Main"
  LangString SEC_Test ${LANG_FRENCH} "Test"
  LangString SEC_Test ${LANG_ENGLISH} "Test"

  LangString DESC_Main ${LANG_FRENCH} "Section principale."
  LangString DESC_Main ${LANG_ENGLISH} "Main Section."
  LangString DESC_Test ${LANG_FRENCH} "Section test."
  LangString DESC_Test ${LANG_ENGLISH} "Test section."

  LangString LNK_Uninstall ${LANG_FRENCH} "Désinstaller"
  LangString LNK_Uninstall ${LANG_ENGLISH} "Uninstall"

;--------------------------------
;Install Types

  InstType $(TYPE_Full)
  InstType $(TYPE_Typical)
  InstType $(TYPE_Minimal)

;--------------------------------
;Installer Sections

  Section $(SEC_Main) SecMain
    SectionIn RO
    SetOutPath "$INSTDIR"

    ;ADD YOUR OWN FILES HERE...

    WriteRegStr HKCU "Software\${APPNAME}" "" $INSTDIR
    WriteUninstaller "$INSTDIR\Uninstall.exe"

    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
      CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
      CreateShortCut "$SMPROGRAMS\$StartMenuFolder\$(LNK_Uninstall).lnk" "$INSTDIR\Uninstall.exe"
    !insertmacro MUI_STARTMENU_WRITE_END

    ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
    IntFmt $0 "0x%08X" $0

    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "InstallLocation" "$\"$INSTDIR$\""
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayIcon" "$\"$INSTDIR\uninstall.exe$\""
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "Publisher" "${COMPANYNAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "URLInfoAbout" "${ABOUTURL}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayVersion" "${VERSION}"
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoModify" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoRepair" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "EstimatedSize" "$0"
  SectionEnd

  Section $(SEC_Test) SecTest
    SectionIn 1 2
  SectionEnd

;--------------------------------
;Installer Functions

  Function .onInit
    !insertmacro MUI_LANGDLL_DISPLAY
  FunctionEnd

;--------------------------------
;Descriptions

  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecMain} $(DESC_Main)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecTest} $(DESC_Test)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

  Section "Uninstall"
    ;ADD YOUR OWN FILES HERE...

    Delete "$INSTDIR\Uninstall.exe"
    RMDir "$INSTDIR"

    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder

    Delete "$SMPROGRAMS\$StartMenuFolder\$(LNK_Uninstall).lnk"
    RMDir "$SMPROGRAMS\$StartMenuFolder"

    DeleteRegKey /ifempty HKCU "Software\${APPNAME}"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
  SectionEnd

;--------------------------------
;Uninstaller Functions

  Function un.onInit
    !insertmacro MUI_UNGETLANGUAGE
  FunctionEnd
