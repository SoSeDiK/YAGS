#SingleInstance Force
#Include "Libs.ahk"
#HotIf WinActive(GameProcessName)
#NoTrayIcon

Persistent
OnMessage 0x4000, SetSuspended



SetTimer Unfreeze, 250



Unfreeze() {
	While IsFrozen() {
		Send "{Space}"
		Sleep 68
	}
}



SetSuspended(Suspended, *) {
	Suspend Suspended
	If (A_IsSuspended) {
		SetTimer Unfreeze, 0
	} Else {
		SetTimer Unfreeze, 250
	}
}
