#SingleInstance Force
#Include "Libs.ahk"
#HotIf WinActive(GameProcessName)
#NoTrayIcon

OnMessage 0x4000, SetSuspended



Global PressingV := False



~*V:: {
	Global
	PressingV := True
	Attack()
}

~*V Up:: {
	Global
	PressingV := False
}



Attack() {
	; 9N2CJ
	While (PressingV) {
		Send "{LButton}"
		Sleep 190
		Send "{LButton}"

		If not PressingV
			Break

		Send "{LButton Down}"
		Sleep 300
		Send "{Space}"
		Send "{LButton Up}"

		If not PressingV
			Break

		Sleep 590
	}
	; 9H1CJ
	/*
	While (PressingV) {
		Send "{LButton Down}"
		Sleep 400
		Send "{LButton Up}"
		Sleep 15
		Send "{Space}"
		sleep 570
	}
	*/
}



SetSuspended(Suspended, *) {
	Global
	Suspend Suspended
	If (A_IsSuspended) {
		PressingV := False
	}
}
