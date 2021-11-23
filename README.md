## 🎈 Yet Another Genshin Script

<table>
  <tr>
    <td valign="center"><img src="YAGS/data/lang_en.png" width="16"/> English</td>
    <td valign="center"><a href="README_RU.md"><img src="YAGS/data/lang_ru.png" width="16"/> Русский</a></td>
  </tr>
</table>

YAGS was made for personal usage to make the daily Genshin routine less annoying.

This script tries to improve controls, automate repeatable things, and bring some useful shortcuts.

Script is made solely for 1920x1080 game resolution in [borderless window mode](https://gaming.stackexchange.com/a/376533) with 60FPS in mind.

There are no plans to adapt it to other resolutions in the near future.

---

### ❓ How to
1. Download and install [AutoHotkey](https://www.autohotkey.com/) (only version 2).
2. Download this repository.
3. Run `YAGS.ahk`.
4. Configure settings in the GUI if needed.
5. Run the game and enjoy.
6. Press `End` in case of an emergency to stop the script.

**Note:** in order to work properly, the script must be able to run with administrator privileges. This is due to the game not handling AHK's keyboard and mouse inputs properly otherwise.

---

### 🎨 Features
- Hold `F` to spam `F` >:)
- Hold `XButton1` to spam `F` even more!
  - For some reason, it's easier for me to use a mouse than to press `F`.
  - You may also use this to skip dialogues (you still have to do the choices manually).
- Press `XButton2` to jump!
  - Yep, I'm too lazy for `Spacebar`.
  - Works with Waveriders.
  - May be used to skip dialogues too, but in addition also auto picks up the latest dialogue choice.
- Hold `1-4` keys to switch characters.
  - I can not be the only one who have chosen the wrong character in the past, and had to rage spam my keyboard to get another character asap, right? RIGHT?!
- Press `MMB` to toggle AutoWalk!
  - Press `LShift` or `RMB` to toggle sprint while auto walking.
- Press `H` to toggle Vision!
  - Makes it much easier, less annoying, and had to be done since `MMB` was changed.
- Hold `V` to "smart attack" (9N2CJ) with Hu Tao!
  - Probably will be reworked in the future with support for more characters and… stuff.
- Press `MMB` while on the map to quickly teleport.
  - Especially useful when there are multiple icons near the teleportation point. Saves a few clicks, seconds, and your sanity.

### ✨ Minor (possibly useful) additions
- Press `MMB` to:
  - Quickly purchase weapons or artifacts from the shop. Should work with other shops too, but be careful.
  - Select and craft max ores (or other things in Blacksmith's menu).
  - Lock artifact.
- `Numpad -` + `Numpad 1-4` to change current party.
- `Numpad 5` to go to the Serenitea Pot (via gadget).
- `Numpad 6` to receive and resend expeditions (use GUI to configure),
- (Optional: `Numpad -` +) `Numpad 7` to skip till the next (day/) night.
- `Numpad 8` to obtain all BP experience and rewards.
- `Numpad .` to relogin.
  - Useful for resetting bosses if your game loads quickly.

### 🎣 Automation (toggleable)
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

### ⚙ Additional info
All links are stored inside the [data/links.ini](YAGS/data/links.ini) file. You may remove/add your own stuff to your liking.

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

Venti drawing made by [@ACenturyMage](https://twitter.com/ACenturyMage/status/1325869153618718720).

Localization flags come from [Twemoji](https://twemoji.twitter.com/).
