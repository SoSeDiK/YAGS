#SingleInstance Force
#Include "Libs.ahk"
#HotIf WinActive(GameProcessName)
#NoTrayIcon

OnMessage 0x4000, SetSuspended



*MButton:: {
	If IsFullScreenMenuOpen()
		DoMapClick()
}



DoMapClick() {
	MapClick()
	try {
		; Wait for a little white arrow or teleport button
		WaitPixelsRegions([ { X1: 1255, Y1: 484, X2: 1258, Y2: 1080, Color: "0xECE5D8" }, { X1: 1478, Y1: 1012, X2: 1478, Y2: 1013, Color: "0xFFCC33" } ])
	} catch {
		Return
	}

	TpColor := PixelGetColor(1478, 1012)
	If (TpColor = "0xFFCC33") {
		; Selected point has only 1 selectable option, and it's available for the teleport
		ClickOnBottomRightButton()
		Sleep 50
		MoveCursorToCenter()
	} Else {
		; Selected point has multiple selectable options or selected point is not available for the teleport
		TeleportablePointColors := [ "0x2D91D9"	; Teleport Waypoint
			,"0x99ECF5"							; Statue of The Seven
			,"0x05EDF6"							; Domain
			,"0x00FFFF"							; One-time dungeon
			,"0x5E615F"							; Sub-Space Waypoint
			,"0x63635F" ]						; Portable Waypoint

		; Find the upper available teleport
		Y := -1
		For Index, TeleportablePointColor in TeleportablePointColors {
			If PixelSearch(&FoundX, &FoundY, 1298, 460, 1299, 1080, TeleportablePointColor) {
				If (Y = -1 or FoundY < Y)
					Y := FoundY
			}
		}

		If (Y != -1)
			Teleport(Y)
	}
}

Teleport(Y) {
	MouseClick "Left", 1298, Y
	WaitPixelColor("0xFFCB33", 1480, 1011, 1200) ; "Teleport" button

	ClickOnBottomRightButton()
	Sleep 50
	MoveCursorToCenter()
}



SetSuspended(Suspended, *) {
	Suspend Suspended
}
