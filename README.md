<img src="./ScriptPreview.png" alt="Happy Moople" align="right" width="450">

## 🎈 [WIP] Yet Another Genshin Script

<table>
  <tr>
    <td valign="center"><img src="https://github.com/twitter/twemoji/blob/master/assets/svg/1f1fa-1f1f8.svg" width="16"/> English</td>
    <td valign="center"><a href="README_RU.md"><img src="https://github.com/twitter/twemoji/blob/master/assets/svg/1f1f7-1f1fa.svg" width="16"/> Русский</a></td>
  </tr>
</table>

YAGS was made for personal usage to make the daily Genshin routine less annoying.

This script tries to improve controls, automate repeatable things, and bring some useful shortcuts.

Script is made solely for 1920x1080 game resolution in [borderless window mode](https://gaming.stackexchange.com/a/376533) with 60FPS and low ping in mind.

There are no plans to adapt it to other resolutions in the near future.

---

### ❓ How to
1. Extract and run the script. Pick one of the options:
	- Using release build (preferred):
		- [Download](https://github.com/SoSeDiK/YAGS/releases/latest/download/YAGS.exe) the latest version of the script and put it in some folder.
		- Run `YAGS.exe`.
	- Using development build:
		- Download and install [AutoHotkey](https://www.autohotkey.com/) (❕version 2 is required❕).
		- Download this repository, extract `YAGS` folder.
		- Run `YAGS.ahk`.
		- (!) Keep in mind that development builds do not support auto updating.
2. Configure the settings in the GUI if needed.
3. Run the game and enjoy.
4. Press `Alt + B` to bring the script on top if needed.
5. Press `End` in case of an emergency to force stop the script.

**Note:** in order to work properly, the script must be able to run with administrator privileges. This is due to the game not handling AHK's keyboard and mouse inputs properly otherwise.

---

### 🎨 Features
- Hold `F` to spam `F` >:)
- Hold `XButton1` to spam `F` even more!
  - For some reason, it's easier for me to use a mouse than to press `F`.
  - You may also use this to skip dialogues (you still have to do the choices manually).
- Hold `Space` to jump continuously.
  - Can be used to Bunnyhop (enter the sprinting mode and start jumping).
- Hold `XButton2` to jump continuously too!
  - Yes, I'm too lazy for `Spacebar` (mouse walking-sprinting-jumping power!). Bunnyhop is possible as well.
  - Works with Waveriders.
  - May be used to skip dialogues too, but in addition also auto picks up the mission option, if available, or the latest dialogue choice.
- Hold `1-5` keys to switch characters.
  - I can not be the only one who have chosen the wrong character in the past, and had to rage spam my keyboard to get another character asap, right? RIGHT?!
- Press `MMB` to toggle AutoWalk!
  - Press `RMB` to toggle sprint while auto walking. Hold `RMB` to continiously run instead of dashing (useful to start Bunnyhopping).
  - `LShift` can be used too for manual sprinting.
- Press `H` to toggle Vision!
  - Makes it much easier, less annoying, and had to be done since `MMB` was changed.
- Hold `V` to auto attack!
  - By default does nothing. Press `Numpad *` + `Numpad 1-4` to change currently available modes:
    - `1`: Klee Simple Jump Cancel (NJ)
    - `2`: Klee Charged Attack (CJ)
    - `3`: Hu Tao Dash Cancel (9N2CD)
    - `4`: Hu Tao Jump Cancel (9N2CJ)
  - Probably will be reworked in the future with support for more characters and… stuff.
- Press `MMB` while on the map to quickly teleport.
  - Especially useful when there are multiple icons near the teleportation point. Saves a few clicks, seconds, and your sanity.

### ✨ Minor (possibly useful) additions
- Press `MMB` to:
  - Select and craft max ores (or other things in Blacksmith's menu).
  - Obtain crafted item.
  - Lock/Unlock an artifact or a weapon.
  - Enhance artifact/weapon.
  - Click «Craft»/«Convert» button in Crafting Bench.
  - Click «Confirm» button in some popups.
  - Collect Coins and Companion Exp in Tea Pot.
  - Click «Continue Challenge» in Domain.
  - Click «Skip» in Domain/Wish/Cutscenes.
  - Toggle «Auto-Play Story» mode in dialogue.
- Press `XButton1` to quickly purchase items from the shop.
  - Press `XButton2` to purchase items continuously. Press again to stop.
- `Numpad +` + `Numpad 0-9` to change current party (0 is 10).
- `Numpad -` + `Numpad 5` to go to the Serenitea Pot (via gadget).
- `Numpad -` + `Numpad 6` to receive and resend expeditions (use GUI to configure),
- `Numpad -` + `Numpad 8` to obtain all BP experience and rewards.
- `Numpad -` + `Numpad .` to relogin.
  - Useful for resetting bosses.
- `Numpad /` + `Numpad 1-9` to quickly change the time.
  - Think of numbers as of the in-game clock:
    - Numpad:        Time:
    - `7` `8` `9`   ` 9` `12` `15`
    - `4` ` ` `6`   ` 6` `  ` `18`
    - `1` `2` `3`   ` 3` `24` `21`
    - ` ` `0` `.`   `  ` `+1` `-1`
  - For example, `Numpad /` + `Numpad 7` will set the time to `9`.
  - Press `Numpad 0` inbetween to add 1 hour. For example, `Numpad /` + `Numpad 0` + `Numpad 7` will set the time to `10`.
  - Press `Numpad .` inbetween to subtract 1 hour. For example, `Numpad /` + `Numpad 0` + `Numpad 7` will set the time to `8`.
  - Press `Numpad *` inbetween to add 24 hours. For example, `Numpad /` + `Numpad *` + `Numpad 7` will set the time to `9` tomorrow.
  - And yes, you guessed it, `Numpad /` + `Numpad *` + `Numpad 0` + `Numpad 7` will set the time to `10` tomorrow.
    - `/` to trigger, `*` for tomorrow, `0` to add 1 hour, `7` for 9 hours. Tomorrow at 9 + 1 = 10. Simple :)
	- Some keyboards might limit such combinations, but you won't need them most times anyway.
  - `Numpad /` + `Numpad 5` is imposter, so it just opens the clock screen for you.

### 🎣 Automation (toggleable)
- Auto loot pickup.
  - Works with some prompts too. Should ignore dialogues, cooking, and challenges.
- Auto unfreeze/unbubble.
- Auto fishing.
  - You only have to throw the rod. Pulling and catching are done automatically.
  - Now you should just click `LMB` to toggle rod casting mode instead of holding.
- Easier/Lazy combat.
  - Hold `LMB` to spam normal attack.
  - Press `RMB` to porform charged attack.
    - Some characters have different charge attacks depending on the holding duration. You can hold `RMB` a bit more if needed.

### ⚙ Additional info
All links are stored inside the `yags_data/links.ini` file. You may remove/add your own stuff to your liking.

Just in case:
- `LMB`: Left Mouse Button
- `RMB`: Right Mouse Button
- `MMB`: Middle Mouse Button
- `XButton1`: Side Mouse Button 1
- `XButton2`: Side Mouse Button 2

`XButton1` and `XButton2` actions can be swapped (since different mouses use different mappings for some reason).

---

## ⚠ Disclaimer
Even though this script does not contain any cheats, only you are responsible for using it.

**Do not spread info about you using some third-party software**, and you shall be good. You've been warned.

---

This script was inspired by other available Genshin Impact AHK scripts. Go check them out too!
- [BGC script](https://github.com/onoderis/bgc-script)
- [Genshi AHK Flex](https://github.com/Kramar1337/GenshinImpact-AHK-flex)
- [genshin-impact-script](https://github.com/phonowell/genshin-impact-script)

Graphics assets generation thanks to [ImagePut](https://github.com/iseahound/ImagePut).

Venti drawing made by [@ACenturyMage](https://twitter.com/ACenturyMage/status/1325869153618718720).

Localization flags come from [Twemoji](https://twemoji.twitter.com/).
