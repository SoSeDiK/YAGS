#SingleInstance Force
#Include "Libs.ahk"
#HotIf WinActive(GameProcessName)
#NoTrayIcon



; Expedition duration coordinates
Global Duration4H := { X: 1500, Y: 700 }
Global Duration8H := { X: 1600, Y: 700 }
Global Duration12H := { X: 1700, Y: 700 }
Global Duration20H := { X: 1800, Y: 700 }

; Expeditions (crystals)
Global WhisperingWoodsExpedition := { MapNumber: 0, X: 1050, Y: 330 }
Global DadaupaGorgeExpedition := { MapNumber: 0, X: 1170, Y: 660 }
Global YaoguangShoalExpedition := { MapNumber: 1, X: 950, Y: 450 }

; Expeditions (mora)
Global StormterrorLairExpedition := { MapNumber: 0, X: 550, Y: 400 }
Global DihuaMarshExpedition := { MapNumber: 1, X: 728, Y: 332 }
Global JueyunKarstExpedition := { MapNumber: 1, X: 559, Y: 561 }
Global JinrenIslandExpedition := { MapNumber: 2, X: 1097, Y: 274 }
Global TatarasunaExpedition := { MapNumber: 2, X: 828, Y: 828 }

; Expeditions (meat)
Global WindriseExpedition := { MapNumber: 0, X: 1111, Y: 455 }
Global MusoujinGorgeExpedition := { MapNumber: 2, X: 580, Y: 800 }

; Expeditions (vegetables)
Global WolvendomExpedition := { MapNumber: 0, X: 740, Y: 530 }
Global GuyunStoneForestExpedition := { MapNumber: 1, X: 1170, Y: 610 }
Global KondaVillageExpedition := { MapNumber: 2, X: 935, Y: 345 }

; Expeditions (flowers)
Global StormbearerMountainsExpedition := { MapNumber: 0, X: 810, Y: 240 }
Global ByakkoPlainExpedition := { MapNumber: 2, X: 1145, Y: 435 }

; Expeditions (Lotus & Matsuke)
Global GuiliPlainsExpedition := { MapNumber: 1, X: 800, Y: 550 }
Global DunyuRuinsExpedition := { MapNumber: 1, X: 730, Y: 810 }

; Expeditions (extra)
Global NazuchiBeachExpedition := { MapNumber: 2, X: 725, Y: 695 } ; Fowl & Seagrass



Global RedNotificationColor := "0xE6455F"



; =======================================
; Inventory Actions
; =======================================

~MButton:: {
	; =======================================
	; Quick buying artifacts and weapons
	; (you may try in other shops too :/)
	; =======================================
	If (PixelGetColor(80, 50) = "0xD3BC8E" and PixelGetColor(1785, 1018) = "0xECE5D8") {
		While IsAvailableForStock() {
			ClickOnBottomRightButton()
			WaitPixelColor("0x4A5366", 1050, 750, 1000) ; Wait for tab to be active
			MouseClick "Left", 1178, 625 ; Max stacks
			Sleep 10
			MouseClick "Left", 1050, 750 ; Click Purchase
			WaitPixelColor("0xD3BC8E", 1060, 280, 1000)
			ClickOnBottomRightButton() ; Skip purchased dialogue
			Sleep 300
		}
		Return
	}
	; =======================================
	; Select maximum stacks and craft ores
	; =======================================
	If (PixelGetColor(62, 52) = "0xD3BC8E") {
		MouseGetPos &X, &Y
		MouseClick "Left", 1467, 669 ; Max stacks
		Sleep 50
		ClickOnBottomRightButton()
		MouseMove X, Y
		Return
	}
	; =======================================
	; Lock Artifact
	; =======================================
	; Backpack
	If (PixelGetColor(75, 45) = "0xD3BC8E" and PixelGetColor(165, 1010) = "0x3B4255") {
		MouseGetPos &X, &Y
		MouseClick "Left", 1738, 440
		Sleep 50
		MouseMove X, Y
		Return
	}
	; Artifact details
	If (PixelGetColor(75, 70) = "0xD3BC8E" and PixelGetColor(1838, 44) = "0x3B4255") {
		MouseGetPos &X, &Y
		MouseClick "Left", 1825, 440
		Sleep 50
		MouseMove X, Y
		Return
	}
	; Artifacts menu
	If (PixelGetColor(60, 999) = "0x3B4255" and PixelGetColor(558, 1010) = "0x5A5F6C") {
		If not PixelSearch(&FoundX, &FoundY, 1480, 265, 1480, 375, "0xFFCC32")
			Return
		MouseGetPos &X, &Y
		MouseClick "Left", 1780, FoundY - 95
		Sleep 50
		MouseMove X, Y
		Return
	}
	; Artifacts enhancement menu
	If (PixelGetColor(1109, 42) = "0xECE5D8" and PixelGetColor(1181, 547) = "0xECE5D8") {
		MouseGetPos &X, &Y
		MouseClick "Left", 1620, 500
		Sleep 50
		MouseMove X, Y
		Return
	}
	; Domain artifacts
	If (PixelGetColor(720, 500) = "0xECE5D8") {
		If not PixelSearch(&FoundX, &FoundY, 753, 475, 753, 310, "0xFFCC32")
			Return
		MouseGetPos &X, &Y
		MouseClick "Left", 1160, FoundY + 60
		Sleep 50
		MouseMove X, Y
		Return
	}
	; Mystic Offering
	If (PixelGetColor(1663, 1016) = "0x947B2F" and PixelGetColor(989, 580) = "0xECE5D8") {
		MouseGetPos &X, &Y
		MouseClick "Left", 1428, 500
		Sleep 50
		MouseMove X, Y
		Return
	}
	; =======================================
	; Toggle Auto Dialogue
	; =======================================
	If (not IsFullScreenMenuOpen() and not IsGameScreen() and IsDialogueScreen()) {
		MouseGetPos &X, &Y
		MouseClick "Left", 98, 49
		Sleep 50
		MouseMove X, Y
		Return
	}
}

