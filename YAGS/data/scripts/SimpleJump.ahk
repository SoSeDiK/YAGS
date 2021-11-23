#SingleInstance Force
#Include "Libs.ahk"
#HotIf WinActive(GameProcessName)
#NoTrayIcon

OnMessage 0x4000, SetupHotkeys



Global PressingXButton := False



SetupHotkeys()



XButton(*) {
	Global
	PressingXButton := True
	Jump()
}

XButtonUp(*) {
	Global
	PressingXButton := False
}



Jump() {
	; Long jump if in boat
	If IsInBoat() {
		Send "{Space Down}"
		Sleep 700
		Send "{Space Up}"
		Return
	}

	; Just jump
	Send "{Space}"

	; Let the user release the button
	If IsFullScreenMenuOpen() or IsGameScreen()
		Return

	; Click if in dialogue
	While (PressingXButton) {
		Send "{f}"
		If PixelSearch(&FoundX, &FoundY, 1310, 840, 1310, 580, "0xFFFFFF")
			MouseClick "Left", FoundX, FoundY
		Sleep 20
	}
}



SetupHotkeys(*) {
	Mapping := GetSetting("SwapSideMouseButtons", "0", True)
	XButtonF := Mapping ? "XButton1" : "XButton2"
	XButtonS := Mapping ? "XButton2" : "XButton1"
	HotIfWinActive(GameProcessName)
	Hotkey "*" XButtonS, XButton, "Off"
	Hotkey "*" XButtonS " Up", XButtonUp, "Off"
	Hotkey "*" XButtonF, XButton, "On"
	Hotkey "*" XButtonF " Up", XButtonUp, "On"
}
