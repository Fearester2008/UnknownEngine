package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.util.FlxTimer;
import flixel.util.FlxGradient;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.math.FlxMath;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var unknownEngineVersion:String = '2.0a'; // Used for OutdatedState and PlayState
	public static var fnfMuVersion:String = '2.0.3';
	public static var psychEngineVersion:String = '0.6.3';
	
	public static var curSelected:Int = 0;
	public static var nightly:String = "a";

	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = [
		'play',
		#if MODS_ALLOWED 'mods', #end
		#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'credits',
		#if !switch 'donate', #end
		'options'
	];

	var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('mBG_Main'));
	var beef:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('menuBF'));
	var side:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('Main_Side'));

	public var menuItem:FlxSprite;
	public var yScroll:Float;

	var checker:FlxBackdrop = new FlxBackdrop(Paths.image('menuChecker'), 0.2, 0.2, true, true);
	var gradientBar:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 300, 0xFFAA00AA);
	
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;
	
	var randomTxt:FlxText;
	
	var gameTimeElapsed:FlxText;

	var isTweening:Bool = false;
	var lastString:String = '';
	var camLerp:Float = 0.1;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			Conductor.changeBPM(102);
		}

		persistentUpdate = persistentDraw = true;

		yScroll = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.angle = 179;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);
		
		gradientBar = FlxGradient.createGradientFlxSprite(Math.round(FlxG.width), 512, [0x00ff0000, 0x55AE59E4, 0xAA19ECFF], 1, 90, true);
		gradientBar.y = FlxG.height - gradientBar.height;
		add(gradientBar);
		gradientBar.scrollFactor.set(0, 0);

		checker.blend = MULTIPLY;
		checker.alpha = 0.65;
		add(checker);
		checker.scrollFactor.set(0, 0.07);

		beef.scrollFactor.x = 0;
		beef.scrollFactor.y = 0;
		beef.antialiasing = true;
		beef.setGraphicSize(Std.int(bg.width * 0.32));
		beef.updateHitbox();
		beef.screenCenter();
		beef.x = 1000;
		beef.y = 115;
		add(beef);

		side.scrollFactor.x = 0;
		side.scrollFactor.y = 0;
		side.setGraphicSize(Std.int(side.width * 0.75));
		side.updateHitbox();
		side.screenCenter();
		side.antialiasing = true;
		side.x = -500;
		side.y = -90;
		add(side);
		
		if(ClientPrefs.menuTheme == 'Dark') {
			bg.loadGraphic(Paths.image('menuDark'));
			checker.visible = false;
		}
		
		if(ClientPrefs.menuTheme == 'Vanilla') {
			bg.loadGraphic(Paths.image('menuBGVanilla'));
			checker.visible = false;
			gradientBar.visible = false;
			beef.visible = false;
		}
		
		if(ClientPrefs.menuTheme == 'Time of Day') {
            var hours:Int = Date.now().getHours();
            if(hours > 18) {
                bg.loadGraphic(Paths.image('menuDark'));
				checker.visible = false;
            } else if(hours > 8) {
                bg.loadGraphic(Paths.image('mBG_Main'));
				checker.visible = true;
            }
        }

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			// var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 40;
			menuItem = new FlxSprite(0, (i * 70));
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			FlxTween.tween(menuItem, {x: menuItem.width / 4 + (i * 60) - 55}, 1.3, {ease: FlxEase.expoInOut});
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if (optionShit.length < 6)
				scr = 0;
			menuItem.scale.set(0.8, 0.8);
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			// menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		camGame.follow(camFollow, null, camLerp);

		camGame.zoom = 3;
		FlxTween.tween(camGame, {zoom: 1}, 1.1, {ease: FlxEase.expoInOut});
		FlxTween.tween(bg, {angle: 0}, 1, {ease: FlxEase.quartInOut});
		FlxTween.tween(side, {x: -80}, 0.9, {ease: FlxEase.quartInOut});
		FlxTween.tween(beef, {x: 725}, 0.9, {ease: FlxEase.quartInOut});
		
		var bottomPanel:FlxSprite = new FlxSprite(0, FlxG.height - 100).makeGraphic(FlxG.width, 100, 0xFF000000);
		bottomPanel.visible = !ClientPrefs.randomText;
		bottomPanel.alpha = 0.5;
		add(bottomPanel);	

		gameTimeElapsed = new FlxText(0, 15, 1000, "", 16);
		gameTimeElapsed.scrollFactor.set();
		gameTimeElapsed.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		gameTimeElapsed.visible = !ClientPrefs.showTimeOfDay;
		add(gameTimeElapsed);
		
		randomTxt = new FlxText(20, FlxG.height - 80, 1000, "", 26);
		randomTxt.scrollFactor.set();
		randomTxt.setFormat("VCR OSD Mono", 26, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		randomTxt.visible = !ClientPrefs.randomText;
		add(randomTxt);
		
		bottomPanel.scrollFactor.set();

		camGame.follow(camFollowPos, null, 1);
		#if !html5
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 1250, "FNF Redux (Unknown Engine) v" + Application.current.meta.get('version') + " \\ Friday Night Funkin' v0.2.8", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24,  FlxG.width - 24, "Mic'd Up v" + fnfMuVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		#else
		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 1250, "This is an unofficial build of UE. \n Do not report any bugs from this build.", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		#end

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
		{
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if (!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2]))
			{ // It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			selectable = true;
		});
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement()
	{
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectable:Bool = false;
	var selectedSomethin:Bool = false;
	var timer:Float = 0;

	var holdTime:Float = 0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}
		
		if (!selectedSomethin){
			if (isTweening){
				randomTxt.screenCenter(X);
				timer = 0;
			}else{
				randomTxt.screenCenter(X);
				timer += elapsed;
				if (timer >= 3)
				{
					changeText();
				}
			}
		}

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.scale.set(FlxMath.lerp(spr.scale.x, 0.8, camLerp / (ClientPrefs.framerate / 60)),
				FlxMath.lerp(spr.scale.y, 0.8, 0.4 / (ClientPrefs.framerate / 60)));
			spr.y = FlxMath.lerp(spr.y, -20 + (spr.ID * 100), 0.4 / (ClientPrefs.framerate / 60));

			if (spr.ID == curSelected)
			{
				spr.scale.set(FlxMath.lerp(spr.scale.x, 1.1, camLerp / (ClientPrefs.framerate / 60)),
					FlxMath.lerp(spr.scale.y, 1.1, 0.4 / (ClientPrefs.framerate / 60)));
				spr.y = FlxMath.lerp(spr.y, -90 + (spr.ID * 100), 0.4 / (ClientPrefs.framerate / 60));
			}

			spr.updateHitbox();
		});

		checker.x -= 0.45 / (ClientPrefs.framerate / 60);
		checker.y -= 0.16 / (ClientPrefs.framerate / 60);

		if (!selectedSomethin && selectable)
		{
			var shiftMult:Int = 1;
			if (FlxG.keys.pressed.SHIFT)
				shiftMult = 3;
				
			var ctrl = FlxG.keys.justPressed.CONTROL;
			var alt = FlxG.keys.justPressed.ALT;

			if (FlxG.mouse.wheel != 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-FlxG.mouse.wheel);
			}
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-shiftMult);
				holdTime = 0;
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(shiftMult);
				holdTime = 0;
			}

			if (controls.UI_DOWN || controls.UI_UP)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if (holdTime > 0.5 && checkNewHold - checkLastHold > 0)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
				}
			}
			
			if (ctrl)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new SleepModeState());
			}
			
			/*
			if (alt)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MarathonMenu());
			}
			*/

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT || FlxG.mouse.justPressedRight)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					menuItems.forEach(function(spr:FlxSprite)
					{
						FlxTween.tween(camGame, {zoom: 10}, 1.6, {ease: FlxEase.expoIn});
						FlxTween.tween(bg, {angle: 90}, 1.6, {ease: FlxEase.expoIn});
						FlxTween.tween(spr, {x: -600}, 0.6, {
							ease: FlxEase.backIn,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
						FlxTween.tween(side, {x: -500}, 1.2, {ease: FlxEase.quartInOut});
						FlxTween.tween(beef, {x: 1000}, 1.2, {ease: FlxEase.quartInOut});
						new FlxTimer().start(0.5, function(tmr:FlxTimer)
						{
							var daChoice:String = optionShit[curSelected];

							switch (daChoice)
							{
								case 'play':
									MusicBeatState.switchState(new PlaySelectionState());
								#if MODS_ALLOWED
								case 'mods':
									MusicBeatState.switchState(new ModsMenuState());
								#end
								case 'awards':
									MusicBeatState.switchState(new AchievementsMenuState());
								case 'credits':
									MusicBeatState.switchState(new CreditsState());
								case 'options':
									LoadingState.loadAndSwitchState(new options.OptionsState());
							}
						});
					});
				}
			}
		}
		#if desktop
		if (FlxG.keys.anyJustPressed(debugKeys))
		{
			selectedSomethin = true;
			MusicBeatState.switchState(new MasterEditorMenu());
		}
		#end

		menuItems.forEach(function(spr:FlxSprite)
		{
			if (spr.ID == curSelected)
			{
				camFollow.y = FlxMath.lerp(camFollow.y, spr.getGraphicMidpoint().y, camLerp / (ClientPrefs.framerate / 60));
				camFollow.x = spr.getGraphicMidpoint().x;
			}
		});

		FlxG.watch.addQuick("beatShit", curBeat);
		
		super.update(elapsed);
	}
	
	override function beatHit()
	{
		super.beatHit();
        if(curBeat % 2 == 0)
        	FlxG.camera.zoom += 0.025;
	}
	
	function updateGameInfo()
	{
		var hours:String = '' + Date.now().getHours();
		var minutes:String = '' + Date.now().getMinutes();

		if (minutes.length < 2)
			minutes = '0' + Date.now().getMinutes();
		if (hours.length < 2)
			hours = '0' + Date.now().getHours();

		var formattedTime:String = hours + ":" + minutes + '.';
			
		gameTimeElapsed.text = 'It is currently ' + formattedTime + '.';

		gameTimeElapsed.x = (FlxG.width - gameTimeElapsed.width) - 20;
	}
	
	function changeText()
	{
		var selectedText:String = '';
		var textArray:Array<String> = CoolUtil.coolTextFile(Paths.txt('tipText'));
	
		randomTxt.alpha = 1;
		isTweening = true;
		selectedText = textArray[FlxG.random.int(0, (textArray.length - 1))].replace('--', '\n');
		FlxTween.tween(randomTxt, {alpha: 0}, 1, {
			ease: FlxEase.linear,
			onComplete: function(shit:FlxTween)
			{
				if (selectedText != lastString)
				{
					randomTxt.text = selectedText;
					lastString = selectedText;
				}
				else
				{
					selectedText = textArray[FlxG.random.int(0, (textArray.length - 1))].replace('--', '\n');
					randomTxt.text = selectedText;
				}

				randomTxt.alpha = 0;

				FlxTween.tween(randomTxt, {alpha: 1}, 1, {
					ease: FlxEase.linear,
					onComplete: function(shit:FlxTween)
					{
						isTweening = false;
					}
					
				});
			}
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if (menuItems.length > 4)
				{
					add = menuItems.length * 8;
				}
				// camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				// spr.centerOffsets();
			}
		});
	}
}