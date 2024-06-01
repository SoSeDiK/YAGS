﻿; =======================================
; YetAnotherGenshinScript
; 				~SoSeDiK's Edition
; ToDo:
; - Fill "Controls" page (possibly even changing hotkeys?)
; - Rework Auto Pickup
; - Rework Auto Attack module (customizable sequences?)
; - Support different screen resolutions?
; =======================================
#Requires AutoHotkey v2.0

#SingleInstance Force

#Include "Doomsday.ahk" ; Assets generator

TraySetIcon ".\yags_data\graphics\genicon.ico", , 1
A_HotkeyInterval := 0 ; Disable delay between hotkeys to allow many at once
Thread "interrupt", 0 ; Make all threads always-interruptible
SetTitleMatchMode "RegEx" ; Allow matching title by regex (to support multiple versions)

Global ScriptVersion := "1.1.5"



; Rerun script with the administrator privileges if required
If (not A_IsAdmin) {
	Try {
		Run '*RunAs "' A_ScriptFullPath '"'
	} Catch {
		MsgBox "Failed to run the script with administrator privileges"
	}
	ExitApp
}



Global VersionState := "Unchecked"
If (GetSetting("AutoUpdatesCheck", True))
	CheckForUpdates()

EnableReloadScriptHotkey()
EnableExitScriptHotkey()





; Static variables
Global GameProcessName := "ahk_exe (GenshinImpact|YuanShen)\.exe$"

Global LightMenuColor := "0xECE5D8"



Global ScriptEnabled := False
Global ScriptPaused := False


; Tasks
Global AutoPickupEnabled := GetSetting("AutoPickup", True)
Global AutoPickupBindingsEnabled := False

Global AutoUnfreezeEnabled := GetSetting("AutoUnfreeze", True)
Global AutoUnfreezeBindingsEnabled := False

Global AutoFishingEnabled := GetSetting("AutoFishing", True)
Global AutoFishingBindingsEnabled := False


; Features
Global ImprovedFishingEnabled := GetSetting("ImprovedFishing", True)
Global ImprovedFishingBindingsEnabled := False

Global AutoWalkEnabled := GetSetting("AutoWalk", True)
Global AutoWalkBindingsEnabled := False

Global SimplifiedJumpEnabled := GetSetting("SimplifiedJump", True)
Global SimplifiedJumpBindingsEnabled := False

Global QuickPickupEnabled := GetSetting("QuickPickup", True)
Global QuickPickupBindingsEnabled := False

Global SimplifiedCombatEnabled := GetSetting("SimplifiedCombat", True)
Global SimplifiedCombatBindingsEnabled := False

Global EasierChargedAttackEnabled := GetSetting("EasierChargedAttack", True)
Global EasierChargedAttackBindingsEnabled := False

Global DialogueSkippingEnabled := GetSetting("DialogueSkipping", True)
Global DialogueSkippingBindingsEnabled := False

Global BetterCharacterSwitchEnabled := GetSetting("BetterCharacterSwitch", True)
Global BetterCharacterSwitchBindingsEnabled := False

Global AlternateVisionEnabled := GetSetting("AlternateVision", True)
Global AlternateVisionBindingsEnabled := False

Global BetterMapClickEnabled := GetSetting("BetterMapClick", True)
Global BetterMapClickBindingsEnabled := False

Global AutoAttackEnabled := GetSetting("AutoAttack", True)
Global AutoAttackBindingsEnabled := False

Global LazySigilEnabled := GetSetting("LazySigil", True)
Global LazySigilBindingsEnabled := False


; Quick Actions
Global MenuActionsEnabled := GetSetting("MenuActions", True)
Global MenuActionsBindingsEnabled := False

Global QuickPartySwitchEnabled := GetSetting("QuickPartySwitch", True)
Global QuickPartySwitchBindingsEnabled := False

Global QuickShopBuyingEnabled := GetSetting("QuickShopBuying", True)
Global QuickShopBindingsEnabled := False

Global ClockManagementEnabled := GetSetting("ClockManagement", True)
Global ClockManagementBindingsEnabled := False

Global SereniteaPotEnabled := GetSetting("SereniteaPot", True)
Global SereniteaPotBindingsEnabled := False

Global ReceiveBPRewardsEnabled := GetSetting("ReceiveBPRewards", True)
Global ReceiveBPRewardsBindingsEnabled := False

Global ReloginEnabled := GetSetting("Relogin", True)
Global ReloginBindingsEnabled := False





; =======================================
; Configure GUI
; =======================================
Global ScriptGui := Gui()
Global GuiTooltips := Map()
SetupGui()
ToggleExtraHotkeys()
SetupGui() {
	Global
	;ScriptGui.Opt("+LastFound +Resize MinSize530x470")
	ScriptGui.BackColor := "F9F1F0"

	Switch (VersionState) {
		Case "Indev": TitleVer := "0.0.1 [Indev]"
		Case "Outdated": TitleVer := ScriptVersion " [Outdated]"
		Default: TitleVer := ScriptVersion
	}
	ScriptGui.Title := Langed("Title", "Yet Another Genshin Script") " v" TitleVer
	ScriptGuiTabs := ScriptGui.Add("Tab3", "x0 y0 w530 h470", [Langed("Settings"), Langed("Links"), Langed("Controls")])

	ScriptGui.OnEvent("Close", ButtonQuit)

	; Main page
	ScriptGuiTabs.UseTab(1)

	; Features
	ScriptGui.Add("GroupBox", "x8 y25 w250 h260", "")
	ScriptGui.Add("Text", "xp+7 yp", " " Langed("Features") " ")

	AddTask("AutoWalk", &AutoWalkEnabled, DisableFeatureAutoWalk)
	AddTask("SimplifiedJump", &SimplifiedJumpEnabled, DisableFeatureSimplifiedJump)
	AddTask("QuickPickup", &QuickPickupEnabled, DisableFeatureQuickPickup)
	AddTask("SimplifiedCombat", &SimplifiedCombatEnabled, DisableFeatureSimplifiedCombat)
	AddTask("EasierChargedAttack", &EasierChargedAttackEnabled, DisableFeatureEasierChargedAttack)
	AddTask("DialogueSkipping", &DialogueSkippingEnabled, DisableFeatureDialogueSkipping)
	AddTask("BetterCharacterSwitch", &BetterCharacterSwitchEnabled, DisableFeatureBetterCharacterSwitch)
	AddTask("ImprovedFishing", &ImprovedFishingEnabled, DisableFeatureImprovedFishing)
	AddTask("AlternateVision", &AlternateVisionEnabled, DisableFeatureAlternateVision)
	AddTask("BetterMapClick", &BetterMapClickEnabled, DisableFeatureBetterMapClick)
	AddTask("AutoAttack", &AutoAttackEnabled, DisableFeatureAutoAttack)
	AddTask("LazySigil", &LazySigilEnabled, DisableFeatureLazySigil)

	; Quick Actions
	ScriptGui.Add("GroupBox", "x8 y290 w250 h180", "")
	ScriptGui.Add("Text", "xp+7 yp", " " Langed("QuickActions") " ")

	AddTask("MenuActions", &MenuActionsEnabled, DisableFeatureMenuActions)
	AddTask("QuickPartySwitch", &QuickPartySwitchEnabled, DisableFeatureQuickPartySwitch)
	AddTask("QuickShopBuying", &QuickShopBuyingEnabled, DisableFeatureQuickShopBuying)
	AddTask("ClockManagement", &ClockManagementEnabled, DisableFeatureClockManagement)
	AddTask("SereniteaPot", &SereniteaPotEnabled, DisableFeatureSereniteaPot)
	AddTask("ReceiveBPRewards", &ReceiveBPRewardsEnabled, DisableFeatureReceiveBPRewards)
	AddTask("Relogin", &ReloginEnabled, DisableFeatureRelogin)

	; Tasks
	ScriptGui.Add("GroupBox", "x270 y25 w250 h80", "")
	ScriptGui.Add("Text", "xp+7 yp", " " Langed("Tasks") " ")

	AddTask("AutoPickup", &AutoPickupEnabled, DisableFeatureAutoPickup)
	AddTask("AutoUnfreeze", &AutoUnfreezeEnabled, DisableFeatureAutoUnfreeze)
	AddTask("AutoFishing", &AutoFishingEnabled, DisableFeatureAutoFishing)

	; Options
	ScriptGui.Add("GroupBox", "x270 y110 w250 h100", "")
	ScriptGui.Add("Text", "xp+7 yp", " " Langed("Options") " ")

	AddOption("AutoUpdatesCheck", AutoUpdatesCheckToggle)
	AddOption("BringOnTopHotkey", ToggleBringOnTopHotkey)
	AddOption("PauseHotkey", TogglePauseHotkey)
	AddOption("SwapSideMouseButtons", SwapSideMouseButtons)


	; Venti picture
	ScriptGui.Add("Picture", "x310 y216 w223 h270 +BackgroundTrans", ".\yags_data\graphics\Venti.png")


	; Language settings
	ScriptGui.Add("GroupBox", "x270 y405 w65 h43", "")
	ScriptGui.Add("Text", "xp+7 yp", " " Langed("Language", "English") " ")
	AddLang("en", 1)
	AddLang("ru", 2)


	; Links
	ScriptGuiTabs.UseTab(2)

	Loop (3) {
		X := 8 + 174 * (A_Index - 1)
		ScriptGui.Add("GroupBox", "y24 w165 h355 x" X, Langed("LinksTab" A_Index))
		Links := IniRead(".\yags_data\links.ini", "LinksTab" A_Index)
		Links := StrSplit(Links, "`n")
		X := 16 + X
		Loop (Links.Length) {
			Data := StrSplit(Links[A_Index], "=")
			LinkName := Data[1]
			Link := Data[2]
			Y := 24 + 24 * A_Index
			Options := "w120 h23 x" X " y" Y
			ScriptGui.Add("Link", Options, '<a href="' Link '">' LinkName '</a>')
		}
	}

	; Script note
	ScriptGui.Add("GroupBox", "x8 y379 w513 h80", "")
	ScriptGui.Add("Text", "x15 y395 w499 +Center", Langed("Thanks") " o((>ω< ))o")
	ScriptGui.Add("Link", "x230 yp+20", 'GitHub: ' '<a href="https://github.com/SoSeDiK/YAGS">YAGS</a>')
	ScriptGui.Add("Text", "x15 yp+20 w499 +Center", Langed("MadeBy") " SoSeDiK").SetFont("bold")

	; Controls
	ScriptGuiTabs.UseTab(4)
	ScriptGui.Add("Text", "x20 y40", "// ToDo :)")


	; Footer
	ScriptGuiTabs.UseTab()

	ScriptGui.Add("Text", "x20 y488", Langed("Wish") "       ").SetFont("bold")
	HideButton := ScriptGui.Add("Button", "x370 y473 w70 h35", Langed("Hide", "Hide to tray"))
	HideButton.OnEvent("Click", HideGui)
	QuitButton := ScriptGui.Add("Button", "x460 y473 w70 h35", Langed("Quit"))
	QuitButton.OnEvent("Click", ButtonQuit)


	ShowGui()
}

AddTask(FeatureName, &FeatureVarState, FeatureDisablingFunction) {
	Control := ScriptGui.Add("Checkbox", "yp+20 v" FeatureName " " (FeatureVarState ? "Checked" : ""), Langed(FeatureName, "Missing locale for " FeatureName))
	ScriptGui[FeatureName].OnEvent("Click", ToggleFeature.Bind(&FeatureVarState, FeatureDisablingFunction, FeatureName))
	GuiTooltips[Control.ClassNN] := Langed(FeatureName "Tooltip", "Missing tooltip for " FeatureName)
}

AddOption(OptionName, OptionTask) {
	Control := ScriptGui.Add("Checkbox", "x277 yp+20 v" OptionName " " (GetSetting(OptionName, False) ? "Checked" : ""), Langed(OptionName, "Missing locale for " OptionName))
	ScriptGui[OptionName].OnEvent("Click", OptionTask)
	GuiTooltips[Control.ClassNN] := Langed(OptionName "Tooltip", "Missing tooltip for " OptionName)
}

AddLang(LangId, Num) {
	Num := 278 + ((Num - 1) * 28)
	Control := ScriptGui.Add("Picture", "x" Num " y420 w24 h24 +BackgroundTrans", ".\yags_data\graphics\lang_" LangId ".png")
	Control.OnEvent("Click", UpdateLanguage.Bind(LangId))
	GuiTooltips[Control.ClassNN] := Langed(LangId "Tooltip", "Missing language tooltip for " LangId)
}

HideGui(*) {
	ScriptGui.Hide()
}

ButtonQuit(*) {
	CloseYAGS()
}

ShowGui(*) {
	ScriptGui.Show()
}

