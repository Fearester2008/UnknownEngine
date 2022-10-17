package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxGradient;

class OutdatedState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
	var checker:FlxBackdrop = new FlxBackdrop(Paths.image('menuChecker'), 0.2, 0.2, true, true);
	var gradientBar:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 300, 0xFFAA00AA);
	
	var warnText:FlxText;
	override function create()
	{
		super.create();

		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.screenCenter();
		
		gradientBar = FlxGradient.createGradientFlxSprite(Math.round(FlxG.width), 512, [0x00ff0000, 0x55AE59E4, 0xAA19ECFF], 1, 90, true);
		gradientBar.y = FlxG.height - gradientBar.height;
		add(gradientBar);
		gradientBar.scrollFactor.set(0, 0);

		add(checker);
		checker.scrollFactor.set(0, 0.07);

		warnText = new FlxText(0, 0, FlxG.width,
			"Sup bro, looks like you're running an   \n
			outdated version of Unknown Engine (" + MainMenuState.unknownEngineVersion + "),\n
			please update to " + TitleState.updateVersion + "!\n
			//Press ENTER to update.\n
			Press ESCAPE to proceed anyway.\n
			\n
			Thank you for using the Engine/Mod!",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		warnText.screenCenter(Y);
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		checker.x -= 0.45 / (ClientPrefs.framerate / 60);
		checker.y -= 0.16 / (ClientPrefs.framerate / 60);
		
		if(!leftState) {
			if (controls.ACCEPT) {
				//#if windows
				//FlxG.sound.play(Paths.sound('confirmMenu'));
				//FlxG.switchState(new UpdateState(files));
				//#else
				leftState = true;
				FlxG.openURL('https://www.github.com/LeonGamerPS4/UnknownEngine/releases/latest');
				//#end
			}
			else if(controls.BACK) {
				leftState = true;
			}

			if(leftState)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new MainMenuState());
					}
				});
			}
		}
		super.update(elapsed);
	}
}
