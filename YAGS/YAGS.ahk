; =======================================
; YetAnotherGenshinScript
; 				~SoSeDiK's Edition
; =======================================

#SingleInstance Force
#Include "data/scripts/Libs.ahk"

TraySetIcon "data/genicon.ico", , 1



; Rerun script with the administrator rights if required
If !A_IsAdmin {
	try {
		Run '*RunAs "' A_ScriptFullPath '"'
	} catch {
		MsgBox "Failed to run the script with administrator rights"
		ExitApp
	}
}



Global QuickPickupBindingsEnabled := True
Global MapBindingsEnabled := True
Global AutoFisinghBindingsEnabled := True
Global GameScreenBindingsEnabled := True



Global AutoPickupEnabled := GetSetting("AutoPickup", True)
Global AutoPickupBindingsEnabled := AutoPickupEnabled
Global AutoUnfreezeEnabled := GetSetting("AutoUnfreeze", True)
Global AutoUnfreezeBindingsEnabled := AutoUnfreezeEnabled
Global AutoFishEnabled := GetSetting("AutoFish", True)
Global AutoFishBindingsEnabled := AutoFishEnabled
Global EasierCombatEnabled := GetSetting("EasierCombat", True)
Global EasierCombatBindingsEnabled := EasierCombatEnabled



; =======================================
; Configure Tray
; =======================================
SetupTray()
SetupTray() {
	ScriptTray := A_TrayMenu
	ScriptTray.Delete()
	ScriptTray.Add(Langed("Show"), ShowGui)
	ScriptTray.Default := Langed("Show")
	ScriptTray.Add()
	ScriptTray.Add(Langed("Exit"), ButtonQuit)
}


; =======================================
; Configure GUI
; =======================================
Global ScriptGui := Gui()

