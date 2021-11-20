#SingleInstance Force
#Include "Libs.ahk"
#HotIf WinActive(GameProcessName)
#NoTrayIcon

OnMessage 0x4000, SetSuspended



Global AutoWalk := False
Global AutoSprint := False

Global PressingW := False
Global PressingLShift := False



~*w:: {
	Global
	PressingW := True
}

~*w Up:: {
	Global
	PressingW := False
}

*LShift:: {
	Global
	PressingLShift := True
	ToggleAutoSprint()
	If not AutoWalk and not AutoSprint
		Send "{LShift Down}"
}

*LShift Up:: {
	Global
	PressingLShift := False
	If not AutoWalk and not AutoSprint
		Send "{LShift Up}"
}



*MButton:: {
	ToggleAutoWalk()
}



DoAutoWalk() {
	Send "{w Down}"
}

DoAutoSprint() {
	If IsInBoat() or IsExtraRun() {
		Send "{LShift Down}"
		Return
	}
	Send "{LShift Down}"
	Sleep 150
	Send "{LShift Up}"
}

ToggleAutoWalk() {
	Global
	AutoWalk := !AutoWalk
	If AutoWalk {
		UpdateScriptState("EasierCombat", 0)
		Hotkey "*RButton", ToggleAutoSprint, "On"
		SetTimer DoAutoWalk, 100
	} else {
		If GetSetting("EasierCombat", True, True)
			UpdateScriptState("EasierCombat", 1)
		Hotkey "*RButton", ToggleAutoSprint, "Off"
		SetTimer DoAutoWalk, 0
		If not PressingW
			Send "{w Up}"

		If AutoSprint {
			AutoSprint := False
			SetTimer DoAutoSprint, 0
			If not PressingLShift
				Send "{LShift Up}"
		}
	}
}

ToggleAutoSprint(*) {
	Global
	If not AutoWalk
		Return

	AutoSprint := !AutoSprint
	If AutoSprint {
		DoAutoSprint()
		SetTimer DoAutoSprint, 850
	} else {
		SetTimer DoAutoSprint, 0
		If not PressingLShift
			Send "{LShift Up}"
	}
}



SetSuspended(Suspended, *) {
	Global
	Suspend Suspended
	If (A_IsSuspended) {
		If AutoWalk
			ToggleAutoWalk()
		PressingW := False
		PressingLShift := False
	}
}
