#SingleInstance Force
#Include "Libs.ahk"
#HotIf WinActive(GameProcessName)
#NoTrayIcon

OnMessage 0x4000, SetSuspended



~*LButton:: {
	SetTimer NormalAutoAttack, 150
}

~*LButton Up:: {
	SetTimer NormalAutoAttack, 0
}

*RButton:: {
	StrongAttack()
}



NormalAutoAttack() {
	MouseClick "Left"
}

StrongAttack() {
    Click "Down"
    KeyWait "RButton"
    TimeSinceKeyPressed := A_TimeSinceThisHotkey
    If (TimeSinceKeyPressed < 350) {
        ; hold LMB for at least 350ms
        Sleep 350 - TimeSinceKeyPressed
    }
    Click "Up"
}



SetSuspended(Suspended, *) {
	Suspend Suspended
	If (A_IsSuspended) {
		SetTimer NormalAutoAttack, 0
	}
}