SetupGui()
SetupGui() {
	Global
	ScriptGui.BackColor := "F9F1F0"

	ScriptGui.Title := Langed("Title", "Yet Another Genshin Script")
	ScriptGuiTabs := ScriptGui.Add("Tab3", "x0 y0 w469 h277", [Langed("Settings"), Langed("Links"), Langed("Expeditions")])


	ScriptGuiTabs.UseTab(1)

	ScriptGui.Add("GroupBox", "x8 y25 w250 h100", Langed("Tasks"))
	ScriptGui.Add("Checkbox", "vAutoPickup x15 y45 " (AutoPickupEnabled ? "Checked" : ""), Langed("AutoPickup", "Auto pickup items"))
	ScriptGui["AutoPickup"].OnEvent("Click", ToggleFeature.Bind(&AutoPickupEnabled, &AutoPickupBindingsEnabled, "AutoPickup"))
	ScriptGui.Add("Checkbox", "vAutoUnfreeze " (AutoUnfreezeEnabled ? "Checked" : ""), Langed("AutoUnfreeze", "Auto unfreeze/unbubble"))
	ScriptGui["AutoUnfreeze"].OnEvent("Click", ToggleFeature.Bind(&AutoUnfreezeEnabled, &AutoUnfreezeBindingsEnabled, "AutoUnfreeze"))
	ScriptGui.Add("Checkbox", "vAutoFish " (AutoFishEnabled ? "Checked" : ""), Langed("AutoFish", "Auto fishing"))
	ScriptGui["AutoFish"].OnEvent("Click", ToggleFeature.Bind(&AutoFishEnabled, &AutoFishBindingsEnabled, "AutoFish"))
	ScriptGui.Add("Checkbox", "vEasierCombat " (EasierCombatEnabled ? "Checked" : ""), Langed("EasierCombat", "Lazy combat mode"))
	ScriptGui["EasierCombat"].OnEvent("Click", ToggleFeature.Bind(&EasierCombatEnabled, &EasierCombatBindingsEnabled, "EasierCombat"))

	ScriptGui.Add("GroupBox", "x8 y130 w250 h60", Langed("Options"))
	ScriptGui.Add("Checkbox", "vSwapSideMouseButtons x15 y150 " (GetSetting("SwapSideMouseButtons", "0") ? "Checked" : ""), Langed("SwapSideMouseButtons", "Swap side mouse buttons"))
	ScriptGui["SwapSideMouseButtons"].OnEvent("Click", SwapSideMouseButtons)

	ScriptGui.Add("Picture", "x235 y26 w242 h246 +BackgroundTrans", "data/Venti.png")

	ScriptGui.Add("GroupBox", "x8 y230 w65 h43", Langed("Language", "English"))
	ScriptGui.Add("Picture", "x14 y245 w24 h24 +BackgroundTrans", "data/lang_en.png").OnEvent("Click", UpdateLanguage.Bind("en"))
	ScriptGui.Add("Picture", "x42 y245 w24 h24 +BackgroundTrans", "data/lang_ru.png").OnEvent("Click", UpdateLanguage.Bind("ru"))


	ScriptGuiTabs.UseTab(2)

	Loop 3 {
		X := 8 + 152 * (A_Index - 1)
		ScriptGui.Add("GroupBox", "y24 w147 h244 x" X, Langed("LinksTab" A_Index))
		Links := IniRead("data/links.ini", "LinksTab" A_Index)
		Links := StrSplit(Links, "`n")
		X := 16 + X
		Loop Links.Length {
			Data := StrSplit(Links[A_Index], "=")
			LinkName := Data[1]
			Link := Data[2]
			Y := 24 + 24 * A_Index
			Options := "w120 h23 x" X " y" Y
			ScriptGui.Add("Link", Options, '<a href="' Link '">' LinkName '</a>')
		}
	}

	ScriptGuiTabs.UseTab(3)

	ScriptGui.Add("GroupBox", "x8 y24 w315 h150", Langed("ExpeditionsTab", "Expedition, Duration, Character Number In List"))

	Expeditions := Array()
	Expeditions.Push("DoNotSend")
	Expeditions.Push("WhisperingWoodsExpedition")
	Expeditions.Push("DadaupaGorgeExpedition")
	Expeditions.Push("YaoguangShoalExpedition")
	Expeditions.Push("StormterrorLairExpedition")
	Expeditions.Push("DihuaMarshExpedition")
	Expeditions.Push("JueyunKarstExpedition")
	Expeditions.Push("JinrenIslandExpedition")
	Expeditions.Push("TatarasunaExpedition")
	Expeditions.Push("WindriseExpedition")
	Expeditions.Push("MusoujinGorgeExpedition")
	Expeditions.Push("WolvendomExpedition")
	Expeditions.Push("GuyunStoneForestExpedition")
	Expeditions.Push("KondaVillageExpedition")
	Expeditions.Push("StormbearerMountainsExpedition")
	Expeditions.Push("ByakkoPlainExpedition")
	Expeditions.Push("GuiliPlainsExpedition")
	Expeditions.Push("DunyuRuinsExpedition")
	Expeditions.Push("NazuchiBeachExpedition")

	Durations := ["4H", "8H", "12H", "20H"]

	Loop 5 {
		Expedition := IniRead(GetExpeditions(), "Expeditions", "Expedition" A_Index, "")
		If (Expedition = "")
			Expedition := ",,"
		Else
			Expedition := StrSplit(Expedition, ",")

		CharacterNumberInList := Integer(Expedition[3])

		Duration := Expedition[2]
		For Index, Value in Durations {
			If (Duration = Value) {
				Duration := Index
				Break
			}
		}

		Expedition := Expedition[1]
		ExpeditionNum := 1

		ExpeditionsDisplay := Array()
		For Index, Value in Expeditions {
			If (Expedition = Value)
				ExpeditionNum := Index
			If (Index = 1)
				ExpeditionsDisplay.Push(Langed(Value, Value))
			Else If (Index < 5)
				ExpeditionsDisplay.Push("💎 " Langed(Value, Value))
			Else If (Index < 10)
				ExpeditionsDisplay.Push("💰 " Langed(Value, Value))
			Else If (Index < 12)
				ExpeditionsDisplay.Push("🥩 " Langed(Value, Value))
			Else If (Index < 15)
				ExpeditionsDisplay.Push("🥕 " Langed(Value, Value))
			Else If (Index < 17)
				ExpeditionsDisplay.Push("🌷 " Langed(Value, Value))
			Else If (Index < 19)
				ExpeditionsDisplay.Push("🌸 " Langed(Value, Value))
			Else
				ExpeditionsDisplay.Push("📜 " Langed(Value, Value))
		}

		Y := 20 + 25 * A_Index
		Exped := ScriptGui.Add("DropDownList", "vExpedition" A_Index " x16 w180 Choose" ExpeditionNum " y" Y, ExpeditionsDisplay)
		Exped.OnEvent("Change", UpdateExpeditions.Bind(Expeditions, A_Index))

		Durat := ScriptGui.Add("DropDownList", "vDuration" A_Index " x205 w50 Choose" Duration " y" Y, Durations)
		Durat.OnEvent("Change", UpdateExpeditions.Bind(Expeditions, A_Index))

		Chars := ScriptGui.Add("Edit", "x265 y45 w50" " y" Y)
		Chars.OnEvent("Change", UpdateExpeditions.Bind(Expeditions, A_Index))
		Chars := ScriptGui.Add("UpDown", "vCharacters" A_Index " Range1-30", CharacterNumberInList)
		Chars.OnEvent("Change", UpdateExpeditions.Bind(Expeditions, A_Index))
	}


	ScriptGuiTabs.UseTab()

	ScriptGui.Add("Text", "x20 y295", Langed("Wish") "       ").SetFont("bold")
	HideButton := ScriptGui.Add("Button", "x330 y280 w70 h35", Langed("Hide", "Hide to tray"))
	HideButton.OnEvent("Click", ButtonHide)
	QuitButton := ScriptGui.Add("Button", "x410 y280 w55 h35", Langed("Quit"))
	QuitButton.OnEvent("Click", ButtonQuit)


	ScriptGui.Show()
}