IsAvailableForStock() {
	Color := PixelGetColor(230, 182)
	Return Color = "0xFFFFEF" ; Mora icon
}



; =======================================
; Expeditions
; =======================================

; Recieve all expenition rewards and resend back
~Numpad6:: {
	ParseExpeditions()
	Send "{Esc}"
}

ParseExpeditions() {
	Global
	Loop 5 {
		Expedition := IniRead(GetExpeditions(True), "Expeditions", "Expedition" A_Index, "")
		If (Expedition = "")
			Continue
		Expedition := StrSplit(Expedition, ",")
		CharacterNumberInList := Integer(Expedition[3])
		Duration := Expedition[2]
		Switch (Duration) {
			case "4H": Duration := Duration4H
			case "8H": Duration := Duration8H
			case "12H": Duration := Duration12H
			case "20H": Duration := Duration20H
		}
		Expedition := Expedition[1]
		Switch (Expedition) {
			case "WhisperingWoodsExpedition": Expedition := WhisperingWoodsExpedition
			case "DadaupaGorgeExpedition": Expedition := DadaupaGorgeExpedition
			case "YaoguangShoalExpedition": Expedition := YaoguangShoalExpedition
			case "StormterrorLairExpedition": Expedition := StormterrorLairExpedition
			case "DihuaMarshExpedition": Expedition := DihuaMarshExpedition
			case "JueyunKarstExpedition": Expedition := JueyunKarstExpedition
			case "JinrenIslandExpedition": Expedition := JinrenIslandExpedition
			case "TatarasunaExpedition": Expedition := TatarasunaExpedition
			case "WindriseExpedition": Expedition := WindriseExpedition
			case "MusoujinGorgeExpedition": Expedition := MusoujinGorgeExpedition
			case "WolvendomExpedition": Expedition := WolvendomExpedition
			case "GuyunStoneForestExpedition": Expedition := GuyunStoneForestExpedition
			case "KondaVillageExpedition": Expedition := KondaVillageExpedition
			case "StormbearerMountainsExpedition": Expedition := StormbearerMountainsExpedition
			case "ByakkoPlainExpedition": Expedition := ByakkoPlainExpedition
			case "GuiliPlainsExpedition": Expedition := GuiliPlainsExpedition
			case "DunyuRuinsExpedition": Expedition := DunyuRuinsExpedition
			case "NazuchiBeachExpedition": Expedition := NazuchiBeachExpedition
		}
		ReceiveRewardAndResendOnExpedition(Expedition, Duration, CharacterNumberInList)
	}
}

SelectExpedition(Expedition) {
    ; Click on the world
    WorldY := 160 + (Expedition.MapNumber * 72) ; Initial position + offset between the lines
    MouseClick "Left", 200, WorldY
    Sleep 500

    ; Click on the expedition
    MouseClick "Left", Expedition.X, Expedition.Y
    Sleep 200
}

SelectDuration(Duration) {
    MouseClick "Left", Duration.X, Duration.Y
    Sleep 100
}

; Send character to an expedition.
; CharacterNumberInList - starts from 1.
SendOnExpedition(Expedition, CharacterNumberInList, Duration) {
    SelectExpedition(Expedition)
    SendOnExpeditionSelected(Expedition, CharacterNumberInList, Duration)
}

SendOnExpeditionSelected(Expedition, CharacterNumberInList, Duration) {
    SelectDuration(Duration)

    ; Click on "Select Character"
    ClickOnBottomRightButton()
    Sleep 800

    ; Find and select the character
    FindAndSelectCharacter(CharacterNumberInList)
    Sleep 300
}

FindAndSelectCharacter(CharacterNumberInList) {
    FirstCharacterX := 100
    FirstCharacterY := 150
    SpacingBetweenCharacters := 125

    If (CharacterNumberInList <= 7) {
        MouseClick "Left", FirstCharacterX, FirstCharacterY + (SpacingBetweenCharacters * (CharacterNumberInList - 1))
    } Else {
        ScrollDownCharacterList(CharacterNumberInList - 7.5)
        MouseClick "Left", FirstCharacterX, FirstCharacterY + (SpacingBetweenCharacters * 7)
    }
}

