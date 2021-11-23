#SingleInstance Force
#Include "Libs.ahk"
#HotIf WinActive(GameProcessName)
#NoTrayIcon



~NumpadSub & Numpad1:: {
	ChangeParty(1)
}

~NumpadSub & Numpad2:: {
	ChangeParty(2)
}

~NumpadSub & Numpad3:: {
	ChangeParty(3)
}

~NumpadSub & Numpad4:: {
	ChangeParty(4)
}



ChangeParty(NewPartyNum) {
	CurrentPartyNum := 1

	Send "{l}"
	WaitFullScreenMenu(5000)

	Loop 4 {
		Color := PixelGetColor(875 + (A_Index * 35), 48)
		If (Color != "0xFFFFFF") ; Check for current party
			Continue

		CurrentPartyNum := A_Index
		Break
	}

	Changes := CurrentPartyNum - NewPartyNum
	If (Changes == 0) {
		Send "{Esc}"
		Return
	} Else If (Changes == 3) {
		Changes := -1
	} Else If (Changes == -3) {
		Changes := 1
	}

	Loop Abs(Changes) {
		If (Changes > 0) {
			MouseClick "Left", 75, 539
		} Else {
			MouseClick "Left", 1845, 539
		}
		Sleep 20
	}

	WaitDeployButtonActive(1000)
	MouseClick "Left", 1700, 1000 ; Press Deploy button

	WaitPixelColor("0xFFFFFF", 836, 491, 2000) ; Wait for "Party deployed" notification
	Send "{Esc}"
}
