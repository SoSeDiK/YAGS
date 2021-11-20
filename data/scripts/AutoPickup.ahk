#SingleInstance Force
#Include "Libs.ahk"
#HotIf WinActive(GameProcessName)
#NoTrayIcon

Persistent
OnMessage 0x4000, SetSuspended



SetTimer Pickup, 40



Pickup() {
	If HasPickup()
		LootOnce()
}

LootOnce() {
	Send "{f}"
	Sleep 20
	Send "{WheelDown}"
}

HasPickup() {
	; Search for "F" icon
	If !PixelSearch(&FoundX, &FoundY, 1120, 340, 1120, 730, "0x848484") ; Icon wasn't found
		Return False

	; Small delay to minimize error
	Sleep 10

	; Check If there's no extra prompts
	Color := PixelGetColor(1185, FoundY - 1)
	If (Color = "0xFFFFFF") ; Prompt icon was found
		Return False

	Color := PixelGetColor(1173, FoundY - 1)
	If (Color = "0xFFFFFF") ; Prompt icon was found
		Return False

	Return True
}



SetSuspended(Suspended, *) {
	Suspend Suspended
	If (A_IsSuspended) {
		SetTimer Pickup, 0
	} Else {
		SetTimer Pickup, 40
	}
}
