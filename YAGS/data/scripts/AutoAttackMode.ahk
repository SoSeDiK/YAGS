#SingleInstance Force
#Include "Libs.ahk"
#HotIf WinActive(GameProcessName)
#NoTrayIcon

OnMessage 0x4000, SetSuspended



Global PressingV := False
Global AttackMode := GetSetting("AutoAttackMode", "None", True)



~*V:: {
	Global
	PressingV := True
	Attack()
}

~*V Up:: {
	Global
	PressingV := False
}


~NumpadMult & Numpad1:: {
	UpdateAttackMode("KleeSimpleJumpCancel")
}

~NumpadMult & Numpad2:: {
	UpdateAttackMode("KleeChargedAttack")
}

~NumpadMult & Numpad3:: {
	UpdateAttackMode("HuTaoDashCancel")
}

~NumpadMult & Numpad4:: {
	UpdateAttackMode("HuTaoJumpCancel")
}

UpdateAttackMode(NewAttackMode) {
	Global
	AttackMode := NewAttackMode
	ToolTip Langed("AutoAttackMode", "Current attack mode: ", True) AttackMode, 160, 1050
	UpdateSetting("AutoAttackMode", AttackMode, True)
	Sleep 2000
	If (AttackMode = NewAttackMode)
		ToolTip
}



Attack() {
	Global
	If (AttackMode = "KleeSimpleJumpCancel")
		KleeSimpleJumpCancel()
	Else If (AttackMode = "KleeChargedAttack")
		KleeChargedAttack()
	Else If (AttackMode = "HuTaoDashCancel")
		HuTaoDashCancel()
	Else If (AttackMode = "HuTaoJumpCancel")
		HuTaoJumpCancel()
}

; NJ
KleeSimpleJumpCancel() {
	Global
	While (PressingV) {
		Send "{LButton}"
        Sleep 35
        Send "{Space}"
        Sleep 550
	}
}

; CJ
KleeChargedAttack() {
	Global
	While (PressingV) {
		Send "{LButton Down}"
		Sleep 460
		Send "{LButton Up}"
		Sleep 15
		Send "{Space}"
		sleep 570
	}
}

; 9N2CD
HuTaoDashCancel() {
	Global
	While (PressingV) {
		Send "{LButton}"
		Sleep 150
		Send "{LButton}"
		Sleep 150

		If not PressingV
			Break

		Send "{LButton Down}"
		Sleep 350
		Send "{LShift Down}"
		Sleep 30
		Send "{LShift Up}"
		Send "{LButton Up}"

		If not PressingV
			Break

		Sleep 400
	}
}

; 9N2CJ
HuTaoJumpCancel() {
	Global
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
}



SetSuspended(Suspended, *) {
	Global
	Suspend Suspended
	If (A_IsSuspended) {
		PressingV := False
	}
}