; Scroll down the passed number of characters
ScrollDownCharacterList(CharacterAmount) {
    MouseMove 950, 540

    ScrollAmount := CharacterAmount * 7
    Loop %ScrollAmount% {
        Send "{WheelDown}"
        Sleep 10
    }
}

ReceiveReward(Expedition, ReceiveRewardLag := 0) {
    SelectExpedition(Expedition)

    ; Receive reward
    ClickOnBottomRightButton()
    Sleep 200
    Sleep ReceiveRewardLag

    ; Skip reward menu
    ClickOnBottomRightButton()
    Sleep 200
}

ReceiveRewardAndResendOnExpedition(Expedition, Duration, CharacterNumberInList) {
	ReceiveReward(Expedition)
	SendOnExpeditionSelected(Expedition, CharacterNumberInList, Duration)
}



; =======================================
; Receive all BP exp and rewards
; =======================================

~Numpad8:: {
	Send "{f4}"
	WaitFullScreenMenu()

	ReceiveBpExp()
	ReceiveBpRewards()

	Send "{Esc}"
}

ReceiveBpExp() {
	global RedNotIficationColor

	; Check for available BP experience and receive If any
	Color := PixelGetColor(993, 20)
	If (Color != RedNotIficationColor) {
		Return ; No exp
	}

	MouseClick "Left", 993, 20 ; To exp tab
	Sleep 100

	ClickOnBottomRightButton() ; "Claim all"
	Sleep 200

	If (!IsFullScreenMenuOpen()) {
		; Level up, need to close popup
		Send "{Esc}"
		WaitFullScreenMenu()
	}
}

ReceiveBpRewards() {
	global RedNotIficationColor

	; Check for available BP experience and receive if any
	Color := PixelGetColor(899, 20)
	If (Color != RedNotIficationColor) {
		Return ; no rewards
	}

	MouseClick "Left", 899, 20 ; To rewards tab
	Sleep 100

	ClickOnBottomRightButton() ; "Claim all"
	Sleep 200
	Send "{Esc}" ; Close popup with received rewards
	WaitFullScreenMenu()
}



; =======================================
; Go to the Serenitea Pot
; =======================================

~Numpad5:: {
	OpenInventory()

	MouseClick "Left", 1050, 50 ; Gadgets tab
	WaitPixelColor("0xD3BC8E", 1055, 92, 1000) ; Wait for tab to be active

	MouseClick "Left", 270, 180 ; Select the first gadget
	ClickOnBottomRightButton()

	WaitDialogMenu()
	Send "{f}"
}



; =======================================
; Wait for the next night
; =======================================

~Numpad7:: {
	WaitUntilInGameTime("18")
}

~NumpadSub & Numpad7:: {
	WaitUntilInGameTime("06")
}

WaitUntilInGameTime(Time) {
	OpenMenu()

	MouseClick "Left", 45, 715 ; Clock icon
	WaitPixelColor("0xECE5D8", 1870, 50, 5000) ; Wait for the clock menu

	ClockCenterX := 1440
	ClockCenterY := 501
	Offset := 30

	If (Time = "18") {
		ClickOnClock(ClockCenterX, ClockCenterY + Offset) ; 00:00
		ClickOnClock(ClockCenterX - Offset, ClockCenterY) ; 06:00
		ClickOnClock(ClockCenterX, ClockCenterY - Offset) ; 12:00
		ClickOnClock(ClockCenterX + Offset, ClockCenterY) ; 18:00
	} Else If (Time = "06") {
		ClickOnClock(ClockCenterX, ClockCenterY - Offset) ; 12:00
		ClickOnClock(ClockCenterX + Offset, ClockCenterY) ; 18:00
		ClickOnClock(ClockCenterX, ClockCenterY + Offset) ; 00:00
		ClickOnClock(ClockCenterX - Offset, ClockCenterY - 1) ; 06:00
	} Else {
		throw "Unexpected time argument" . Time
	}

	MouseClick "Left", 1440, 1000 ; "Confirm" button

	Sleep 100
	WaitPixelColor("0xECE5D8", 1870, 50, 30000) ; Wait for the clock menu

	Send "{Esc}"
	WaitMenu()

	Send "{Esc}"
}

ClickOnClock(X, Y) {
	MouseClick "Left", X, Y, , , "Down"
	Sleep 50
	MouseClick "Left", X, Y, , , "Up"
	Sleep 100
}



; =======================================
; Relogin
; =======================================

~NumpadDot:: {
	OpenMenu()

	MouseClick "Left", 49, 1022 ; Logout button
	WaitPixelColor("0x313131", 1017, 757, 5000) ; Wait logout menu

	MouseClick "Left", 1197, 759 ; Confirm
	WaitPixelColor("0x222222", 1823, 794, 15000) ; Wait for settings icon

	MouseClick "Left", 500, 500
	Sleep 500 ; Time for settings icon to disappear
	WaitPixelColor("0x222222", 1823, 794, 15000) ; Wait for settings icon again

	MouseClick "Left", 600, 500
}
