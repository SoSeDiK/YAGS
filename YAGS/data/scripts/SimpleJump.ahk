#SingleInstance Force
#Include "Libs.ahk"
#HotIf WinActive(GameProcessName)
#NoTrayIcon

OnMessage 0x4000, SetupHotkeys



Global PressingXButton := False
Global PressingSpace := False



SetupHotkeys()



~*Space:: {
	Global
	PressingSpace := True
	If IsGameScreen()
		Bunnyhop(&PressingSpace)
}

~*Space Up:: {
	Global
	PressingSpace := False
}

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
	Global
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
	If IsFullScreenMenuOpen()
		Return
	If IsGameScreen() {
		Bunnyhop(&PressingXButton)
		Return
	}

	; Click if in dialogue
	While (PressingXButton) {
		Send "{f}"
		If PixelSearch(&FoundX, &FoundY, 1310, 840, 1310, 580, "0xFFFFFF")
			MouseClick "Left", FoundX, FoundY
		Sleep 20
	}
}

Bunnyhop(&JumpingKey) {
	Global
	While (JumpingKey) {
		Sleep 50
		Send "{Space}"
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
