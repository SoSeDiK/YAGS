; Borderless windowed mode - F12
#UseHook True
#SingleInstance Force

; Rerun script with the administrator privileges if required
If (not A_IsAdmin) {
	Try {
		Run '*RunAs "' A_ScriptFullPath '"'
	} Catch {
		MsgBox "Failed to run the script with administrator privileges"
	}
	Return
}

F12:: {
	;Send "{LAlt}{Enter}"
	WinTitle := "ahk_exe GenshinImpact.exe"
	WinSetStyle "-0xC40000", WinTitle
	WinMove 0, 0, A_ScreenWidth, A_ScreenHeight, WinTitle
	ExitApp
}