ToggleFeature(&Feature, &FeatureBinding, FeatureName, *) {
	Global
	Feature := ScriptGui[FeatureName].Value
	UpdateSetting(FeatureName, Feature)
	If not Feature {
		FeatureBinding := False
		UpdateScriptState(FeatureName, 0)
	}
}

SwapSideMouseButtons(*) {
	UpdateSetting("SwapSideMouseButtons", ScriptGui["SwapSideMouseButtons"].Value)
	UpdateScriptState("QuickShopBuying", 3)
	UpdateScriptState("SimpleJump", 3)
	UpdateScriptState("QuickPickup", 3)
}

UpdateExpeditions(Expeditions, ExpeditionNum, *) {
	ExpeditionName := Expeditions[ScriptGui["Expedition" ExpeditionNum].Value]
	Duration := ScriptGui["Duration" ExpeditionNum].Text
	CharacterNumberInList := ScriptGui["Characters" ExpeditionNum].Value
	IniWrite ExpeditionName "," Duration "," CharacterNumberInList, GetExpeditions(), "Expeditions", "Expedition" ExpeditionNum
}

UpdateLanguage(Lang, *) {
	Global
	If (Lang = GetSetting("Language", "en"))
		Return
	UpdateSetting("Language", Lang)
	ScriptGui.GetPos(&x, &y)
	ScriptGui.Destroy()
	ScriptGui := Gui()
	SetupGui()
	SetupTray()
	ScriptGui.Move(x, y)
}



; =======================================
; Run tasks
; =======================================
ScriptsDir := A_ScriptDir "/data/scripts/"
Run '*RunAs "' ScriptsDir 	'AutoWalk' 				'.ahk"', , , &AutoWalkThread
Run '*RunAs "' ScriptsDir 	'QuickShopBuying' 		'.ahk"', , , &QuickShopBuying
Run '*RunAs "' ScriptsDir 	'QuickActions' 			'.ahk"', , , &QuickActionsThread
Run '*RunAs "' ScriptsDir 	'TimeSkip' 				'.ahk"', , , &TimeSkipThread
Run '*RunAs "' ScriptsDir 	'BetterMapClick' 		'.ahk"', , , &BetterMapClickThread
Run '*RunAs "' ScriptsDir 	'BetterCharacterSwitch' '.ahk"', , , &BetterCharacterSwitchThread
Run '*RunAs "' ScriptsDir 	'QuickPartySwitch' 		'.ahk"', , , &QuickPartySwitchThread
Run '*RunAs "' ScriptsDir 	'QuickPickup' 			'.ahk"', , , &QuickPickupThread
Run '*RunAs "' ScriptsDir 	'SimpleJump' 			'.ahk"', , , &SimpleJumpThread
Run '*RunAs "' ScriptsDir 	'EasierCombat' 			'.ahk"', , , &EasierCombatThread
Run '*RunAs "' ScriptsDir 	'AutoPickup' 			'.ahk"', , , &AutoPickupThread
Run '*RunAs "' ScriptsDir 	'AutoUnfreeze' 			'.ahk"', , , &AutoUnfreezeThread
Run '*RunAs "' ScriptsDir 	'AlternateVision' 		'.ahk"', , , &AlternateVisionThread
Run '*RunAs "' ScriptsDir 	'AutoFish' 				'.ahk"', , , &AutoFishThread
Run '*RunAs "' ScriptsDir 	'AutoAttackMode' 		'.ahk"', , , &AutoAttackModeThread

; Lazy workaround for when the user reruns the script multiple times without closing it first
Sleep 300

If not AutoPickupEnabled
	UpdateScriptState("AutoPickup", 0)
If not AutoUnfreezeEnabled
	UpdateScriptState("AutoUnfreeze", 0)
If not AutoFishEnabled
	UpdateScriptState("AutoFish", 0)
If not EasierCombatEnabled
	UpdateScriptState("EasierCombat", 0)

SetTimer SuspendOnGameInactive, -1



