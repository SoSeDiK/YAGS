#SingleInstance Force
#Include "Libs.ahk"
#HotIf WinActive(GameProcessName)
#NoTrayIcon

OnMessage 0x4000, SetSuspended



Global BuyingMode := False
Global LastMouseX := 0
Global LastMouseY := 0



SetupHotkeys()



; =======================================
; Quick buying things in shops
; Made for artifacts, weapons, and tea pot
; Should work in other shops too
; =======================================

; Buy as much as possible
OnXButton1(*) {
	Global
	If (BuyingMode) {
		StopBuyingAll()
		Return
	}
	
	MouseGetPos &X, &Y
	LastMouseX := X
	LastMouseY := Y
	
	BuyingMode := True
	BuyAllAvailable()
}

; Buy once
OnXButton2(*) {
	Global
	If (BuyingMode) {
		StopBuyingAll()
		Return
	}
	BuyAvailable()
}

IsShopMenu() {
	Return PixelGetColor(80, 50) = "0xD3BC8E" and PixelGetColor(1840, 46) = "0x3B4255" and PixelGetColor(1740, 995) = "0xECE5D8"
}

IsAvailableForStock() {
	Return PixelGetColor(1770, 930) != "0xE5967E" ; Sold out
}

BuyAllAvailable() {
	Global
	While IsShopMenu() and IsAvailableForStock() {
		If not BuyingMode
			Return
		BuyOnce()
		SetTimer BuyAllAvailable, -400
		Return
	}
	StopBuyingAll()
}

StopBuyingAll() {
	Global
	BuyingMode := False
	SetTimer BuyAllAvailable, 0
	Sleep 30
	MouseMove LastMouseX, LastMouseY
}

BuyAvailable() {
	If IsShopMenu() {
		MouseGetPos &X, &Y
		BuyOnce()
		Sleep 30
		MouseMove X, Y
	}
}

BuyOnce() {
	ClickOnBottomRightButton()
	If not WaitPixelColor("0x4A5366", 1050, 750, 1000, True) ; Wait for tab to be active
		Return
	MouseClick "Left", 1178, 625 ; Max stacks
	Sleep 10
	MouseClick "Left", 1050, 750 ; Click Exchange
	WaitPixelColor("0xD3BC8E", 1060, 280, 1000)
	ClickOnBottomRightButton() ; Skip purchased dialogue
}



SetupHotkeys() {
	Mapping := GetSetting("SwapSideMouseButtons", "0", True)
	XButtonF := Mapping ? "XButton1" : "XButton2"
	XButtonS := Mapping ? "XButton2" : "XButton1"
	HotIfWinActive(GameProcessName)
	Hotkey "*" XButtonF, OnXButton1, "Off"
	Hotkey "*" XButtonS, OnXButton2, "Off"
	Hotkey "*" XButtonF, OnXButton1, "On"
	Hotkey "*" XButtonS, OnXButton2, "On"
}



SetSuspended(Suspended, *) {
	Global
	If (Suspended = 3) {
		SetupHotkeys()
		Return
	}
	Suspend Suspended
}
