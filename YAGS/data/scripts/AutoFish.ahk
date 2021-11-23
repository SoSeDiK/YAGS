#SingleInstance Force
#Include "Libs.ahk"
#HotIf WinActive(GameProcessName)
#NoTrayIcon

OnMessage 0x4000, SetSuspended



Global TargetMode := False
Global AutoFishing := False
Global IsPulling := False



*LButton:: {
	ToggleTargetMode()
}

ToggleTargetMode() {
	Global
	TargetMode := !TargetMode
	If (TargetMode) {
		Send "{LButton Down}"
	} Else {
		Send "{LButton Up}"
	}
}



ToggleAutoFishing() {
	Global
	AutoFishing := !AutoFishing
	If AutoFishing {
		SetTimer CheckFishing, 100
	} Else {
		IsPulling := False
		SetTimer CheckFishing, 0
	}
}

CheckFishing() {
	Global
	If not IsHooked()
		Return

	Shape := CheckShape()

	If (Shape == 0) {
		If IsPulling {
			IsPulling := False
			Return
		}
	} Else If (Shape == 2) {
		IsPulling := True
		Send "{LButton Down}"
		Sleep 100
		Send "{LButton Up}"
	}
}

IsHooked() {
	; Fish baited, start pulling
	If PixelSearch(&FoundX, &FoundY, 1613, 980, 1615, 983, "0xFFFFFF") {
		MouseClick "Left"
		Return True
	}

	; Option to cast the rod is present
	Color := PixelGetColor(1740, 1030)
	If (Color = "0xFFE92C")
		Return False

	Return True
}

CheckShape() {
    ; 0 -> return
    ; 1 -> return
    ; 2 -> pull

	StartX := 718

	If !PixelSearch(&FoundX1, &FoundY1, StartX, 100, 1200, 100, "0xFFFFC0") ; Current position
		Return 0

	If !PixelSearch(&FoundX2, &FoundY2, 1210, 112, FoundX1 + 9, 112, "0xFFFFC0") ; Border
		Return 0

	Result := FoundX1 - FoundX2
	If (Result > -45) ; Distance from the current position to the right border
		Return 1

	Return 2
}



SetSuspended(Suspended, *) {
	Global
	Suspend Suspended
	If (A_IsSuspended) {
		If AutoFishing
			ToggleAutoFishing()
		If TargetMode
			ToggleTargetMode()
	} Else If not AutoFishing {
		ToggleAutoFishing()
	}
}