ConfigureContextualBindings() {
	Global
	FullScreenMenu := IsFullScreenMenuOpen()
	MapMenu := FullScreenMenu and PixelGetColor(27, 427) = "0xEDE5DA" ; Resin "+" symbol
	GameScreen := not FullScreenMenu and IsGameScreen()
	DialogueActive := not FullScreenMenu and not GameScreen and IsDialogueScreen()
	FishingActive := GameScreen and PixelGetColor(1626, 1029) = "0xFFE92C" ; Is 3rd action icon bound to LMB
	
	If (MapBindingsEnabled and not MapMenu) {
		UpdateScriptState("BetterMapClick", 0)
		MapBindingsEnabled := False
	} Else If (not MapBindingsEnabled and MapMenu) {
		UpdateScriptState("BetterMapClick", 1)
		MapBindingsEnabled := True
	}
	
	If AutoFishEnabled {
		If (not AutoFisinghBindingsEnabled and FishingActive) {
			UpdateScriptState("AutoFish", 1)
			AutoFisinghBindingsEnabled := True
		} Else If (AutoFisinghBindingsEnabled and not FishingActive) {
			UpdateScriptState("AutoFish", 0)
			AutoFisinghBindingsEnabled := False
		}
	}
	
	If AutoPickupEnabled {
		If (not AutoPickupBindingsEnabled and GameScreen and not FishingActive) {
			UpdateScriptState("AutoPickup", 1)
			AutoPickupBindingsEnabled := True
		} Else If (AutoPickupBindingsEnabled and (not GameScreen or FishingActive)) {
			UpdateScriptState("AutoPickup", 0)
			AutoPickupBindingsEnabled := False
		}
	}
	
	If AutoUnfreezeEnabled {
		If (not AutoUnfreezeBindingsEnabled and GameScreen) {
			UpdateScriptState("AutoUnfreeze", 1)
			AutoUnfreezeBindingsEnabled := True
		} Else If (AutoUnfreezeBindingsEnabled and not GameScreen) {
			UpdateScriptState("AutoUnfreeze", 0)
			AutoUnfreezeBindingsEnabled := False
		}
	}
	
	If EasierCombatEnabled {
		If (not EasierCombatBindingsEnabled and GameScreen and not FishingActive) {
			UpdateScriptState("EasierCombat", 1)
			EasierCombatBindingsEnabled := True
		} Else If (EasierCombatBindingsEnabled and (not GameScreen or FishingActive)) {
			UpdateScriptState("EasierCombat", 0)
			EasierCombatBindingsEnabled := False
		}
	}
	
	If (not GameScreenBindingsEnabled and GameScreen) {
		UpdateScriptState("AutoWalk", 1)
		UpdateScriptState("AlternateVision", 1)
		UpdateScriptState("AutoAttackMode", 1)
		UpdateScriptState("BetterCharacterSwitch", 1)
		GameScreenBindingsEnabled := True
	} Else If (GameScreenBindingsEnabled and not GameScreen) {
		UpdateScriptState("AutoWalk", 0)
		UpdateScriptState("AlternateVision", 0)
		UpdateScriptState("AutoAttackMode", 0)
		UpdateScriptState("BetterCharacterSwitch", 0)
		GameScreenBindingsEnabled := False
	}
	
	If (not QuickPickupBindingsEnabled and (GameScreen or DialogueActive)) {
		UpdateScriptState("QuickPickup", 1)
		UpdateScriptState("QuickShopBuying", 0)
		QuickPickupBindingsEnabled := True
	} Else If (QuickPickupBindingsEnabled and (not GameScreen and not DialogueActive)) {
		UpdateScriptState("QuickPickup", 0)
		UpdateScriptState("QuickShopBuying", 1)
		QuickPickupBindingsEnabled := False
	}
}



SuspendOnGameInactive() {
	Loop {
		WinWaitActive GameProcessName
		SetTimer ConfigureContextualBindings, 250

		WinWaitNotActive GameProcessName
		SetTimer ConfigureContextualBindings, 0
	}
}



ExitYAGS() {
	CloseScript(AutoWalkThread)
	CloseScript(QuickShopBuying)
	CloseScript(QuickActionsThread)
	CloseScript(TimeSkipThread)
	CloseScript(BetterMapClickThread)
	CloseScript(BetterCharacterSwitchThread)
	CloseScript(QuickPartySwitchThread)
	CloseScript(QuickPickupThread)
	CloseScript(SimpleJumpThread)
	CloseScript(EasierCombatThread)
	CloseScript(AutoPickupThread)
	CloseScript(AutoUnfreezeThread)
	CloseScript(AlternateVisionThread)
	CloseScript(AutoFishThread)
	CloseScript(AutoAttackModeThread)
	ExitApp
}

CloseScript(ScriptName) {
	ScriptName := "ahk_pid " ScriptName
	If WinExist(ScriptName)
		WinClose ScriptName
}



ButtonQuit(*) {
	ExitYAGS()
}

ButtonHide(*) {
	ScriptGui.Hide()
}

ShowGui(*) {
	ScriptGui.Show()
}



; Exit script
$End:: {
	ExitYAGS()
}
