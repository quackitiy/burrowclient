; the windows setup wizard. tools/build.sh compiles it with -DVERSION, -DSOURCE
; (the folder to install), -DOUTFILE, -DICON and -DFILES (what the uninstaller removes).

Unicode true
!include "MUI2.nsh"

Name "Burrow"
OutFile "${OUTFILE}"
; per user: no administrator prompt, and an update needs none either
RequestExecutionLevel user
InstallDir "$LOCALAPPDATA\Programs\Burrow"
InstallDirRegKey HKCU "Software\Burrow" "InstallDir"
SetCompressor /SOLID lzma
BrandingText "Burrow ${VERSION}"

VIProductVersion "${VERSION}.0"
VIAddVersionKey "ProductName" "Burrow"
VIAddVersionKey "FileDescription" "Burrow Setup"
VIAddVersionKey "FileVersion" "${VERSION}"
VIAddVersionKey "ProductVersion" "${VERSION}"
VIAddVersionKey "LegalCopyright" ""

!define MUI_ICON "${ICON}"
!define MUI_UNICON "${ICON}"
!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_RUN "$INSTDIR\Burrow.exe"
!define MUI_FINISHPAGE_RUN_TEXT "Start Burrow"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

!define UNINSTALL_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\Burrow"

Section "Burrow"
  SetOutPath "$INSTDIR"
  File /r "${SOURCE}\*.*"
  WriteUninstaller "$INSTDIR\Uninstall Burrow.exe"

  CreateShortcut "$SMPROGRAMS\Burrow.lnk" "$INSTDIR\Burrow.exe"
  CreateShortcut "$DESKTOP\Burrow.lnk" "$INSTDIR\Burrow.exe"

  WriteRegStr HKCU "Software\Burrow" "InstallDir" "$INSTDIR"
  WriteRegStr HKCU "${UNINSTALL_KEY}" "DisplayName" "Burrow"
  WriteRegStr HKCU "${UNINSTALL_KEY}" "DisplayVersion" "${VERSION}"
  WriteRegStr HKCU "${UNINSTALL_KEY}" "Publisher" "Burrow"
  WriteRegStr HKCU "${UNINSTALL_KEY}" "DisplayIcon" "$INSTDIR\Burrow.exe"
  WriteRegStr HKCU "${UNINSTALL_KEY}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKCU "${UNINSTALL_KEY}" "UninstallString" '"$INSTDIR\Uninstall Burrow.exe"'
  WriteRegDWORD HKCU "${UNINSTALL_KEY}" "NoModify" 1
  WriteRegDWORD HKCU "${UNINSTALL_KEY}" "NoRepair" 1
SectionEnd

; only what was installed goes: the folder may be one the player chose, with
; other things in it. remembered accounts and settings live elsewhere and stay.
Section "Uninstall"
  !include "${FILES}"
  Delete "$INSTDIR\Uninstall Burrow.exe"
  RMDir "$INSTDIR"

  Delete "$SMPROGRAMS\Burrow.lnk"
  Delete "$DESKTOP\Burrow.lnk"
  DeleteRegKey HKCU "${UNINSTALL_KEY}"
  DeleteRegKey HKCU "Software\Burrow"
SectionEnd
