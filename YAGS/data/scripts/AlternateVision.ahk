#SingleInstance Force
#Include "Libs.ahk"
#HotIf WinActive(GameProcessName)
#NoTrayIcon

OnMessage 0x4000, SetSuspended



Global VisionModeTick := 0



~*H:: {
	ToggleVisionMode()
}



IsInVisionMode() {
	Global
	Return VisionModeTick > 0
}

ToggleVisionMode() {
	Global
	If IsInVisionMode() or IsFullScreenMenuOpen() {
		SetTimer VisionTimer, 0
		VisionModeTick := 0
		Send "{MButton Up}"
	} Else {
		VisionModeTick := 1
		Send "{MButton Down}"
		SetTimer VisionTimer, 300
	}
}

VisionTimer() {
	Global
	If IsFullScreenMenuOpen() {
		SetTimer VisionTimer, 0
		VisionModeTick := 0
		Send "{MButton Up}"
		Return
	}
	VisionModeTick := VisionModeTick + 1
	If (VisionModeTick == 10) {
		VisionModeTick := 1
		Send "{MButton Up}"
		Sleep 20
	}
	Send "{MButton Down}"
}



SetSuspended(Suspended, *) {
	Suspend Suspended
	If (A_IsSuspended) {
		If IsInVisionMode() {
			ToggleVisionMode()
		}
	}
}
