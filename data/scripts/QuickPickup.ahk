#SingleInstance Force
#Include "Libs.ahk"
#HotIf WinActive(GameProcessName)
#NoTrayIcon

OnMessage 0x4000, SetSuspended



Global PressingF := False
Global PressingXButton := False



~*f:: {
	Global
	PressingF := True
	While (PressingF) {
		LootOnce()
	}
}

~*f Up:: {
	Global
	PressingF := False
}

SetupHotkeys()

XButton(*) {
	Global
	PressingXButton := True
	While (PressingXButton) {
		LootOnce()
	}
}

XButtonUp(*) {
	Global
	PressingXButton := False
}



LootOnce() {
	Send "{f}"
	Sleep 40
}



SetupHotkeys() {
	Mapping := GetSetting("SwapSideMouseButtons", "0", True)
	XButtonF := Mapping ? "XButton2" : "XButton1"
	XButtonS := Mapping ? "XButton1" : "XButton2"
	HotIfWinActive(GameProcessName)
	Hotkey "*" XButtonS, XButton, "Off"
	Hotkey "*" XButtonS " Up", XButtonUp, "Off"
	Hotkey "*" XButtonF, XButton, "On"
	Hotkey "*" XButtonF " Up", XButtonUp, "On"
}



SetSuspended(Suspended, *) {
	Global
	If (Suspended = 3) {
		SetupHotkeys()
		Return
	}
	Suspend Suspended
	If (A_IsSuspended) {
		PressingF := False
		PressingXButton := False
	}
}