UpdateLanguage(Lang, *) {
	Global
	If (Lang == GetSetting("Language", "en"))
		Return

	ToolTip , , , 20 ; Clear current GUI tooltip
	UpdateSetting("Language", Lang)
	ScriptGui.GetPos(&X, &Y)
	XN := X
	YN := Y
	ScriptGui.Destroy()
	ScriptGui := Gui()
	SetupGui()
	SetupTray()
	ScriptGui.Move(XN, YN)
}

ToggleFeature(&FeatureVarState, FeatureDisablingFunction, FeatureName, *) {
	Global
	NewFeatureState := ScriptGui[FeatureName].Value
	UpdateSetting(FeatureName, NewFeatureState)
	If (FeatureVarState)
		FeatureDisablingFunction()
	FeatureVarState := NewFeatureState
}

SwapSideMouseButtons(*) {
	Global
	UpdateSetting("SwapSideMouseButtons", ScriptGui["SwapSideMouseButtons"].Value)
	If (ScriptEnabled) {
		DisableGlobalHotkeys()
		EnableGlobalHotkeys()
	}
}

AutoUpdatesCheckToggle(*) {
	Global
	UpdateSetting("AutoUpdatesCheck", ScriptGui["AutoUpdatesCheck"].Value)
}





; =======================================
; GUI Tooltips
; =======================================
Global CurrentTooltip := ""



OnMessage 0x200, ShowGuiTooltips
ShowGuiTooltips(*) {
	Global
	MouseGetPos , , , &Control
	If (not GuiTooltips.Has(Control)) {
		ToolTip , , , 20
		CurrentTooltip := ""
		Return
	}

	; Tooltip gets stuck in one place, but at least not flickers
	If (CurrentTooltip == Control)
		Return

	CurrentTooltip := Control
	ToolTip GuiTooltips[Control], , , 20
}





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
; Configure Tasks
; =======================================
SetTimer SuspendOnGameInactive, -1

SuspendOnGameInactive() {
	Global
	Loop {
		WinWaitActive GameProcessName
		ToggleScript(True)
		WinWaitNotActive GameProcessName
		ToggleScript(False)
	}
}

ToggleScript(State) {
	Global
	If (State) {
		ToolTip , , , 20 ; Clear GUI tooltip
		If (ScriptPaused)
			Return
		ScriptEnabled := True
		EnableGlobalHotkeys()
		ConfigureContextualBindings()
		SetTimer ConfigureContextualBindings, 250
	} Else {
		ScriptEnabled := False
		DisableGlobalHotkeys()
		SetTimer ConfigureContextualBindings, 0
		ResetScripts()
	}
}

ResetScripts() {
	; Just in case
	BlockInput "MouseMoveOff"

	; Tasks
	DisableFeatureAutoPickup()
	DisableFeatureAutoUnfreeze()
	DisableFeatureAutoFishing()

	; Features
	DisableFeatureAutoWalk()
	DisableFeatureSimplifiedJump()
	DisableFeatureQuickPickup()
	DisableFeatureSimplifiedCombat()
	DisableFeatureEasierChargedAttack()
	DisableFeatureDialogueSkipping()
	DisableFeatureBetterCharacterSwitch()
	DisableFeatureImprovedFishing()
	DisableFeatureAlternateVision()
	DisableFeatureBetterMapClick()
	DisableFeatureAutoAttack()
	DisableFeatureLazySigil()

	; Quick Actions
	DisableFeatureMenuActions()
	DisableFeatureQuickPartySwitch()
	DisableFeatureQuickShopBuying()
	DisableFeatureClockManagement()
	DisableFeatureSereniteaPot()
	DisableFeatureReceiveBPRewards()
	DisableFeatureRelogin()
}

; Some keys are bound to multiple actions
; and due to lag we cannot perfectly switch between them separately
; via Enable/Disable Feature methods
EnableGlobalHotkeys() {
	ToggleMButtonHotkeys(True)
	Mapping := GetSetting("SwapSideMouseButtons", False)
	XButtonF := Mapping ? "XButton1" : "XButton2"
	XButtonS := Mapping ? "XButton2" : "XButton1"
	Hotkey "*" XButtonF, TriggerXButton1Bindings, "On"
	Hotkey "*" XButtonF " Up", TriggerXButton1BindingsUp, "On"
	Hotkey "*" XButtonS, TriggerXButton2Bindings, "On"
	Hotkey "*" XButtonS " Up", TriggerXButton2BindingsUp, "On"
}

DisableGlobalHotkeys() {
	ToggleMButtonHotkeys(False)
	Mapping := GetSetting("SwapSideMouseButtons", False)
	XButtonF := Mapping ? "XButton1" : "XButton2"
	XButtonS := Mapping ? "XButton2" : "XButton1"
	Hotkey "*" XButtonF, TriggerXButton1Bindings, "Off"
	Hotkey "*" XButtonF " Up", TriggerXButton1BindingsUp, "Off"
	Hotkey "*" XButtonS, TriggerXButton2Bindings, "Off"
	Hotkey "*" XButtonS " Up", TriggerXButton2BindingsUp, "Off"
}

ToggleMButtonHotkeys(State) {
	If (State) {
		ToggleMButtonHotkeys(False)
		ShouldBlockMButton := AutoWalkEnabled
		If (ShouldBlockMButton) { ; Only block MMB functions if used outside menus
			Hotkey "*MButton", TriggerMButtonBindings, "On"
		} Else {
			Hotkey "~*MButton", TriggerMButtonBindings, "On"
		}
	} Else {
		Hotkey "*MButton", TriggerMButtonBindings, "Off"
		Hotkey "~*MButton", TriggerMButtonBindings, "Off"
	}
}

TriggerMButtonBindings(*) {
	If (AutoWalkBindingsEnabled) {
		PressedMButtonToAutoWalk()
	} Else If (BetterMapClickBindingsEnabled) {
		PressedMButtonToTP()
	} Else If (MenuActionsBindingsEnabled) {
		PerformMenuActions()
	} Else {
		Send "{MButton Down}"
		KeyWait "MButton"
		Send "{MButton Up}"
	}
}

Global XButton1Pressed := False
TriggerXButton1Bindings(*) {
	Global
	XButton1Pressed := True
	If (SimplifiedJumpBindingsEnabled)
		SetTimer XButtonJump, -1
	If (DialogueSkippingBindingsEnabled)
		SetTimer XButtonSkipDialogueClicking, -1
	If (QuickShopBindingsEnabled)
		SetTimer BuyAll, -1
	If (MenuActionsBindingsEnabled)
		SetTimer PerformMenuActionsX1, -1
}

TriggerXButton1BindingsUp(*) {
	Global
	If (SimplifiedJumpBindingsEnabled)
		SetTimer XButtonJumpUp, -1
	If (DialogueSkippingBindingsEnabled)
		SetTimer XButtonSkipDialogueClickingUp, -1
	If (MenuActionsBindingsEnabled)
		SetTimer StopMenuActionsX1, -1
	XButton1Pressed := False
}

Global XButton2Pressed := False
TriggerXButton2Bindings(*) {
	Global
	XButton2Pressed := True
	If (LazySigilBindingsEnabled)
		SetTimer LazySigil, -1
	If (QuickPickupEnabled)
		SetTimer XButtonPickup, -1
	If (DialogueSkippingBindingsEnabled)
		SetTimer XButtonSkipDialogue, -1
	If (QuickShopBindingsEnabled)
		SetTimer BuyOnce, -1
	If (MenuActionsBindingsEnabled)
		SetTimer PerformMenuActionsX2, -1
}

TriggerXButton2BindingsUp(*) {
	Global
	If (QuickPickupEnabled)
		SetTimer XButtonPickupUp, -1
	If (DialogueSkippingBindingsEnabled)
		SetTimer XButtonSkipDialogueUp, -1
	If (MenuActionsBindingsEnabled)
		SetTimer StopMenuActionsX2, -1
	XButton2Pressed := False
}

