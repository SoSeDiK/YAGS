## ๐ [UNMAINTAINED] Yet Another Genshin Script

**My laptop can no longer run Genshin Impact (the game screen just freezes, many times even in the menu), and all my messages to support had no luck, so I have no way now of updating the script.**

---

<table>
  <tr>
    <td valign="center"><img src="YAGS/data/lang_en.png" width="16"/> English</td>
    <td valign="center"><a href="README_RU.md"><img src="YAGS/data/lang_ru.png" width="16"/> ะ ัััะบะธะน</a></td>
  </tr>
</table>

YAGS was made for personal usage to make the daily Genshin routine less annoying.

This script tries to improve controls, automate repeatable things, and bring some useful shortcuts.

Script is made solely for 1920x1080 game resolution in [borderless window mode](https://gaming.stackexchange.com/a/376533) with 60FPS in mind.

There are no plans to adapt it to other resolutions in the near future.

---

### โ How to
1. Download and install [AutoHotkey](https://www.autohotkey.com/) (only version 2).
2. Download this repository, extract `YAGS` folder.
3. Run `YAGS.ahk`.
4. Configure settings in the GUI if needed.
5. Run the game and enjoy.
6. Press `End` in case of an emergency to stop the script.

**Note:** in order to work properly, the script must be able to run with administrator privileges. This is due to the game not handling AHK's keyboard and mouse inputs properly otherwise.

---

### ๐จ Features
- Hold `F` to spam `F` >:)
- Hold `XButton1` to spam `F` even more!
  - For some reason, it's easier for me to use a mouse than to press `F`.
  - You may also use this to skip dialogues (you still have to do the choices manually).
- Hold `Space` to jump continuously.
  - Can be used to Bunnyhop (enter the sprinting mode and start jumping).
- Hold `XButton2` to jump continuously too!
  - Yes, I'm too lazy for `Spacebar`. Bunnyhop is possible as well.
  - Works with Waveriders.
  - May be used to skip dialogues too, but in addition also auto picks up the latest dialogue choice.
- Hold `1-4` keys to switch characters.
  - I can not be the only one who have chosen the wrong character in the past, and had to rage spam my keyboard to get another character asap, right? RIGHT?!
- Press `MMB` to toggle AutoWalk!
  - Press `RMB` to toggle sprint while auto walking.
  - `LShift` can be used for manual sprinting (useful to enter the sprinting mode and start Bunnyhopping).
- Press `H` to toggle Vision!
  - Makes it much easier, less annoying, and had to be done since `MMB` was changed.
- Hold `V` to auto attack!
  - By default does nothing. Press `Numpad *` + `Numpad 1-4` to change currently available modes:
    - `1`: Klee Simple Jump Cancel (NJ)
    - `2`: Klee Charged Attack (CJ)
    - `3`: Hu Tao Dash Cancel (9N2CD)
    - `4`: Hu Tao Jump Cancel (9N2CJ)
  - Probably will be reworked in the future with support for more characters andโฆ stuff.
- Press `MMB` while on the map to quickly teleport.
  - Especially useful when there are multiple icons near the teleportation point. Saves a few clicks, seconds, and your sanity.

### โจ Minor (possibly useful) additions
- Press `MMB` to:
  - Quickly buy max of a current item in the tea pot shop.
  - Select and craft max ores (or other things in Blacksmith's menu).
  - Lock/Unlock artifact or weapon.
  - Toggle ยซAuto-Play Storyยป mode in dialogue.
- Press `XButton1` to quickly purchase items from the shop.
  - Press `XButton2` to purchase items continuously, mainly for weapons or artifacts. Press again to stop.
- `Numpad -` + `Numpad 1-4` to change current party.
- `Numpad -` + `Numpad 5` to go to the Serenitea Pot (via gadget).
- `Numpad -` + `Numpad 6` to receive and resend expeditions (use GUI to configure),
- `Numpad -` + `Numpad 8` to obtain all BP experience and rewards.
- `Numpad -` + `Numpad .` to relogin.
  - Useful for resetting bosses.
- `Numpad /` + `Numpad 1-9` to quickly change the time.
  - Think of numbers as of the in-game clock:
    - Numpad:ย ย ย ย ย ย ย ย Time:
    - `7` `8` `9`ย ย ย `ย 9` `12` `15`
    - `4` `ย ` `6`ย ย ย `ย 6` `ย ย ` `18`
    - `1` `2` `3`ย ย ย `ย 3` `24` `21`
    - `ย ` `0` `.`ย ย ย `ย ย ` `+1` `-1`
  - For example, `Numpad /` + `Numpad 7` will set the time to `9`.
  - Press `Numpad 0` inbetween to add 1 hour. For example, `Numpad /` + `Numpad 0` + `Numpad 7` will set the time to `10`.
  - Press `Numpad .` inbetween to subtract 1 hour. For example, `Numpad /` + `Numpad 0` + `Numpad 7` will set the time to `8`.
  - Press `Numpad *` inbetween to add 24 hours. For example, `Numpad /` + `Numpad *` + `Numpad 7` will set the time to `9` tomorrow.
  - And yes, you guessed it, `Numpad /` + `Numpad *` + `Numpad 0` + `Numpad 7` will set the time to `10` tomorrow.
    - `/` to trigger, `*` for tomorrow, `0` to add 1 hour, `7` for 9 hours. Tomorrow at 9 + 1 = 10. Simple :)
	- Some keyboards might limit such combinations, but you won't need them most times anyway.
  - `Numpad /` + `Numpad 5` is imposter, so it just opens the clock screen for you.

### ๐ฃ Automation (toggleable)
- Auto loot pickup.
  - Works with some prompts too. Should ignore dialogues, cooking, and challenges.
- Auto unfreeze/unbubble.
- Auto fishing.
  - You only have to throw the rod. Pulling and catching are done automatically.
  - Now you should just click `LMB` to toggle rod casting mode instead of holding.
- Easier combat.
  - Hold `LMB` to spam attack.
  - Press `RMB` to charge attack.
    - Some characters have different charge attacks depending on the duration. You can hold `RMB` a bit more if needed.

### โ Additional info
All links are stored inside the [data/links.ini](YAGS/data/links.ini) file. You may remove/add your own stuff to your liking.

Just in case:
- `LMB`: Left Mouse Button
- `RMB`: Right Mouse Button
- `MMB`: Middle Mouse Button
- `XButton1`: Side Mouse Button 1
- `XButton2`: Side Mouse Button 2

`XButton1` and `XButton2` actions can be swapped (since different mouses use different mappings for some reason).

---

## โ  Disclaimer
Even though this script does not contain any cheats, only you are responsible for using it.

**Do not spread info about you using some third-party software**, and you shall be good. You've been warned.

---

This script was inspired by other available Genshin Impact AHK scripts. Go check them out too!
- [BGC script](https://github.com/onoderis/bgc-script)
- [Genshi AHK Flex](https://github.com/Kramar1337/GenshinImpact-AHK-flex)
- [genshin-impact-script](https://github.com/phonowell/genshin-impact-script)

Venti drawing made by [@ACenturyMage](https://twitter.com/ACenturyMage/status/1325869153618718720).

Localization flags come from [Twemoji](https://twemoji.twitter.com/).
