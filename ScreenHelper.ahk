; =======================================
;
; Simple script to show the mouse
; coordinates and detect on-screen colors
;
; F6 to copy the current color
; F7 to copy the current coordinates
; F8 to copy both color and coordinates
;
; F12 to toggle the helping tooltip
;
; Use the arrow keys to move the cursor
; by 1 pixel
;
; =======================================
#Requires AutoHotkey v2.0-beta

#SingleInstance Force


; Rerun script with the administrator privileges if required
If (not A_IsAdmin) {
	Try {
		Run '*RunAs "' A_ScriptFullPath '"'
	} Catch {
		MsgBox "Failed to run the script with administrator privileges"
	}
	ExitApp
}


Global Toggle := True


CoordMode "Mouse", "Client"
SetTimer WatchCursor, 100


~*f6:: {
	MouseGetPos &x, &y
	color := PixelGetColor(x, y)
	A_Clipboard := color
	x += 10
	y -= 30
	ToolTip "Copied! " color, x, y, 2
	Sleep 1000
	ToolTip , , , 2
}


~*f7:: {
	MouseGetPos &x, &y
	Coords := x ", " y
	A_Clipboard := Coords
	x += 10
	y -= 30
	ToolTip "Copied! " Coords, x, y, 2
	Sleep 1000
	ToolTip , , , 2
}


~*f8:: {
	MouseGetPos &x, &y
	color := PixelGetColor(x, y)
	Coords := 'IsColor(' x ', ' y ', "' color '")'
	A_Clipboard := Coords
	x += 10
	y -= 30
	ToolTip "Copied! " x ", " y " : " color, x, y, 2
	Sleep 1000
	ToolTip , , , 2
}

*Up:: {
	MouseGetPos &x, &y
	MouseMove x, y - 1
}

*Down:: {
	MouseGetPos &x, &y
	MouseMove x, y + 1
}

*Left:: {
	MouseGetPos &x, &y
	MouseMove x - 1, y
}

*Right:: {
	MouseGetPos &x, &y
	MouseMove x + 1, y
}

*F12:: {
	Toggle := !Toggle
	If not Toggle
		ToolTip , , , 2
}
	


WatchCursor() {
	Global
	If not Toggle
		Return
	MouseGetPos &x, &y
	color := PixelGetColor(x, y)
	ToolTip x " " y "`nColor: " color "`nF6-F8: Color, Coords, Both"
}
