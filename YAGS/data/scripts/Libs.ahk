; =======================================
; Util functions
; =======================================

; Static variables
Global GameProcessName := "ahk_exe GenshinImpact.exe"

Global LightMenuColor := "0xECE5D8"



DetectHiddenWindows True



OpenMenu() {
	Send "{Esc}"
	WaitMenu()
}

WaitMenu() {
	WaitPixelColor(LightMenuColor, 729, 63, 2000) ; Wait for menu
}

OpenInventory() {
	Send "{b}"
	WaitFullScreenMenu(2000)
}

ClickOnBottomRightButton() {
	MouseClick "Left", 1730, 1000
}

WaitFullScreenMenu(Timeout := 3000) {
	WaitPixelColor(LightMenuColor, 1859, 47, Timeout) ; Wait for close button on the top right
}

IsFullScreenMenuOpen() {
	Color := PixelGetColor(1859, 47)
	If (Color = LightMenuColor)
		Return True
	Color := PixelGetColor(1875, 35)
	Return Color = LightMenuColor
}

; Note: always better to check if not IsFullScreenMenuOpen() before checking the game screen
IsGameScreen() {
	Return PixelGetColor(276, 58) = "0xFFFFFF" ; Eye icon next to the map
}

; Note: always better to check if not IsFullScreenMenuOpen() and not IsGameScreen() before checking the dialogue screen
IsDialogueScreen() {
	Return PixelGetColor(86, 48) = "0xECE5D8" ; Play or Pause button
}

IsInBoat() {
	Return PixelGetColor(828, 976) = "0xEDE5D9" ; Boat icon color
}

WaitDeployButtonActive(Timeout) {
	WaitPixelColor("0x313131", 1557, 1005, Timeout) ; Wait for close button on the top right
}

WaitDialogMenu() {
	WaitPixelColor("0x656D77", 1180, 537, 2000) ; Wait for "..." icon in the center of the screen
}

; Check if a character is frozen or in the bubble
IsFrozen() {
	SpaceTextColor := PixelGetColor(1417, 596)

	If (SpaceTextColor != "0x333333") {
		Return False
	}

	SpaceButtonColor := PixelGetColor(1417, 585)

	Return SpaceButtonColor = "0xFFFFFF"
}

; Check if run should be infinite
IsExtraRun() {
	Color := PixelGetColor(1695, 1030)
	Return Color == "0xFFE92C" ; Ayaka / Mona run mode
}

; Special click function for the world map menu.
;
; For some reason MouseClick (and Click) doesn't work consistently: it doesn't work if a click goes to an empty place,
; but works fine if a click goes to an interactable point.
MapClick() {
	Send "{LButton down}"
	Sleep 50
	Send "{LButton up}"
}

MoveCursorToCenter() {
	MouseMove A_ScreenWidth / 2, A_ScreenHeight / 2
}

; Wait for pixel to be the specified color or throw exception after the specified Timeout.
;
; Color - hex string in RGB format, for example "0xA0B357".
; Timeout - timeout in milliseconds.
; ReturnOnTimeout - whether to return False instead of throwing an exception on timeout
WaitPixelColor(Color, X, Y, Timeout, ReturnOnTimeout := False) {
	StartTime := A_TickCount
	Loop {
		CurrentColor := PixelGetColor(X, Y)
		If (CurrentColor = Color) {
			Return True
		} If (A_TickCount - StartTime >= Timeout) {
			If ReturnOnTimeout
				Return False
			throw Error("Timeout " . Timeout . " ms")
		}
	}
}

; Wait to at least one pixel of the specified color to appear in the corresponding region.
;
; Regions - array of objects that must have the following fields:
;	 X1, Y1, X2, Y2 - region coordinates;
;	 Color - pixel color to wait.
; Returns found region or throws exception
WaitPixelsRegions(Regions, Timeout := 1000) {
	StartTime := A_TickCount
	Loop {
		For Index, Region in Regions {
			X1 := Region.X1
			X2 := Region.X2
			Y1 := Region.Y1
			Y2 := Region.Y2
			Color := Integer(Region.Color)

			If PixelSearch(&FoundX, &FoundY, X1, Y1, X2, Y2, Color) {
				Return Region
			}
		}

		If (A_TickCount - StartTime >= Timeout) {
			throw Error("Timeout " . Timeout . " ms")
		}
	}
}



; =======================================
; Some util methods
; =======================================

UpdateScriptState(Script, State) {
	If (State = 0 or State = 1)
		State := not State
	PostMessage(0x4000, State, , , Script ".ahk ahk_class AutoHotkey")
}

GetSettings(SideScript := False) {
	Return SideScript ? A_ScriptDir "/../settings.ini" : A_ScriptDir "/data/settings.ini"
}

GetExpeditions(SideScript := False) {
	Return SideScript ? A_ScriptDir "/../expeditions.ini" : A_ScriptDir "/data/expeditions.ini"
}

GetSetting(Setting, Def, SideScript := False) {
	Return IniRead(GetSettings(SideScript), "Settings", Setting, Def)
}