ConfigureContextualBindings() {
	Global
	FullScreenMenu := IsFullScreenMenuOpen()
	MapMenu := IsMapMenuOpen()
	GameScreen := not FullScreenMenu and IsGameScreen()
	DialogueActive := not FullScreenMenu and not GameScreen and IsDialogueScreen()
	DialogueActiveOrNotShop := DialogueActive or not IsShopMenu()
	FishingActive := GameScreen and IsColor(1626, 1029, "0xFFE92C") and (IsColor(62, 42, "0xFFFFFF") and not IsColor(65, 29, "0xE2BD89")) and not IsColor(1723, 1030, "0xFFFFFF") ; 3rd action icon bound to LMB & (leave icon present & not Paimon's head) & no "E" skill
	PlayScreen := GameScreen and not FishingActive

	If (MenuActionsEnabled) {
		If (not MenuActionsBindingsEnabled) {
			EnableFeatureMenuActions()
		}
	}

	If (AutoWalkEnabled) {
		If (not AutoWalkBindingsEnabled and PlayScreen) {
			EnableFeatureAutoWalk()
		} Else If (AutoWalkBindingsEnabled and not PlayScreen) {
			DisableFeatureAutoWalk()
		}
	}

	If (SimplifiedJumpEnabled) {
		SorushGadget := HasSorushGadget()
		If (not SimplifiedJumpBindingsEnabled and PlayScreen and not SorushGadget) {
			EnableFeatureSimplifiedJump()
		} Else If (SimplifiedJumpBindingsEnabled and (not PlayScreen or SorushGadget)) {
			DisableFeatureSimplifiedJump()
		}
	}

	If (DialogueSkippingEnabled) {
		If (not DialogueSkippingBindingsEnabled) {
			EnableFeatureDialogueSkipping()
		}
	}

	If (QuickPickupEnabled) {
		If (not QuickPickupBindingsEnabled and (PlayScreen or DialogueActive)) {
			EnableFeatureQuickPickup()
		} Else If (QuickPickupBindingsEnabled and (not PlayScreen and not DialogueActive)) {
			DisableFeatureQuickPickup()
		}
	}

	If (SimplifiedCombatEnabled) {
		If (not SimplifiedCombatBindingsEnabled and PlayScreen) {
			EnableFeatureSimplifiedCombat()
		} Else If (SimplifiedCombatBindingsEnabled and not PlayScreen) {
			DisableFeatureSimplifiedCombat()
		}
	}

	If (EasierChargedAttackEnabled) {
		If (not EasierChargedAttackBindingsEnabled and PlayScreen) {
			EnableFeatureEasierChargedAttack()
		} Else If (EasierChargedAttackBindingsEnabled and not PlayScreen) {
			DisableFeatureEasierChargedAttack()
		}
	}

	If (BetterCharacterSwitchEnabled) {
		If (not BetterCharacterSwitchBindingsEnabled and PlayScreen) {
			EnableFeatureBetterCharacterSwitch()
		} Else If (BetterCharacterSwitchBindingsEnabled and not PlayScreen) {
			DisableFeatureBetterCharacterSwitch()
		}
	}

	If (AutoPickupEnabled) {
		If (not AutoPickupBindingsEnabled and PlayScreen) {
			EnableFeatureAutoPickup()
		} Else If (AutoPickupBindingsEnabled and not PlayScreen) {
			DisableFeatureAutoPickup()
		}
	}

	If (AutoUnfreezeEnabled) {
		If (not AutoUnfreezeBindingsEnabled and PlayScreen) {
			EnableFeatureAutoUnfreeze()
		} Else If (AutoUnfreezeBindingsEnabled and not PlayScreen) {
			DisableFeatureAutoUnfreeze()
		}
	}

	If (AlternateVisionEnabled) {
		If (not AlternateVisionBindingsEnabled and PlayScreen) {
			EnableFeatureAlternateVision()
		} Else If (AlternateVisionBindingsEnabled and not PlayScreen) {
			DisableFeatureAlternateVision()
		}
	}

	If (BetterMapClickEnabled) {
		If (not BetterMapClickBindingsEnabled and MapMenu) {
			EnableFeatureBetterMapClick()
		} Else If (BetterMapClickBindingsEnabled and not MapMenu) {
			DisableFeatureBetterMapClick()
		}
	}

	If (QuickPartySwitchEnabled) {
		If (not QuickPartySwitchBindingsEnabled and PlayScreen) {
			EnableFeatureQuickPartySwitch()
		} Else If (QuickPartySwitchBindingsEnabled and not PlayScreen) {
			DisableFeatureQuickPartySwitch()
		}
	}

	If (QuickShopBuyingEnabled) {
		If (not QuickShopBindingsEnabled and (not GameScreen and not DialogueActiveOrNotShop)) {
			EnableFeatureQuickShopBuying()
		} Else If (QuickShopBindingsEnabled and (GameScreen or DialogueActiveOrNotShop)) {
			DisableFeatureQuickShopBuying()
		}
	}

	If (ClockManagementEnabled) {
		If (not ClockManagementBindingsEnabled) {
			EnableFeatureClockManagement()
		}
	}

	If (SereniteaPotEnabled) {
		If (not SereniteaPotBindingsEnabled and PlayScreen) {
			EnableFeatureSereniteaPot()
		} Else If (SereniteaPotBindingsEnabled and not PlayScreen) {
			DisableFeatureSereniteaPot()
		}
	}

	If (ReceiveBPRewardsEnabled) {
		If (not ReceiveBPRewardsBindingsEnabled) {
			EnableFeatureReceiveBPRewards()
		}
	}

	If (ReloginEnabled) {
		If (not ReloginBindingsEnabled and PlayScreen) {
			EnableFeatureRelogin()
		} Else If (ReloginBindingsEnabled and not PlayScreen) {
			DisableFeatureRelogin()
		}
	}

	If (AutoAttackEnabled) {
		If (not AutoAttackBindingsEnabled and PlayScreen) {
			EnableFeatureAutoAttack()
		} Else If (AutoAttackBindingsEnabled and not PlayScreen) {
			DisableFeatureAutoAttack()
		}
	}

	If (LazySigilEnabled) {
		If (not LazySigilBindingsEnabled and PlayScreen) {
			EnableFeatureLazySigil()
		} Else If (LazySigilBindingsEnabled and not PlayScreen) {
			DisableFeatureLazySigil()
		}
	}

	If (ImprovedFishingEnabled) {
		If (not ImprovedFishingBindingsEnabled and FishingActive) {
			EnableFeatureImprovedFishing()
		} Else If (ImprovedFishingBindingsEnabled and not FishingActive) {
			DisableFeatureImprovedFishing()
		}
	}

	If (AutoFishingEnabled) {
		If (not AutoFishingBindingsEnabled and FishingActive) {
			EnableFeatureAutoFishing()
		} Else If (AutoFishingBindingsEnabled and not FishingActive) {
			DisableFeatureAutoFishing()
		}
	}
}





; =======================================
; Auto Walk
; =======================================
Global AutoWalk := False
Global AutoSprint := False

Global PressingW := False
Global PressingLShift := False
Global PressingRMForSprint := False



PressedW(*) {
	Global
	PressingW := True
}

UnpressedW(*) {
	Global
	PressingW := False
}

PressedLShift(*) {
	Global
	PressingLShift := True
}

UnpressedLShift(*) {
	Global
	PressingLShift := False
}

PressedMButtonToAutoWalk(*) {
	ToggleAutoWalk()
}

PressedRMButton(*) {
	Global
	PressingRMForSprint := True
	DoAutoSprint()
}

UnpressedRMButton(*) {
	Global
	PressingRMForSprint := False
	ToggleAutoSprint()
}



DoAutoWalk() {
	If (not PressingLShift)
		Send "{w Down}"
}

DoAutoSprint() {
	; Single long sprint
	If (PressingRMForSprint or IsInBoat()) {
		Send "{LShift Down}"
		Return
	}

	; Extra run mode
	If (IsExtraRun()) {
		SkillColor := SubStr(GetColor(1586, 970), 1, 3)
		; Super ugly, but somewhat works :/
		If (SkillColor == "0xE" or SkillColor == "0xF") {
			Send "{LShift Up}"
			Sleep 30
		}
		Send "{LShift Down}"
		Return
	}

	; Simple sprint
	Send "{LShift Down}"
	Sleep 150
	Send "{LShift Up}"
}

ToggleAutoWalk() {
	Global
	AutoWalk := !AutoWalk
	If (AutoWalk) {
		If (EasierChargedAttackBindingsEnabled)
			EnableFeatureEasierChargedAttack()
		Hotkey "*RButton", PressedRMButton, "On"
		Hotkey "*RButton Up", UnpressedRMButton, "On"
		SetTimer DoAutoWalk, 100
	} Else {
		Hotkey "*RButton", PressedRMButton, "Off"
		Hotkey "*RButton Up", UnpressedRMButton, "Off"
		If (EasierChargedAttackBindingsEnabled)
			DisableFeatureEasierChargedAttack()
		SetTimer DoAutoWalk, 0
		If (not PressingW)
			Send "{w Up}"

		If (AutoSprint) {
			AutoSprint := False
			SetTimer DoAutoSprint, 0
			If not PressingLShift
				Send "{LShift Up}"
		}
	}
}

ToggleAutoSprint(*) {
	Global
	If (not AutoWalk)
		Return

	AutoSprint := !AutoSprint
	If (AutoSprint) {
		DoAutoSprint()
		SetTimer DoAutoSprint, 850
	} Else {
		SetTimer DoAutoSprint, 0
		If (not PressingLShift) {
			Send "{LShift Up}"
			; Boats and Sorush Gadget do not stop "sprinting" unless W is unpressed
			If (IsInBoat() or HasSorushGadget()) {
				; AutoWalk will press it again anyway
				Send "w Up"
			}
		}
	}
}



EnableFeatureAutoWalk() {
	Global
	If (AutoWalkBindingsEnabled)
		DisableFeatureAutoWalk()

	If (not AutoWalkEnabled)
		Return

	Hotkey "~*w", PressedW, "On"
	Hotkey "~*w Up", UnpressedW, "On"
	Hotkey "~*LShift", PressedLShift, "On"
	Hotkey "~*LShift Up", UnpressedLShift, "On"

	ToggleMButtonHotkeys(True)
	AutoWalkBindingsEnabled := True
}

DisableFeatureAutoWalk() {
	Global
	Hotkey "~*w", PressedW, "Off"
	Hotkey "~*w Up", UnpressedW, "Off"
	Hotkey "~*LShift", PressedLShift, "Off"
	Hotkey "~*LShift Up", UnpressedLShift, "Off"

	Send "{w Up}"
	Send "{LShift Up}"

	If (AutoWalk)
		ToggleAutoWalk()

	AutoWalk := False
	AutoSprint := False

	PressingW := False
	PressingLShift := False
	PressingRMForSprint := False

	AutoWalkBindingsEnabled := False
}





; =======================================
; Simplified Jump
; =======================================
Global PressingXButtonToJump := False
Global PressingSpace := False
Global ResetAutoSprint := False



OnSpace(*) {
	Global
	If (not PressingSpace)
		SetTimer PreBunnyhopS, -200 ; Let the user release the button
	PressingSpace := True
}

OnSpaceUp(*) {
	Global
	PressingSpace := False
}

XButtonJump(*) {
	Global
	If (not PressingXButtonToJump)
		SetTimer PreBunnyhopX, -200
	PressingXButtonToJump := True
	Jump()
}

XButtonJumpUp(*) {
	Global
	PressingXButtonToJump := False
	If (IsDiving()) {
		Send "{Space Up}"
	}
	If (SkippingDialogueClicking) {
		SkippingDialogueClicking := False
		SetTimer DialogueSkipClicking, 0
	}
}



Jump() {
	Global
	; Long jump if in boat
	If (IsInBoat()) {
		Send "{Space Down}"
		Sleep 700
		Send "{Space Up}"
		Return
	}

	SimpleJump()
}

PreBunnyhopX() {
	SetTimer BunnyhopX, 50
}

PreBunnyhopS() {
	SetTimer BunnyhopS, 50
}


BunnyhopX() {
	Global
	If (not PressingXButtonToJump or not IsGameScreen()) {
		SetTimer BunnyhopX, 0
		Return
	}
	SimpleJump()
}

BunnyhopS() {
	Global
	If (not PressingSpace or not IsGameScreen()) {
		SetTimer BunnyhopS, 0
		Return
	}
	; No need to spam
	If (IsDiving()) {
		Return
	}
	SimpleJump()
}

SimpleJump() {
	Global
	; Allow jumping while in extra run mode
	If (ResetAutoSprint) {
		SetTimer ContinueAutoSprint, 0 ; Kill old timer
		SetTimer ContinueAutoSprint, -1200
	} Else If (AutoSprint and (IsExtraRun() and not IsDiving())) {
		InterruptAutoSprint()
	}
	
	If (IsDiving()) {
		Send "{Space Down}"
		Return
	}

	; Just jump
	Send "{Space}"
}

InterruptAutoSprint() {
	Global
	ResetAutoSprint := True
	ToggleAutoSprint()
	SetTimer ContinueAutoSprint, -1200
}

ContinueAutoSprint() {
	Global
	ResetAutoSprint := False
	If (not AutoSprint)
		ToggleAutoSprint()
}



EnableFeatureSimplifiedJump() {
	Global
	If (SimplifiedJumpBindingsEnabled)
		DisableFeatureSimplifiedJump()

	If (not SimplifiedJumpEnabled)
		Return

	Hotkey "~*Space", OnSpace, "On"
	Hotkey "~*Space Up", OnSpaceUp, "On"

	SimplifiedJumpBindingsEnabled := True
}

DisableFeatureSimplifiedJump() {
	Global
	Hotkey "~*Space", OnSpace, "Off"
	Hotkey "~*Space Up", OnSpaceUp, "Off"

	Send "{Space Up}"

	PressingXButtonToJump := False
	PressingSpace := False

	SimplifiedJumpBindingsEnabled := False
}





; =======================================
; Dialogue skipping
; =======================================
Global SkippingDialogue := False
Global SkippingDialogueClicking := False



XButtonSkipDialogue(*) {
	Global
	If (IsGameScreen() or IsCraftingMenu())
		Return
	If (not SkippingDialogue)
		SetTimer DialogueSkip, 25
	SkippingDialogue := True
}

XButtonSkipDialogueUp(*) {
	Global
	SetTimer DialogueSkip, 0
	SkippingDialogue := False
}

XButtonSkipDialogueClicking(*) {
	Global
	If (IsGameScreen() or IsCraftingMenu())
		Return
	If (not SkippingDialogueClicking)
		SetTimer DialogueSkipClicking, 25
	SkippingDialogueClicking := True
}

XButtonSkipDialogueClickingUp(*) {
	Global
	SetTimer DialogueSkipClicking, 0
	SkippingDialogueClicking := False
}



DialogueSkip() {
	Send "{f}"
}

DialogueSkipClicking() {
	Send "{f}"
	If (PixelSearch(&FoundX, &FoundY, 1310, 840, 1310, 580, "0x806200")) ; Mission
		LockedClick(FoundX, FoundY)
	Else If (PixelSearch(&FoundX, &FoundY, 1310, 840, 1310, 580, "0xFFFFFF")) ; Dialoue
		LockedClick(FoundX, FoundY)
}



EnableFeatureDialogueSkipping() {
	Global
	If (DialogueSkippingBindingsEnabled)
		DisableFeatureDialogueSkipping()

	If (not DialogueSkippingEnabled)
		Return

	DialogueSkippingBindingsEnabled := True
}

DisableFeatureDialogueSkipping() {
	Global
	SetTimer DialogueSkipClicking, 0

	SkippingDialogueClicking := False

	DialogueSkippingBindingsEnabled := False
}





; =======================================
; Quick Pickup
; =======================================
Global PressingF := False
Global PressingXButtonToPickup := False



PressedF(*) {
	Global
	If (not PressingF)
		SetTimer PickupOnceF, 40
	PressingF := True
}

UnpressedF(*) {
	Global
	SetTimer PickupOnceF, 0
	PressingF := False
}

XButtonPickup(*) {
	Global
	If (not PressingXButtonToPickup)
		SetTimer PickupOnceX, 40
	PressingXButtonToPickup := True
}

XButtonPickupUp(*) {
	Global
	SetTimer PickupOnceX, 0
	PressingXButtonToPickup := False
}



PickupOnceF() {
	PickupOnce()
}

PickupOnceX() {
	If (IsDialogueScreen())
		Return
	PickupOnce()
}

PickupOnce() {
	Send "{f}"
}



EnableFeatureQuickPickup() {
	Global
	If (QuickPickupBindingsEnabled)
		DisableFeatureQuickPickup()

	If (not QuickPickupEnabled)
		Return

	Hotkey "~*f", PressedF, "On"
	Hotkey "~*f Up", UnpressedF, "On"

	QuickPickupBindingsEnabled := True
}

DisableFeatureQuickPickup() {
	Global
	Hotkey "~*f", PressedF, "Off"
	Hotkey "~*f Up", UnpressedF, "Off"

	SetTimer PickupOnceF, 0
	If (not ScriptEnabled) {
		SetTimer PickupOnceX, 0
		PressingXButtonToPickup := False
	}

	PressingF := False

	QuickPickupBindingsEnabled := False
}





; =======================================
; Simplified Combat (Lazy Combat Mode | Hold LMB to spam attack)
; =======================================
Global PressingLButton := False



PressedLButton(*) {
	Global
	If (not PressingLButton)
		SetTimer NormalAutoAttack, 150
	PressingLButton := True
}

UnpressedLButton(*) {
	Global
	SetTimer NormalAutoAttack, 0
	PressingLButton := False
}



NormalAutoAttack() {
	Click
}



EnableFeatureSimplifiedCombat() {
	Global
	If (SimplifiedCombatBindingsEnabled)
		DisableFeatureSimplifiedCombat()

	If (not SimplifiedCombatEnabled)
		Return

	If (AutoWalk)
		Return

	Hotkey "~*LButton", PressedLButton, "On"
	Hotkey "~*LButton Up", UnpressedLButton, "On"

	SimplifiedCombatBindingsEnabled := True
}

DisableFeatureSimplifiedCombat() {
	Global
	Hotkey "~*LButton", PressedLButton, "Off"
	Hotkey "~*LButton Up", UnpressedLButton, "Off"

	PressingLButton := False

	SetTimer NormalAutoAttack, 0

	Click "Up"

	SimplifiedCombatBindingsEnabled := False
}





; =======================================
; Easier Charged Attack
; =======================================

StrongAttack(*) {
	Click "Down"
	KeyWait "RButton"
	TimeSinceKeyPressed := A_TimeSinceThisHotkey
	If (TimeSinceKeyPressed < 350) {
		; Hold LMB for at least 350ms
		Sleep 350 - TimeSinceKeyPressed
	}
	Click "Up"
}



EnableFeatureEasierChargedAttack() {
	Global
	If (EasierChargedAttackBindingsEnabled)
		DisableFeatureEasierChargedAttack()

	If (not EasierChargedAttackEnabled)
		Return

	If (AutoWalk)
		Return

	Hotkey "*RButton", StrongAttack, "On"

	EasierChargedAttackBindingsEnabled := True
}

DisableFeatureEasierChargedAttack() {
	Global
	Hotkey "*RButton", StrongAttack, "Off"

	EasierChargedAttackBindingsEnabled := False
}





; =======================================
; Better Character Switch
; =======================================
Global Pressing1 := False
Global Pressing2 := False
Global Pressing3 := False
Global Pressing4 := False
Global Pressing5 := False



Pressed1(*) {
	Global
	If (not Pressing1)
		SetTimer SwitchToChar1, 100
	Pressing1 := True
}

Unpressed1(*) {
	Global
	SetTimer SwitchToChar1, 0
	Pressing1 := False
}

SwitchToChar1() {
	Send "{1}"
}

Pressed2(*) {
	Global
	If (not Pressing2)
		SetTimer SwitchToChar2, 100
	Pressing2 := True
}

Unpressed2(*) {
	Global
	SetTimer SwitchToChar2, 0
	Pressing2 := False
}

SwitchToChar2() {
	Send "{2}"
}

Pressed3(*) {
	Global
	If (not Pressing3)
		SetTimer SwitchToChar3, 100
	Pressing3 := True
}

Unpressed3(*) {
	Global
	SetTimer SwitchToChar3, 0
	Pressing3 := False
}

SwitchToChar3() {
	Send "{3}"
}

Pressed4(*) {
	Global
	If (not Pressing4)
		SetTimer SwitchToChar4, 100
	Pressing4 := True
}

Unpressed4(*) {
	Global
	SetTimer SwitchToChar4, 0
	Pressing4 := False
}

SwitchToChar4() {
	Send "{4}"
}

Pressed5(*) {
	Global
	If (not Pressing5)
		SetTimer SwitchToChar5, 100
	Pressing5 := True
}

Unpressed5(*) {
	Global
	SetTimer SwitchToChar5, 0
	Pressing5 := False
}

SwitchToChar5() {
	Send "{5}"
}



EnableFeatureBetterCharacterSwitch() {
	Global
	If (BetterCharacterSwitchBindingsEnabled)
		DisableFeatureBetterCharacterSwitch()

	If (not BetterCharacterSwitchEnabled)
		Return

	Hotkey "~*1", Pressed1, "On"
	Hotkey "~*1 Up", Unpressed1, "On"
	Hotkey "~*2", Pressed2, "On"
	Hotkey "~*2 Up", Unpressed2, "On"
	Hotkey "~*3", Pressed3, "On"
	Hotkey "~*3 Up", Unpressed3, "On"
	Hotkey "~*4", Pressed4, "On"
	Hotkey "~*4 Up", Unpressed4, "On"
	Hotkey "~*5", Pressed5, "On"
	Hotkey "~*5 Up", Unpressed5, "On"

	BetterCharacterSwitchBindingsEnabled := True
}


DisableFeatureBetterCharacterSwitch() {
	Global
	Hotkey "~*1", Pressed1, "Off"
	Hotkey "~*1 Up", Unpressed1, "Off"
	Hotkey "~*2", Pressed2, "Off"
	Hotkey "~*2 Up", Unpressed2, "Off"
	Hotkey "~*3", Pressed3, "Off"
	Hotkey "~*3 Up", Unpressed3, "Off"
	Hotkey "~*4", Pressed4, "Off"
	Hotkey "~*4 Up", Unpressed4, "Off"
	Hotkey "~*5", Pressed5, "Off"
	Hotkey "~*5 Up", Unpressed5, "Off"

	SetTimer SwitchToChar1, 0
	SetTimer SwitchToChar2, 0
	SetTimer SwitchToChar3, 0
	SetTimer SwitchToChar4, 0
	SetTimer SwitchToChar5, 0

	BetterCharacterSwitchBindingsEnabled := False
}




; =======================================
; Auto Pickup
; =======================================
Pickup() {
	If (HasPickup()) {
		Send "{f}"
		Sleep 20
		Send "{WheelDown}"
	}
}

HasPickup() {
	; Search for "F" icon
	Color := "0xCDCDCD"
	If (not PixelSearch(&FoundX, &FoundY, 1120, 340, 1120, 730, Color)) { ; Icon wasn't found
		Return False
	}

	; Do not pickup if position of "F" has changed
	Sleep 10
	If (not IsColor(FoundX - 1, FoundY, Color))
		Return False

	; Check if there are no extra prompts
	If (PixelSearch(&FX, &FY, 1173, FoundY - 2, 1200, FoundY + 3, "0xFFFFFF", 25) and PixelSearch(&_, &_, FX + 1, FY + 1, FX + 4, FY + 2, "0xFFFFFF", 25)) {
		If (IsColor(1177, FoundY - 3, "0xFDFDFE") and IsColor(1200, FoundY + 14, "0xF4F4F4")) ; Hand
			Return True
		If (PixelSearch(&_, &_, 1173, FoundY - 12, 1200, FoundY + 12, "0x000000", 30)) ; Icon has dark color
			Return True
		If (PixelSearch(&_, &_, 1220, FoundY - 12, 1240, FoundY + 12, "0xACFF45")) ; Rare green item
			Return True
		If (PixelSearch(&_, &_, 1220, FoundY - 12, 1240, FoundY + 12, "0x4FF4FF")) ; Rare blue item
			Return True
		If (PixelSearch(&_, &_, 1220, FoundY - 12, 1240, FoundY + 12, "0xF998FF")) ; Rare pink item
			Return True
		If (IsColor(1190, FoundY - 4, "0xACB6CC")) ; Starconch
			Return True
		If (IsColor(1183, FoundY + 2, "0x3B58BF")) ; Glaze Lily
			Return True
		If (IsColor(1183, FoundY + 9, "0x629C57")) ; Sweet Flower
			Return True
		Return False
	}

	Return True
}



EnableFeatureAutoPickup() {
	Global
	If (AutoPickupBindingsEnabled)
		DisableFeatureAutoPickup()

	If (not AutoPickupEnabled)
		Return

	SetTimer Pickup, 40

	AutoPickupBindingsEnabled := True
}

DisableFeatureAutoPickup() {
	Global
	SetTimer Pickup, 0

	AutoPickupBindingsEnabled := False
}





; =======================================
; Auto Unfreeze/Unbubble
; =======================================
Global Unfreezing := False



CheckUnfreeze() {
	Global
	If (not Unfreezing and IsFrozen()) {
		Unfreezing := True
		SetTimer Unfreeze, 65
	}
}

Unfreeze() {
	Global
	If (not IsFrozen()) {
		SetTimer Unfreeze, 0
		Unfreezing := False
		Return
	}
	Send "{Space}"
}



EnableFeatureAutoUnfreeze() {
	Global
	If (AutoUnfreezeBindingsEnabled)
		DisableFeatureAutoUnfreeze()

	If (not AutoUnfreezeEnabled)
		Return

	SetTimer CheckUnfreeze, 250

	AutoUnfreezeBindingsEnabled := True
}

DisableFeatureAutoUnfreeze() {
	Global
	SetTimer CheckUnfreeze, 0
	SetTimer Unfreeze, 0

	Unfreezing := False

	AutoUnfreezeBindingsEnabled := False
}





; =======================================
; Alternate Vision
; =======================================
Global VisionModeTick := 0



PressedH(*) {
	ToggleVisionMode()
}



IsInVisionMode() {
	Global
	Return VisionModeTick > 0
}

ToggleVisionMode() {
	Global
	If (IsInVisionMode() or IsFullScreenMenuOpen()) {
		SetTimer VisionTimer, 0
		VisionModeTick := 0
		Send "{MButton Up}"
	} Else {
		VisionModeTick := 1
		Send "{MButton Down}"
		SetTimer VisionTimer, 300
	}
}

VisionTimer() {
	Global
	If (IsFullScreenMenuOpen()) {
		SetTimer VisionTimer, 0
		VisionModeTick := 0
		Send "{MButton Up}"
		Return
	}
	VisionModeTick := VisionModeTick + 1
	If (VisionModeTick == 10) {
		VisionModeTick := 1
		Send "{MButton Up}"
		Sleep 20
	}
	Send "{MButton Down}"
}



EnableFeatureAlternateVision() {
	Global
	If (AlternateVisionBindingsEnabled)
		DisableFeatureAlternateVision()

	If (not AlternateVisionEnabled)
		Return

	Hotkey "~*H", PressedH, "On"

	AlternateVisionBindingsEnabled := True
}

DisableFeatureAlternateVision() {
	Global
	Hotkey "~*H", PressedH, "Off"

	SetTimer VisionTimer, 0

	VisionModeTick := 0

	Send "{MButton Up}"

	AlternateVisionBindingsEnabled := False
}





; =======================================
; Better Map Click
; =======================================
Global MapTeleporting := False



PressedMButtonToTP(*) {
	Global
	If (not IsMapMenuOpen())
		Return
	If (MapTeleporting)
		Return
	MapTeleporting := True
	DoMapClick()
	MapTeleporting := False
}



Global MapTPButton := { Color: "0xFFCB33", X: 1478, Y: 1006 } ; "Teleport" button on the lower right
DoMapClick() {
	If (SimpleTeleport())
		Return

	SimpleLockedClick()
	Sleep 50
	Try {
		; Wait for a little white arrow or teleport button
		WaitPixelsRegions([ { X1: 1255, Y1: 240, X2: 1258, Y2: 1080, Color: "0xECE5D8" }, { X1: MapTPButton.X, Y1: MapTPButton.Y, X2: MapTPButton.X, Y2: MapTPButton.Y, Color: MapTPButton.Color } ])
	} Catch {
		Return
	}

	Sleep 150

	If (SimpleTeleport())
		Return

	; Selected point has multiple selectable options or selected point is not available for the teleport
	TeleportablePointColors := [ "0x2D91D9"	; Teleport Waypoint
		,"0x99ECF5"							; Statue of The Seven
		,"0xCCFFFF"							; Domain
		,"0x00FFFF"							; One-time dungeon
		,"0x63645D" ]						; Portable Waypoint

	; Find the upper available teleport
	Y := -1
	For (Index, TeleportablePointColor in TeleportablePointColors) {
		If (PixelSearch(&FoundX, &FoundY, 1298, 240, 1299, 1080, TeleportablePointColor)) {
			If (Y == -1 or FoundY < Y)
				Y := FoundY
		}
	}

	If (Y == -1) {
		If (PixelSearch(&FoundX, &FoundY, 1298, 240, 1299, 1080, "0xFFCC00")) { ; Sub-Space Waypoint (Tea Pot)
			If (IsColor(FoundX, FoundY - 10, "0xFFFFFF"))
				Y := FoundY
		}
	}

	If (Y != -1)
		Teleport(Y)
}

SimpleTeleport() {
	If (not IsColor(MapTPButton.X, MapTPButton.Y, MapTPButton.Color))
		Return False

	; Selected point has only 1 selectable option, and it's available for the teleport
	ClickOnBottomRightButton(False)
	Sleep 100
	MoveCursorToCenter()

	Return True
}

Teleport(Y) {
	Sleep 200

	LockedClick(1298, Y)

	If (not WaitPixelColor(MapTPButton.Color, MapTPButton.X, MapTPButton.Y, 3000, True))
		Return
	Sleep 100

	ClickOnBottomRightButton(False)
	Sleep 100
	MoveCursorToCenter()
}



EnableFeatureBetterMapClick() {
	Global
	If (BetterMapClickBindingsEnabled)
		DisableFeatureBetterMapClick()

	If (not BetterMapClickEnabled)
		Return

	BetterMapClickBindingsEnabled := True
}

DisableFeatureBetterMapClick() {
	Global
	MapTeleporting := False

	BetterMapClickBindingsEnabled := False
}





; =======================================
; Quick Party Switch
; =======================================
Party1(*) {
	ChangeParty(1)
}

Party2(*) {
	ChangeParty(2)
}

Party3(*) {
	ChangeParty(3)
}

Party4(*) {
	ChangeParty(4)
}

Party5(*) {
	ChangeParty(5)
}

Party6(*) {
	ChangeParty(6)
}

Party7(*) {
	ChangeParty(7)
}

Party8(*) {
	ChangeParty(8)
}

Party9(*) {
	ChangeParty(9)
}

Party10(*) {
	ChangeParty(10)
}



ChangeParty(NewPartyNum) {
	CurrentPartyNum := -1
	Even := True

	; Open parties menu
	Send "{l}"
	Try {
		WaitFullScreenMenu(5000)
	} Catch {
		Return
	}
	Sleep 800

	; Check for current party (even)
	Loop (10) {
		If (not IsColor(790 + ((A_Index - 1) * 36), 48, "0xFFFFFF"))
			Continue

		CurrentPartyNum := A_Index
		Break
	}

	; Check for current party (uneven)
	If (CurrentPartyNum == -1) {
		Even := False
		Loop (9) {
			If (not IsColor(808 + ((A_Index - 1) * 36), 48, "0xFFFFFF")) ; Check for current party
				Continue

			CurrentPartyNum := A_Index
			Break
		}
	}

	; Current party wasn't found
	If (CurrentPartyNum == -1)
		Return

	Before := 0
	After := 0
	CheckXCoord := Even ? 792 : 810

	; Figure out how many parties available <before current
	Loop (CurrentPartyNum - 1) {
		Ind := CurrentPartyNum - A_Index
		XCoord := CheckXCoord + ((Ind - 1) * 36)
		If (SubStr(GetColor(XCoord, 48), 1, 3) != "0x3")
			Break
		Before++
	}

	; Figure out how many parties available >after current
	Loop (10 - CurrentPartyNum) {
		Ind := CurrentPartyNum + A_Index
		XCoord := CheckXCoord + ((Ind - 1) * 36)
		If (SubStr(GetColor(XCoord, 48), 1, 3) != "0x3")
			Break
		After++
	}

	; Check if party is not out of bounds
	TotalParties := Before + 1 + After
	If (NewPartyNum > TotalParties)
		Return

	; Scale current party
	If (Before != CurrentPartyNum - 1)
		CurrentPartyNum := CurrentPartyNum - (CurrentPartyNum - Before) + 1

	; Find the number of needed clicks
	Changes := CurrentPartyNum - NewPartyNum
	If (Changes == 0) {
		Send "{Esc}"
		Return
	}

	If (Abs(Changes) > TotalParties / 2)
		Changes := Changes > 0 ? Changes - TotalParties : Changes + TotalParties

	; Switch party
	NextPartyX := Changes > 0 ? 75 : 1845
	Loop (Abs(Changes)) {
		LockedClick(NextPartyX, 539)
		Sleep 50
	}

	; Apply Party
	Try {
		WaitDeployButtonActive(1000)
	} Catch {
		Return
	}
	LockedClick(1700, 1000) ; Press Deploy button

	; Done, exit
	WaitPixelColor("0xFFFFFF", 838, 541, 12000) ; Wait for "Party deployed" notification
	Send "{Esc}"
}



EnableFeatureQuickPartySwitch() {
	Global
	If (QuickPartySwitchBindingsEnabled)
		DisableFeatureQuickPartySwitch()

	If (not QuickPartySwitchEnabled)
		Return

	SwitchQuickPartyHotkeys("On")

	QuickPartySwitchBindingsEnabled := True
}

DisableFeatureQuickPartySwitch() {
	Global
	SwitchQuickPartyHotkeys("Off")

	QuickPartySwitchBindingsEnabled := False
}

SwitchQuickPartyHotkeys(State) {
	Global
	Hotkey "~NumpadAdd & Numpad1", Party1, State
	Hotkey "~NumpadAdd & Numpad2", Party2, State
	Hotkey "~NumpadAdd & Numpad3", Party3, State
	Hotkey "~NumpadAdd & Numpad4", Party4, State
	Hotkey "~NumpadAdd & Numpad5", Party5, State
	Hotkey "~NumpadAdd & Numpad6", Party6, State
	Hotkey "~NumpadAdd & Numpad7", Party7, State
	Hotkey "~NumpadAdd & Numpad8", Party8, State
	Hotkey "~NumpadAdd & Numpad9", Party9, State
	Hotkey "~NumpadAdd & Numpad0", Party10, State
}





; =======================================
; Quick Shop Buying
; =======================================
Global BuyingMode := False
Global BuyingLastMouseX := 0
Global BuyingLastMouseY := 0



BuyAll(*) {
	Global
	If (BuyingMode) {
		StopBuyingAll()
		Return
	}

	MouseGetPos &X, &Y
	BuyingLastMouseX := X
	BuyingLastMouseY := Y

	BuyingMode := True
	BuyAllAvailable()
}

BuyAllAvailable() {
	Global
	If (IsShopMenu() and IsAvailableForStock()) {
		If (not BuyingMode) {
			StopBuyingAll()
			Return
		}
		QuicklyBuyOnce()
		SetTimer BuyAllAvailable, -300
		Return
	}
	StopBuyingAll()
}

BuyOnce(*) {
	Global
	If (BuyingMode) {
		StopBuyingAll()
		Return
	}
	BuyAvailable()
}

BuyAvailable() {
	If (IsShopMenu()) {
		MouseGetPos &X, &Y
		QuicklyBuyOnce()
		Sleep 50
		MouseMove X, Y
	}
}

QuicklyBuyOnce() {
	ClickOnBottomRightButton(False)
	If (not WaitPixelColor("0x313131", 1007, 780, 1000, True)) ; Wait for tab to be active
		Return
	Sleep 50
	LockedClick(1178, 600) ; Max stacks
	Sleep 50
	LockedClick(1050, 760) ; Click Exchange
	Sleep 50
	If (not WaitPixelColor("0xE9E5DC", 902, 574, 1000, True))
		Return
	ClickOnBottomRightButton(False) ; Skip purchased dialogue
}

StopBuyingAll() {
	Global
	BuyingMode := False
	SetTimer BuyAllAvailable, 0
	Sleep 30
	MouseMove BuyingLastMouseX, BuyingLastMouseY
}



IsShopMenu() {
	Return IsColor(80, 50, "0xD3BC8E") and IsColor(1840, 46, "0x3B4255") and IsColor(1740, 995, "0xECE5D8")
}

IsAvailableForStock() {
	Return not IsColor(1770, 930, "0xE5967E") ; Sold out
}



EnableFeatureQuickShopBuying() {
	Global
	If (QuickShopBindingsEnabled)
		DisableFeatureQuickShopBuying()

	If (not QuickShopBuyingEnabled)
		Return

	QuickShopBindingsEnabled := True
}

DisableFeatureQuickShopBuying() {
	Global

	; "Bought" screen resets "IsShop" state and disables bindings,
	; so we have manual extra checks inside the method that will
	; disable these if not in shop
	;BuyingMode := False
	;SetTimer BuyAllAvailable, 0

	QuickShopBindingsEnabled := False
}





; =======================================
; Clock management
; =======================================
; Global ClockCenterX := 1440
; Global ClockCenterY := 501
; Global ClockRadius := 119
; Global ClickOffset := 30
;
; All values are pregenerated by a script
; to reduce the amount of calculations
; =======================================

Global Angles := ["0", "4", "8", "12", "16", "20", "24", "28", "32", "36", "40", "44", "48", "52", "56", "60", "64", "68", "72", "76", "80", "84", "88", "92", "96", "100", "104", "108", "112", "116", "120", "124", "128", "132", "136", "140", "144", "148", "152", "156", "160", "164", "168", "172", "176", "180", "184", "188", "192", "196", "200", "204", "208", "212", "216", "220", "224", "228", "232", "236", "240", "244", "248", "252", "256", "260", "264", "268", "272", "276", "280", "284", "288", "292", "296", "300", "304", "308", "312", "316", "320", "324", "328", "332", "336", "340", "344", "348", "352", "356"]
Global XCoords := ["1440", "1448", "1457", "1465", "1473", "1481", "1488", "1496", "1503", "1510", "1516", "1523", "1528", "1534", "1539", "1543", "1547", "1550", "1553", "1555", "1557", "1558", "1559", "1559", "1558", "1557", "1555", "1553", "1550", "1547", "1543", "1539", "1534", "1528", "1523", "1516", "1510", "1503", "1496", "1488", "1481", "1473", "1465", "1457", "1448", "1440", "1432", "1423", "1415", "1407", "1399", "1392", "1384", "1377", "1370", "1364", "1357", "1352", "1346", "1341", "1337", "1333", "1330", "1327", "1325", "1323", "1322", "1321", "1321", "1322", "1323", "1325", "1327", "1330", "1333", "1337", "1341", "1346", "1352", "1357", "1364", "1370", "1377", "1384", "1392", "1399", "1407", "1415", "1423", "1432"]
Global YCoords := ["382", "382", "383", "385", "387", "389", "392", "396", "400", "405", "410", "415", "421", "428", "434", "441", "449", "456", "464", "472", "480", "489", "497", "505", "513", "522", "530", "538", "546", "553", "560", "568", "574", "581", "587", "592", "597", "602", "606", "610", "613", "615", "617", "619", "620", "620", "620", "619", "617", "615", "613", "610", "606", "602", "597", "592", "587", "581", "574", "568", "561", "553", "546", "538", "530", "522", "513", "505", "497", "489", "480", "472", "464", "456", "449", "441", "434", "428", "421", "415", "410", "405", "400", "396", "392", "389", "387", "385", "383", "382"]
Global XClickCoords := ["1440", "1470", "1440", "1410"]
Global TotalAngles := Angles.Length

Global HourAngles := ["180", "195", "210", "225", "240", "255", "270", "285", "300", "315", "330", "345", "0", "15", "30", "45", "60", "75", "90", "105", "120", "135", "150", "165"]
Global HourXCoords := ["1440", "1432", "1424", "1418", "1414", "1411", "1410", "1411", "1414", "1419", "1426", "1433", "1440", "1448", "1455", "1461", "1466", "1469", "1470", "1469", "1466", "1461", "1455", "1448"]
Global HourYCoords := ["531", "530", "527", "522", "515", "508", "500", "492", "485", "479", "475", "472", "471", "472", "475", "480", "486", "493", "501", "509", "516", "522", "527", "530"]



SkipToTime0(*) {
	SkipToTime(0)
}

SkipToTime3(*) {
	SkipToTime(3)
}

SkipToTime6(*) {
	SkipToTime(6)
}

SkipToTime9(*) {
	SkipToTime(9)
}

SkipToTime12(*) {
	SkipToTime(12)
}

SkipToTime15(*) {
	SkipToTime(15)
}

SkipToTime18(*) {
	SkipToTime(18)
}

SkipToTime21(*) {
	SkipToTime(21)
}

OpenClockMenu(*) {
	If (IsClockMenu())
		Return
	OpenMenu()
	Sleep 100
	LockedClick(45, 715) ; Clock icon
}



IsClockMenu() {
	Return IsColor(1870, 50, "0xECE5D8")
}

SkipToTime(NeededTime) {
	Global
	NextDay := GetKeyState("NumpadMult")
	AddOne := GetKeyState("Numpad0")
	SubtractOne := GetKeyState("NumpadDot")

	; Check if already in clock menu
	ClockMenuAlreadyOpened := IsClockMenu()
	If (not ClockMenuAlreadyOpened) {
		OpenMenu()

		LockedClick(45, 715) ; Clock icon
		WaitPixelColor("0xECE5D8", 1870, 50, 5000) ; Wait for the clock menu
	}

	Angle := GetCurrentAngle()
	Time := Integer(Round(AngleToTime(Angle)))

	If (AddOne)
		NeededTime += 1
	If (SubtractOne)
		NeededTime -= 1
	If (NeededTime < 0)
		NeededTime += 24
	Else If (NeededTime > 24)
		NeededTime -= 24

	Clicks := NeededTime - Time
	If (Clicks < 0)
		Clicks += 24
	If (NextDay and Time <= NeededTime)
		Clicks += 24
	Clicks := Round(Clicks / 6)

	Loop (Clicks - 1) {
		Offset := Time + A_Index * 6 + 1
		If (Offset > 24)
			Offset -= 24
		LockedClick(HourXCoords[Offset], HourYCoords[Offset])
		Sleep 50
		LockedClick(HourXCoords[Offset], HourYCoords[Offset]) ; Sometimes Genshin ignores the first click
		Sleep 250
	}

	Offset := NeededTime + 1
	If (Offset > 24)
		Offset -= 24
	LockedClick(HourXCoords[Offset], HourYCoords[Offset])
	Sleep 250

	LockedClick(1440, 1000) ; "Confirm" button

	Sleep 100
	WaitPixelColor("0xECE5D8", 1870, 50, 30000) ; Wait for the clock menu

	If (ClockMenuAlreadyOpened or GetKeyState("NumpadDiv")) {
		MouseMove 1439, 501
		Return
	}

	Send "{Esc}"
	WaitMenu(True)

	Send "{Esc}"
}

GetCurrentAngle() {
	Global
	Loop (TotalAngles) {
		If (IsColor(XCoords[A_Index], YCoords[A_Index], "0xECE5D8"))
			Return Angles[A_Index]
	}
	Return 0
}

AngleToTime(Angle) {
	Time := Angle * 24 / 360 + 12
	If (Time > 24)
		Time -= 24
	Return Time
}



EnableFeatureClockManagement() {
	Global
	If (ClockManagementBindingsEnabled)
		DisableFeatureClockManagement()

	If (not ClockManagementEnabled)
		Return

	Hotkey "~NumpadDiv & Numpad5", OpenClockMenu, "On"
	Hotkey "~NumpadDiv & Numpad2", SkipToTime0, "On"
	Hotkey "~NumpadDiv & Numpad1", SkipToTime3, "On"
	Hotkey "~NumpadDiv & Numpad4", SkipToTime6, "On"
	Hotkey "~NumpadDiv & Numpad7", SkipToTime9, "On"
	Hotkey "~NumpadDiv & Numpad8", SkipToTime12, "On"
	Hotkey "~NumpadDiv & Numpad9", SkipToTime15, "On"
	Hotkey "~NumpadDiv & Numpad6", SkipToTime18, "On"
	Hotkey "~NumpadDiv & Numpad3", SkipToTime21, "On"

	ClockManagementBindingsEnabled := True
}

DisableFeatureClockManagement() {
	Global
	Hotkey "~NumpadDiv & Numpad5", OpenClockMenu, "Off"
	Hotkey "~NumpadDiv & Numpad2", SkipToTime0, "Off"
	Hotkey "~NumpadDiv & Numpad1", SkipToTime3, "Off"
	Hotkey "~NumpadDiv & Numpad4", SkipToTime6, "Off"
	Hotkey "~NumpadDiv & Numpad7", SkipToTime9, "Off"
	Hotkey "~NumpadDiv & Numpad8", SkipToTime12, "Off"
	Hotkey "~NumpadDiv & Numpad9", SkipToTime15, "Off"
	Hotkey "~NumpadDiv & Numpad6", SkipToTime18, "Off"
	Hotkey "~NumpadDiv & Numpad3", SkipToTime21, "Off"

	ClockManagementBindingsEnabled := False
}





; =======================================
; Go to the Serenitea Pot
; =======================================
GoToSereniTeaPot(*) {
	OpenInventory()

	Sleep 100

	LockedClick(1050, 50) ; Gadgets tab
	WaitPixelColor("0xD3BC8E", 1055, 92, 1000) ; Wait for tab to be active

	Sleep 200

	; Try to find gadget
	If (not PixelSearch(&FoundX, &FoundY, 120, 206, 980, 206, "0xC65C2C"))
		Return
	If (not IsColor(FoundX + 1, FoundY, "0xC65C2C"))
		Return

	LockedClick(FoundX, FoundY)

	Sleep 100

	ClickOnBottomRightButton()

	Sleep 100

	WaitDialogueMenu()
	Send "{f}"
}



EnableFeatureSereniteaPot() {
	Global
	If (SereniteaPotBindingsEnabled)
		DisableFeatureSereniteaPot()

	If (not SereniteaPotEnabled)
		Return

	Hotkey "~NumpadSub & Numpad5", GoToSereniTeaPot, "On"

	SereniteaPotBindingsEnabled := True
}

DisableFeatureSereniteaPot() {
	Global
	Hotkey "~NumpadSub & Numpad5", GoToSereniTeaPot, "Off"

	SereniteaPotBindingsEnabled := False
}





; =======================================
; Receive all BP exp and rewards
; =======================================
Global RedNotificationColor := "0xE6455F"



ParseBPRewards(*) {
	Send "{f4}"
	WaitFullScreenMenu()

	Sleep 200

	ReceiveBpExp()
	Sleep 200
	ReceiveBpRewards()

	Sleep 200

	If (IsColor(640, 887, "0x38A2E4")) { ; Picking rewards
		MoveCursorToCenter()
		Return
	}

	Send "{Esc}"
}

ReceiveBpExp() {
	Global
	; Check for available BP experience and receive if any
	If (not IsColor(993, 20, RedNotificationColor)) ; No exp
		Return

	LockedClick(993, 20) ; To exp tab
	Sleep 300

	ClickOnBottomRightButton() ; "Claim all"
	Sleep 400

	If (not IsFullScreenMenuOpen()) {
		; Level up, need to close popup
		Send "{Esc}"
		WaitFullScreenMenu()
	}
}

ReceiveBpRewards() {
	Global
	; Check for available BP experience and receive if any
	If (not IsColor(899, 20, RedNotificationColor)) ; No rewards
		Return

	LockedClick(899, 20) ; To rewards tab
	Sleep 300

	ClickOnBottomRightButton() ; "Claim all"
	Sleep 400

	If (IsColor(640, 887, "0x38A2E4")) ; Picking rewards
		Return

	Send "{Esc}" ; Close popup with received rewards
	WaitFullScreenMenu()
}



EnableFeatureReceiveBPRewards() {
	Global
	If (ReceiveBPRewardsBindingsEnabled)
		DisableFeatureReceiveBPRewards()

	If (not ReceiveBPRewardsEnabled)
		Return

	Hotkey "~NumpadSub & Numpad8", ParseBPRewards, "On"

	ReceiveBPRewardsBindingsEnabled := True
}

DisableFeatureReceiveBPRewards() {
	Global
	Hotkey "~NumpadSub & Numpad8", ParseBPRewards, "Off"

	ReceiveBPRewardsBindingsEnabled := False
}





; =======================================
; Relogin
; =======================================
Relogin(*) {
	OpenMenu()

	Sleep 100

	LockedClick(49, 1022) ; Logout button
	Sleep 100
	WaitPixelColor("0x303030", 1016, 757, 5000) ; Wait logout menu

	LockedClick(1017, 757) ; Confirm
	Sleep 100
	WaitPixelColor("0x222222", 1820, 881, 30000) ; Wait for announcements icon

	LockedClick(500, 500)
	Sleep 500 ; Time for settings icon to disappear
	WaitPixelColor("0x222222", 1823, 794, 30000) ; Wait for settings icon

	LockedClick(500, 500)
}



EnableFeatureRelogin() {
	Global
	If (ReloginBindingsEnabled)
		DisableFeatureRelogin()

	If (not ReloginEnabled)
		Return

	Hotkey "~NumpadSub & NumpadDot", Relogin, "On"

	ReloginBindingsEnabled := True
}

DisableFeatureRelogin() {
	Global
	Hotkey "~NumpadSub & NumpadDot", Relogin, "Off"

	ReloginBindingsEnabled := False
}





; =======================================
; Auto Attack
; =======================================
Global PressingToAttack := False
Global AttackMode := GetSetting("AutoAttackMode", "None")



PressedToAutoAttack(*) {
	Global
	If (not PressingToAttack) {
		PressingToAttack := True
		Attack()
	}
}

UnpressedToAutoAttack(*) {
	Global
	PressingToAttack := False
}


AutoAttack1(*) {
	UpdateAttackMode("KleeSimpleJumpCancel")
}

AutoAttack2(*) {
	UpdateAttackMode("KleeChargedAttack")
}

AutoAttack3(*) {
	UpdateAttackMode("HuTaoDashCancel")
}

AutoAttack4(*) {
	UpdateAttackMode("HuTaoJumpCancel")
}

UpdateAttackMode(NewAttackMode) {
	Global
	AttackMode := NewAttackMode
	ToolTip Langed("AutoAttackMode", "Current attack mode: ") AttackMode, 160, 1050
	UpdateSetting("AutoAttackMode", AttackMode)
	Sleep 2000
	If (AttackMode == NewAttackMode)
		ToolTip
}



Attack() {
	Global
	If (AttackMode == "KleeSimpleJumpCancel")
		KleeSimpleJumpCancel()
	Else If (AttackMode == "KleeChargedAttack")
		KleeChargedAttack()
	Else If (AttackMode == "HuTaoDashCancel")
		HuTaoDashCancel()
	Else If (AttackMode == "HuTaoJumpCancel")
		HuTaoJumpCancel()
}

; NJ
KleeSimpleJumpCancel() {
	Global
	If (PressingToAttack) {
		Send "{LButton}"
		Sleep 35
		Send "{Space}"
		Sleep 550
		KleeSimpleJumpCancel()
	}
}

; CJ
KleeChargedAttack() {
	Global
	If (PressingToAttack) {
		Send "{LButton Down}"
		Sleep 460
		Send "{LButton Up}"
		Sleep 15
		Send "{Space}"
		Sleep 570
		KleeChargedAttack()
	}
}

; 9N2CD
HuTaoDashCancel() {
	Global
	If (PressingToAttack) {
		Send "{LButton}"
		Sleep 150
		Send "{LButton}"
		Sleep 150

		If (not PressingToAttack)
			Return

		Send "{LButton Down}"
		Sleep 350
		Send "{LShift Down}"
		Sleep 30
		Send "{LShift Up}"
		Send "{LButton Up}"

		If (not PressingToAttack)
			Return

		Sleep 400
		HuTaoDashCancel()
	}
}

; 9N2CJ
HuTaoJumpCancel() {
	Global
	If (PressingToAttack) {
		Send "{LButton}"
		Sleep 190
		Send "{LButton}"

		If (not PressingToAttack)
			Return

		Send "{LButton Down}"
		Sleep 300
		Send "{Space}"
		Send "{LButton Up}"

		If (not PressingToAttack)
			Return

		Sleep 590
		HuTaoJumpCancel()
	}
}



EnableFeatureAutoAttack() {
	Global
	If (AutoAttackBindingsEnabled)
		DisableFeatureAutoAttack()

	If (not AutoAttackEnabled)
		Return

	Hotkey "~*V", PressedToAutoAttack, "On"
	Hotkey "~*V Up", UnpressedToAutoAttack, "On"
	Hotkey "~NumpadMult & Numpad1", AutoAttack1, "On"
	Hotkey "~NumpadMult & Numpad2", AutoAttack2, "On"
	Hotkey "~NumpadMult & Numpad3", AutoAttack3, "On"
	Hotkey "~NumpadMult & Numpad4", AutoAttack4, "On"

	AutoAttackBindingsEnabled := True
}

DisableFeatureAutoAttack() {
	Global
	Hotkey "~*V", PressedToAutoAttack, "Off"
	Hotkey "~*V Up", UnpressedToAutoAttack, "Off"
	Hotkey "~NumpadMult & Numpad1", AutoAttack1, "Off"
	Hotkey "~NumpadMult & Numpad2", AutoAttack2, "Off"
	Hotkey "~NumpadMult & Numpad3", AutoAttack3, "Off"
	Hotkey "~NumpadMult & Numpad4", AutoAttack4, "Off"

	PressingToAttack := False
	AutoAttackBindingsEnabled := False
}





; =======================================
; Lazy Sigil
; =======================================
LazySigil() {
	Send "{t}"
}

EnableFeatureLazySigil() {
	Global
	If (LazySigilBindingsEnabled)
		DisableFeatureLazySigil()

	If (not LazySigilEnabled)
		Return

	LazySigilBindingsEnabled := True
}

DisableFeatureLazySigil() {
	Global
	LazySigilBindingsEnabled := False
}





; =======================================
; Improved Fishing
; =======================================
Global TargetMode := False



ToggleTargetMode(*) {
	Global
	TargetMode := !TargetMode
	If (TargetMode) {
		Send "{LButton Down}"
	} Else {
		Send "{LButton Up}"
	}
}



EnableFeatureImprovedFishing() {
	Global
	If (ImprovedFishingBindingsEnabled)
		DisableFeatureImprovedFishing()

	If (not ImprovedFishingEnabled)
		Return

	Hotkey "*LButton", ToggleTargetMode, "On"

	ImprovedFishingBindingsEnabled := True
}

DisableFeatureImprovedFishing() {
	Global
	Hotkey "*LButton", ToggleTargetMode, "Off"

	TargetMode := False

	ImprovedFishingBindingsEnabled := False
}





; =======================================
; Auto Fishing
; =======================================
Global Pulled := False
Global IsPulling := False



CheckFishing() {
	Global
	If (not IsHooked())
		Return

	Shape := CheckShape()

	If (Shape == 0) {
		If (IsPulling) {
			IsPulling := False
			Return
		}
	} Else If (Shape == 2) {
		IsPulling := True
		Send "{LButton Down}"
		Sleep 100
		Send "{LButton Up}"
	}
}

IsHooked() {
	Global
	; Fish baited, start pulling
	If (not Pulled and PixelSearch(&FoundX, &FoundY, 1613, 980, 1615, 983, "0xFFFFFF", 65)) {
		MouseClick "Left"
		Pulled := True
		Return True
	}

	; Option to cast the rod is present
	If (IsColor(1740, 1030, "0xFFE92C")) {
		Pulled := False
		Return False
	}

	Return True
}

CheckShape() {
	; 0 -> return
	; 1 -> return
	; 2 -> pull

	If (!PixelSearch(&FoundX1, &FoundY1, 718, 100, 1200, 100, "0xFFFFC0")) ; Current position
		Return 0

	If (!PixelSearch(&FoundX2, &FoundY2, 1210, 112, FoundX1 + 9, 112, "0xFFFFC0")) ; Border
		Return 0

	Result := FoundX1 - FoundX2
	If (Result > -45) ; Distance from the current position to the right border
		Return 1

	Return 2
}



EnableFeatureAutoFishing() {
	Global
	If (AutoFishingBindingsEnabled)
		DisableFeatureAutoFishing()

	If (not AutoFishingEnabled)
		Return

	SetTimer CheckFishing, 100

	AutoFishingBindingsEnabled := True
}

DisableFeatureAutoFishing() {
	Global
	SetTimer CheckFishing, 0

	Pulled := False
	IsPulling := False

	AutoFishingBindingsEnabled := False
}





; =======================================
; Menu Actions
; =======================================
PerformMenuActions() {
	; =======================================
	; Lock Artifacts or Weapons
	; =======================================
	MenuArrow := IsColor(1839, 44, "0x3B4255")
	; Backpack
	If (MenuArrow and IsColor(75, 43, "0xD3BC8E") and IsColor(75, 1005, "0x3B4255")) {
		If (TryToFindLocker(1746, 444))
			Return
	}

	; Artifact details
	If (MenuArrow and IsColor(75, 70, "0xD3BC8E")) {
		If (TryToFindLocker(1818, 445))
			Return
	}

	; Weapon details
	If (MenuArrow and IsColor(97, 25, "0xD3BC8E")) {
		If (TryToFindLocker(1818, 445))
			Return
	}

	; Character's Artifacts
	If (MenuArrow and IsColor(60, 999, "0x3B4255") and IsColor(558, 1010, "0x3F4658")) {
		If (TryToFindTransparentLocker(1846, 310))
			Return
	}

	; Character Weapon Switch
	If (MenuArrow and IsColor(561, 1005, "0x575C6A")) {
		If (TryToFindTransparentLocker(1846, 230))
			Return
	}

	; Artifacts/Weapons enhancement menu
	If (MenuArrow and IsColor(1096, 53, "0x3C4356")) {
		If (TryToFindLocker(1612, 505))
			Return
	}

	; Mystic Offering
	If (not MenuArrow and IsColor(1840, 45, "0x353B4B") and IsColor(904, 54, "0x3C4356")) {
		If (TryToFindLocker(1421, 506))
			Return
	}

	; Domain artifacts
	If (not MenuArrow and IsColor(715, 700, "0xECE5D8") and PixelSearch(&Px, &Py, 753, 475, 753, 110, "0xFFCC32")) {
		If (TryToFindLocker(1151, 494))
			Return
	}

	; =======================================
	; Select maximum stacks and craft ores
	; =======================================
	If (MenuArrow and IsColor(62, 52, "0xD3BC8E") and IsColor(643, 1015, "0x3B4255")) {
		MouseGetPos &CoordX, &CoordY
		LockedClick(1516, 672) ; Max stacks
		Sleep 50
		ClickOnBottomRightButton()
		Sleep 30
		MouseMove CoordX, CoordY
		Return
	}

	; =======================================
	; Mystic Offering button
	; =======================================
	If (MenuArrow and IsColor(1646, 1014, "0xDCB132") and IsColor(1381, 469, "0xE9E5DC") and not IsColor(847, 812, "0xC2C4C6")) {
		ClickOnBottomRightButton()
		Return
	}

	; =======================================
	; Mystic Offering Confirm button
	; =======================================
	If (not MenuArrow and IsColor(600, 757, "0x38A2E4") and IsColor(1017, 752, "0xEDBE32") and IsColor(1400, 261, "0xFEEEAE")) {
		ClickAndBack(1101, 755)
		Return
	}

	; =======================================
	; Obtain crafted item
	; =======================================
	If (MenuArrow and IsColor(1639, 1015, "0x99CC33")) {
		ClickOnBottomRightButton() ; Obtain
		Sleep 200
		Send "{Esc}" ; Skip animation
		Sleep 50
		Return
	}

	; =======================================
	; Auto Add & Enhance buttons
	; =======================================
	If (MenuArrow and IsColor(1292, 935, "0xE9E5DC") and IsColor(1613, 1018, "0x313131")) {
		ColorCheck := SubStr(GetColor(1234, 864), 1, 3)
		EmptyFirstPlus := not PixelSearch(&_, &_, 1200, 908, 1280, 908, "0xFFCC32") ; Weapons or Artifacts
		If (EmptyFirstPlus) {
			ClickAndBack(1836, 764) ; Auto Add
		} Else {
			If (IsColor(1178, 326, "0xE1BD40", 25) or IsColor(98, 25, "0xD3BC8E")) { ; Will add new stat or is weapons menu
				ClickOnBottomRightButton() ; Enhance
				Return
			}
			MouseGetPos &CoordX, &CoordY
			ClickOnBottomRightButton(False) ; Enhance
			Sleep 100
			LockedClick(75, 150) ; Switch to "Details" tab to skip animation
			Sleep 100
			LockedClick(75, 220) ; Back to "Enhance" tab
			Sleep 100
			MouseMove CoordX, CoordY
		}
		Return
	}

	; =======================================
	; Craft/Convert button
	; =======================================
	If (IsCraftingMenu()) {
		ClickOnBottomRightButton()
		Return
	}

	; =======================================
	; Craft/Convert Confirm button
	; =======================================
	If (not MenuArrow and PixelSearch(&Px, &Py, 964, 700, 1050, 900, "0xFFCB32")) {
		ClickAndBack(Px, Py)
		Return
	}

	; =======================================
	; Enhance Confirm button
	; =======================================
	If (not MenuArrow and IsColor(835, 734, "0x4A5366") and IsColor(515, 263, "0xFEEEAE") and IsColor(1025, 755, "0xF3C232")) {
		ClickAndBack(1105, 760)
		Return
	}

	; =======================================
	; Confirm buttons
	; =======================================
	If (not MenuArrow and PixelSearch(&Px, &Py, 805, 828, 831, 902, "0xFFCB32")) {
		ClickAndBack(888, Py)
		Return
	}

	; =======================================
	; Lay Line Blossom (resin Boss rewards)
	; =======================================
	If (not MenuArrow and IsColor(835, 734, "0x4A5366") and IsColor(515, 263, "0xFEEEAE") and not IsColor(633, 782, "0x4A5366")) {
		ClickAndBack(944, 755)
		Return
	}

	; =======================================
	; Tea Pot Coins & Companion Exp
	; =======================================
	If (IsColor(1862, 47, "0x3B4255") and IsColor(1366, 1016, "0xFFCB32") and IsColor(1775, 38, "0x3B4255")) {
		MouseGetPos &CoordX, &CoordY
		LockedClick(1077, 946) ; Coins
		Sleep 30
		LockedClick(1285, 35) ; Close popup in case there are no coins
		Sleep 30
		LockedClick(1808, 712) ; Exp
		Sleep 30
		LockedClick(1285, 35) ; Close popup in case there's no exp
		Sleep 30
		MouseMove CoordX, CoordY
		Return
	}

	; =======================================
	; Expeditions
	; =======================================
	If (MenuArrow and IsColor(63, 56, "0xECE5D8") and IsColor(73, 1014, "0xFFCC33")) {
		MouseGetPos &CoordX, &CoordY
		LockedClick(73, 1014) ; Claim All
		WaitPixelColor("0x313131", 1007, 1019, 3000, True)
		LockedClick(1007, 1019) ; Dispatch Again
		Sleep 30
		MouseMove CoordX, CoordY
		Return
	}

	; =======================================
	; Continue Challenge (Domain)
	; =======================================
	If (not MenuArrow and SubStr(GetColor(597, 998), 1, 3) == "0x3" and SubStr(GetColor(1033, 998), 1, 3) == "0xF" and IsColor(1018, 582, "0xECEAEB")) {
		ClickAndBack(1100, 995)
		Return
	}

	; =======================================
	; Toggle Auto Dialogue
	; =======================================
	If (not IsFullScreenMenuOpen() and not IsGameScreen() and IsDialogueScreen()) {
		ClickAndBack(98, 49)
		Return
	}

	; =======================================
	; Skip in Domain or Gacha
	; =======================================
	If (not PixelSearch(&_, &_, 0, 0, 1920, 1080, "0xECE5D8") and not IsGameScreen()) {
		Click
		If (WaitPixelColor("0xFFFFFF", 1817, 52, 500, True) and IsColor(1825, 52, "0xFFFFFF")) {
			ClickAndBack(1817, 52)
			Return
		}
	}
}

TryToFindLocker(TopX, TopY) {
	If (PixelSearch(&FoundX, &FoundY, TopX, TopY, TopX, 72, "0xFF8A75")) {
		If (IsColor(FoundX - 6, FoundY, "0x495366")) { ; Locked
			ClickAndBack(FoundX, FoundY)
			Return True
		}
	} Else If (PixelSearch(&FoundX, &FoundY, TopX, 72, TopX, TopY, "0x9EA1A8")) {
		If (IsColor(FoundX - 6, FoundY, "0xF3EFEA")) { ; Unlocked
			ClickAndBack(FoundX, FoundY)
			Return True
		}
	}
	Return False ; Not found
}

TryToFindTransparentLocker(TopX, TopY) {
	; Search for a locked lock
	If (PixelSearch(&FoundX, &FoundY, TopX, TopY, TopX, 165, "0xFF8A75")) {
		If (IsColor(TopX - 6, FoundY, "0x495366")) { ; Locked
			ClickAndBack(FoundX, FoundY)
			Return True
		}
	}

	; Unlocked locker might have some transparency and change its color,
	; so "IsColor" can't be relayed on, and simple "PixelSearch" might be
	; wrong due to text elements
	LastY := 105
	While (LastY < TopY) {
		If (not PixelSearch(&FoundX, &FoundY, TopX, LastY, TopX, TopY, "0x978080", 30)) {
			Return False
		}
		If (not IsColor(FoundX, FoundY + 10, "0x978080", 30)) {
			LastY := FoundY + 10
			Continue
		}
		If (not PixelSearch(&_, &_, FoundX + 8, FoundY, FoundX + 8, FoundY, "0x978080", 30)) {
			Return False ; Not found
		}
		If (PixelSearch(&Px, &Py, FoundX - 8, FoundY, FoundX - 6, FoundY, "0xD3DAC7", 160)) { ; Unlocked
			ClickAndBack(FoundX, FoundY)
			Return True
		}
		Return False ; Not found
	}
	Return False ; Not found
}



Global IncreasingGoods := False
Global DecreasingGoods := False
Global GoodsSavedX := 0
Global GoodsSavedY := 0

PerformMenuActionsX1() {
	Global
	; This is dumb, but XButton1Pressed might be unpressed during IsCraftingMenu() check :/
	If (IsCraftingMenu() and not IncreasingGoods and XButton1Pressed) {
		If (not IsColor(1610, 669, "0x3E4655")) {
			Return
		}
		IncreasingGoods := True
		BlockInput "MouseMove"
		If (not DecreasingGoods) {
			MouseGetPos &CoordX, &CoordY
			GoodsSavedX := CoordX
			GoodsSavedY := CoordY
		}
		SetTimer IncreaseGoods, -1
		Sleep 300
		If (not IncreasingGoods) {
			If (not DecreasingGoods) {
				MouseMove GoodsSavedX, GoodsSavedY
				BlockInput "MouseMoveOff"
			}
			Return
		}
		If (XButton1Pressed) {
			SetTimer IncreaseGoods, 20
		}
	}
}

StopMenuActionsX1() {
	Global
	If (IncreasingGoods) {
		SetTimer IncreaseGoods, 0
		Sleep 30
		If (not DecreasingGoods) {
			MouseMove GoodsSavedX, GoodsSavedY
			BlockInput "MouseMoveOff"
		}
		IncreasingGoods := False
	}
}

IncreaseGoods() {
	Click 1611, 670
}

PerformMenuActionsX2() {
	Global
	; This is dumb, but XButton2Pressed might be unpressed during IsCraftingMenu() check :/
	If (IsCraftingMenu() and not DecreasingGoods and XButton2Pressed) {
		If (not IsColor(1071, 670, "0x3B4354")) {
			Return
		}
		DecreasingGoods := True
		BlockInput "MouseMove"
		If (not IncreasingGoods) {
			MouseGetPos &CoordX, &CoordY
			GoodsSavedX := CoordX
			GoodsSavedY := CoordY
		}
		SetTimer DecreaseGoods, -1
		Sleep 300
		If (not DecreasingGoods) {
			If (not IncreasingGoods) {
				MouseMove GoodsSavedX, GoodsSavedY
				BlockInput "MouseMoveOff"
			}
			Return
		}
		If (XButton2Pressed) {
			SetTimer DecreaseGoods, 20
		}
	}
}

StopMenuActionsX2() {
	Global
	If (DecreasingGoods) {
		SetTimer DecreaseGoods, 0
		Sleep 30
		If (not IncreasingGoods) {
			MouseMove GoodsSavedX, GoodsSavedY
			BlockInput "MouseMoveOff"
		}
		DecreasingGoods := False
	}
}

DecreaseGoods() {
	Click 1072, 669
}

IsCraftingMenu() {
	Return IsColor(1838, 44, "0x3B4255") and IsColor(1647, 1014, "0xFFCB32") and IsColor(647, 1016, "0x3B4255")
}



EnableFeatureMenuActions() {
	Global
	MenuActionsBindingsEnabled := True
}

DisableFeatureMenuActions() {
	Global
	MenuActionsBindingsEnabled := False
}





; =======================================
; Libs
; =======================================
; Note: Sometimes clicks do not go through with the small delay,
; but due to the higher delay "Click Lock" might be triggered which
; makes click to not release
Global ClickDelay := 25



OpenMenu() {
	Send "{Esc}"
	WaitMenu()
}

WaitMenu(ReturnOnTimeout := False) {
	WaitPixelColor(LightMenuColor, 729, 63, 2000, ReturnOnTimeout) ; Wait for menu
}

OpenInventory() {
	Send "{b}"
	WaitFullScreenMenu(2000)
}

ClickAndBack(X, Y) {
	Global
	BlockInput "MouseMove"
	MouseGetPos &CoordX, &CoordY
	Click X, Y, "Down"
	Sleep ClickDelay
	Click "Up"
	Sleep 50
	MouseMove CoordX, CoordY
	BlockInput "MouseMoveOff"
}

LockedClick(X, Y) {
	Global
	BlockInput "MouseMove"
	Click X, Y, "Down"
	Sleep ClickDelay
	Click "Up"
	BlockInput "MouseMoveOff"
}

SimpleLockedClick() {
	Global
	BlockInput "MouseMove"
	Click "Down"
	Sleep ClickDelay
	Click "Up"
	BlockInput "MouseMoveOff"
}

ClickOnBottomRightButton(Back := True) {
	If (Back)
		ClickAndBack(1730, 1000)
	Else
		LockedClick(1730, 1000)
}

MoveCursorToCenter() {
	BlockInput "MouseMove"
	MouseMove A_ScreenWidth / 2, A_ScreenHeight / 2
	BlockInput "MouseMoveOff"
}

WaitFullScreenMenu(Timeout := 3000) {
	WaitPixelColor(LightMenuColor, 1859, 47, Timeout) ; Wait for close button on the top right
}

IsFullScreenMenuOpen() {
	Return IsColor(1859, 47, LightMenuColor) or IsColor(1875, 35, LightMenuColor)
}

IsMapMenuOpen() {
	; Map scale
	Return IsColor(47, 427, "0xEDE5DA")
}

; Note: always better to check if not IsFullScreenMenuOpen() before checking the game screen
IsGameScreen() {
	Return IsColor(276, 58, "0xFFFFFF") ; Eye icon next to the map
}

; Note: always better to check if not IsFullScreenMenuOpen()
; and not IsGameScreen() before checking the dialogue screen
IsDialogueScreen() {
	Return IsColor(60, 48, "0xECE5D8") and IsColor(80, 48, "0xECE5D8") ; Play or Pause button
}

IsInBoat() {
	Return IsColor(828, 976, "0xEDE5D9") ; Boat icon color
}

WaitDeployButtonActive(Timeout) {
	WaitPixelColor("0x313131", 1557, 1005, Timeout) ; Wait for close button on the top right
}

WaitDialogueMenu() {
	WaitPixelColor("0x656D77", 1180, 537, 3000) ; Wait for "..." icon in the center of the screen
}

; Check if a character is frozen or in the bubble
IsFrozen() {
	; Space Text and Button Colors
	Return IsColor(1417, 596, "0x333333") and IsColor(1417, 585, "0xFFFFFF")
}

HasSorushGadget() { ; ToDo: workaround gadget delay
	Return IsColor(1810, 806, "0xD05C66") and IsColor(1804, 822, "0xDD7361")
}

IsDiving() {
	Return IsColor(1692, 1044, "0xFFFFFF", 3) and IsColor(1692, 1045, "0xFFFFFF", 3)
}


; Check if run should be infinite
IsExtraRun() {
	ExtraRunMode := IsColor(1695, 1030, "0xFFE92C") ; Ayaka / Mona run mode
	Return ExtraRunMode or HasSorushGadget() or IsDiving()
}

; Wait for pixel to be the specified color or throw exception after the specified Timeout.
;
; Color - hex string in RGB format, for example "0xA0B357".
; Timeout - timeout in milliseconds.
; ReturnOnTimeout - whether to return False instead of throwing an exception on timeout
WaitPixelColor(Color, X, Y, Timeout, ReturnOnTimeout := False) {
	StartTime := A_TickCount
	Loop {
		If (IsColor(X, Y, Color))
			Return True
		If (A_TickCount - StartTime >= Timeout) {
			If (ReturnOnTimeout)
				Return False
			Throw Error("Timeout " . Timeout . " ms")
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
		For (Index, Region in Regions) {
			X1 := Region.X1
			X2 := Region.X2
			Y1 := Region.Y1
			Y2 := Region.Y2
			Color := Integer(Region.Color)

			If (PixelSearch(&FoundX, &FoundY, X1, Y1, X2, Y2, Color))
				Return Region
		}

		If (A_TickCount - StartTime >= Timeout)
			Throw Error("Timeout " . Timeout . " ms")
	}
}

IsColor(X, Y, Color, Variation := 0) {
	If (Variation != 0)
		Return PixelSearch(&_, &_, X, Y, X, Y, Color, Variation)
	Return GetColor(X, Y) == Color
}

GetColor(X, Y) {
	Return PixelGetColor(X, Y)
}





; =======================================
; Some util methods
; =======================================
GetSetting(Setting, Def) {
	Return IniRead(GetSettingsPath(), "Settings", Setting, Def)
}

UpdateSetting(Setting, NewValue) {
	IniWrite NewValue, GetSettingsPath(), "Settings", Setting
}

GetSettingsPath() {
	Return A_ScriptDir "\yags_data\settings.ini"
}

Langed(Key, Def := "", Lang := GetSetting("Language", "en")) {
	Data := IniRead(GetLanguagePath(Lang), "Locales", Key, (Def == "" ? Langed(Key, Key, "en") : Def))
	Data := StrReplace(Data, "\n", "`n")
	Return Data
}

GetLanguagePath(Lang) {
	Return A_ScriptDir "\yags_data\langs\lang_" Lang ".ini"
}

CheckForUpdates() {
	Global
	SplitPath A_ScriptFullPath, , , &Ext
	If (Ext != "exe") {
		VersionState := "Indev"
		Return
	}

	UpdateCheckResponse := FetchLatestYAGS()
	CurrentVer := "v" ScriptVersion
	NewVer := GetLatestYAGSVersion(UpdateCheckResponse)
	If (CurrentVer == NewVer) {
		VersionState := "UpToDate"
		Return
	}

	Changes := GetLatestYAGSChanges(UpdateCheckResponse)
	Changes := StrReplace(Changes, "\r", "")
	Changes := StrReplace(Changes, "\n", "`n")
	Result := Langed("UpdateFound", "A new version of YAGS was found!\nCurrent: %current_ver% | New: %new_ver%\n\nChanges since last release:\n%changes%\n\nDo you want to update the script automagically?")
	Result := StrReplace(Result, "%current_ver%", CurrentVer)
	Result := StrReplace(Result, "%new_ver%", NewVer)
	Result := StrReplace(Result, "%changes%", Changes)
	Result := MsgBox(Result, , "YesNo")
	
	If (Result == "Yes") {
		Url := "https://github.com/SoSeDiK/YAGS/releases/latest/download/YAGS.exe"
		Download Url, ".\YAGS_updated.exe"

		FileDelete ".\yags_data\graphics\*.*"
		FileDelete ".\yags_data\langs\*.*"

		WaitAction := 'ping -n 2 127.0.0.1>nul'
		DelAction := 'del "' A_ScriptFullPath '"'
		RenameAction := 'ren "' A_ScriptDir '\YAGS_updated.exe" "YAGS.exe"'
		RunAction := 'start "" "' A_ScriptDir '\YAGS.exe"'
		Run 'cmd /c ' WaitAction ' & ' DelAction ' & ' WaitAction ' & ' RenameAction ' & ' WaitAction ' & ' RunAction, , "Hide"

		ExitApp
	} Else {
		VersionState := "Outdated"
		MsgBox Langed("UpdateNo", "You can always update the script manually from GitHub! :)")
	}
}

FetchLatestYAGS() {
	Url := "https://api.github.com/repos/SoSeDiK/YAGS/releases/latest"
	Whr := ComObject("WinHttp.WinHttpRequest.5.1")
	Whr.Open("GET", Url, False), Whr.Send()
	Return Whr.ResponseText
}

GetLatestYAGSVersion(Response) {
	RegExMatch(Response, "_name`":`"\K[^`"]+", &SubPat)
	Return SubPat[0]
}

GetLatestYAGSChanges(Response) {
	RegExMatch(Response, "body`":`"\K[^`"]+", &SubPat)
	Return SubPat[0]
}





; Bring Script On Top | Alt + B
BringOnTop(*) {
	Global
	If (WinActive(ScriptGui)) {
		ScriptGui.Show() ; For some reason Windows does not allow "Win" calls if the Gui is inactive
		WinMoveBottom ScriptGui
		MouseGetPos &_, &_, &winId
		WinActivate winId
	} Else {
		ScriptGui.Show()
	}
}

ToggleBringOnTopHotkey(*) {
	Global
	State := ScriptGui["BringOnTopHotkey"].Value
	UpdateSetting("BringOnTopHotkey", State)
	Hotkey "!b", BringOnTop, State ? "On" : "Off" 			; Alt + B
}

; (Un/)Pause script | Alt + P
TogglePauseState(*) {
	Global
	If (not WinActive(GameProcessName))
		Return

	ScriptPaused := !ScriptPaused
	ToolTip "YAGS: Script " (ScriptPaused ? "paused" : "unpaused")
	SetTimer () => ToolTip(), -1000
	ToggleScript(!ScriptPaused)
}

TogglePauseHotkey(*) {
	Global
	State := ScriptGui["PauseHotkey"].Value
	UpdateSetting("PauseHotkey", State)
	Hotkey "!p", TogglePauseState, State ? "On" : "Off" 	; Alt + P
}

ToggleExtraHotkeys(*) {
	ToggleBringOnTopHotkey()
	TogglePauseHotkey()
}



; Reload script (debugging)
EnableReloadScriptHotkey() {
	If (VersionState != "Indev")
		Return

	Hotkey "^!r", ReloadYAGS, "On" 							; Ctrl + Alt + R
}

ReloadYAGS(*) {
	ToolTip "Reloading script!"
	Sleep 100
	Reload
}

; Exit script
EnableExitScriptHotkey() {
	Hotkey "$End", CloseYAGS, "On" 							; End
}

CloseYAGS(*) {
	ExitApp
}
