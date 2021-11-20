#SingleInstance Force
#Include "Libs.ahk"
#HotIf WinActive(GameProcessName)
#NoTrayIcon

OnMessage 0x4000, SetSuspended



Global Pressing1 := False
Global Pressing2 := False
Global Pressing3 := False
Global Pressing4 := False



~*1:: {
	Global
	Pressing1 := True
	While (Pressing1) {
		Send "{1}"
		Sleep 100
	}
}

~*1 Up:: {
	Global
	Pressing1 := False
}

~*2:: {
	Global
	Pressing2 := True
	While (Pressing2) {
		Send "{2}"
		Sleep 100
	}
}

~*2 Up:: {
	Global
	Pressing2 := False
}

~*3:: {
	Global
	Pressing3 := True
	While (Pressing3) {
		Send "{3}"
		Sleep 100
	}
}

~*3 Up:: {
	Global
	Pressing3 := False
}

~*4:: {
	Global
	Pressing4 := True
	While (Pressing4) {
		Send "{4}"
		Sleep 100
	}
}

~*4 Up:: {
	Global
	Pressing4 := False
}



SetSuspended(Suspended, *) {
	Suspend Suspended
	If (A_IsSuspended) {
		Pressing1 := False
		Pressing2 := False
		Pressing3 := False
		Pressing4 := False
	}
}
