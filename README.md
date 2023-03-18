<p align="center">
	<a href="https://github.com/LeonGamerPS4/UnknownEngine/blob/main/assets/preload/images/UELogo_LS.png" target="_blank"><img src="/assets/preload/images/UELogo_LS.png"></a>
</p>

# This is the repository for Friday Night Funkin': Unknown Engine, an engine built off of [Psych Engine.](https://github.com/ShadowMario/FNF-PsychEngine)

Support Funkin' on [Newgrounds](https://www.newgrounds.com/portal/view/770371), [GitHub](https://github.com/ninjamuffin99/Funkin), and [Itch.io](https://ninja-muffin24.itch.io/funkin)!
 
## Customization:

If you wish to disable things like *Lua Scripts* or *Video Cutscenes*, you can read over to `Project.xml`

inside `Project.xml`, you will find several variables to customize Unknown Engine to your liking

to start you off, disabling Videos should be simple, simply Delete the line `"VIDEOS_ALLOWED"` or comment it out by wrapping the line in XML-like comments, like this `<!-- YOUR_LINE_HERE -->`

same goes for *Lua Scripts*, comment out or delete the line with `LUA_ALLOWED`, this and other customization options are all available within the `Project.xml` file

## Credits
* LeonGamer - Coding for Unknown Engine
* UmbraFromTDS - Co-Developer of Unknown Engine
* C97Mystical - Assistant Coding
* AshishXMC - Arts for Unknown Engine

## Psych Engine
* Shadow Mario - Coding for Psych Engine
* RiverOaken - Arts and Animations for Psych Engine
* bbpanzu - Assistant Coding

## Mic'd Up
* Verwex - Mic'd Up itself
* KadeDev - Additional Programmer
* Ash237 - Additional Programmer

### Special Thanks
* xenkap - Flare Engine Menu + Funny Pause Menu texts
* shubs - New Input System
* SqirraRNG - Chart Editor's Sound Waveform base code
* iFlicky - Delay/Combo Menu Song Composer + Dialogue Sounds
* PolybiusProxy - .MP4 Loader Extension
* Keoiki - Note Splash Animations
* Smokey - Spritemap Texture Atlas support
* Cary - OG Resolution code
* Nebula_Zorua - VCR Shader code

<p align="center">
	<a href="https://github.com/LeonGamerPS4/UnknownEngine/blob/main/assets/preload/images/intrologo.png" target="_blank"><img src="/assets/preload/images/intrologo.png"></a>
</p>
 
# Compiling

## What can I do with compiling the mod? Why should I compile the mod instead of downloading it from the newest releases?

Compiling the mod gives access to the `/source` folder, allowing you to change the code of the mod. You can add a lot of cool things with the open-source code!

I recommend having a good idea on how to program. Compiling the mod is not for everyone!

If you just want to download and play the mod normally, you can click [here to go to the GameBanana page of the mod](https://gamebanana.com/mods/383504)!

### **If you do want to compile, continue reading!**

### Installing the Required Programs

First, you need to install Haxe and HaxeFlixel. I'm too lazy to write and keep updated with that setup (which is pretty simple). 
1. [Install Haxe](https://haxe.org/download/) (Download the latest vversion, seriously, stop using 4.1.5, it misses some stuff.)
2. [Install HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/) after downloading Haxe

Other installations you'd need are the additional libraries, a fully updated list will be in `Project.xml` in the project root. Currently, these are all of the things you need to install:
```
flixel
flixel-addons
flixel-ui
hscript
newgrounds
```
So for each of those type `haxelib install [library]` so shit like `haxelib install newgrounds`

You'll also need to install a couple things that involve Gits. To do this, you need to do a few things first.
1. Download [git-scm](https://git-scm.com/downloads). Works for Windows, Mac, and Linux, just select your build.
2. Follow instructions to install the application properly.
3. Run `haxelib git polymod https://github.com/larsiusprime/polymod.git` to install Polymod.
4. Run `haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc` to install Discord RPC.

You also need to install LuaJIT. If you don't want your mod to run .lua scripts, delete the "LUA_ALLOWED" line on Project.xml.
Run `haxelib git linc_luajit https://github.com/AndreiRudenko/linc_luajit` to install LuaJIT.

You should have everything ready for compiling the game! Follow the guide below to continue!

At the moment, you can optionally fix the transition bug in songs with zoomed-out cameras.
- Run `haxelib git flixel-addons https://github.com/HaxeFlixel/flixel-addons` in the terminal/command-prompt.

### Compiling game
NOTE: If you see any messages relating to deprecated packages, ignore them. They're just warnings that don't affect compiling

Once you have all those installed, it's pretty easy to compile the game. You just need to run `lime test html5 -debug` in the root of the project to build and run the HTML5 version. (command prompt navigation guide can be found here: [https://ninjamuffin99.newgrounds.com/news/post/1090480](https://ninjamuffin99.newgrounds.com/news/post/1090480))
To run it from your desktop (Windows, Mac, Linux) it can be a bit more involved. For Linux, you only need to open a terminal in the project directory and run `lime test linux -debug` and then run the executable file in export/release/linux/bin. For Windows, you need to install Visual Studio Community 2019. While installing VSC, don't click on any of the options to install workloads. Instead, go to the individual components tab and choose the following:
* MSVC v142 - VS 2019 C++ x64/x86 build tools
* Windows SDK (10.0.17763.0)

Once that is done you can open up a command line in the project's directory and run `lime test windows -debug`. Once that command finishes (it takes forever even on a higher end PC), you can run FNF from the .exe file under export\release\windows\bin
As for Mac, 'lime test mac -debug' should work, if not the internet surely has a guide on how to compile Haxe stuff for Mac.

### Additional guides

- [Command line basics](https://ninjamuffin99.newgrounds.com/news/post/1090480)

 
