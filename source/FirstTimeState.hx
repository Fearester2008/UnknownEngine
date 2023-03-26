package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import openfl.Lib;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class FirstTimeState extends MusicBeatState
{
	var sinMod:Float = 0;
	var warnText:FlxText;
	
	public static var leftState:Bool = false;
	public static var isNotFirstTime:Bool = false;
	
	override function create()
	{
		var lol = (cast(Lib.current.getChildAt(0), Main)).lastY;
		FlxTween.tween(Application.current.window, {y: lol}, 0.5, {ease: FlxEase.circOut});
		
		#if desktop
		DiscordClient.changePresence("First time on Unknown Engine.", null);
		#end
		
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"WARNING:\nFNF: Unknown Engine may potentially trigger seizures for people with photosensitive epilepsy. Viewer discretion is advised.\n\n"
			+ "FNF: Unknown Engine is a non-profit modification, aimed for entertainment purposes, and wasn't meant to be an attack on Ninjamuffin99"
			+ " and/or any other modmakers out there. I was not aiming for replacing what Friday Night Funkin' was, is and will."
			+ " It was made for fun and from the love for the game itself. All of the comparisons between this and other mods are purely coincidental, unless stated otherwise.\n\n"
			+ "Now with that out of the way, I hope you'll enjoy this FNF mod.\nFunk all the way.\nPress ENTER to proceed",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
		
		super.create();	
	}

	override function update(elapsed:Float)
	{
		var no:Bool = false;
		sinMod += 0.007;
		warnText.y = Math.sin(sinMod) * 60 + 100;

		if (FlxG.keys.justPressed.ENTER)
		{
			leftState = true;			
			FirstCheckState.firstTime = false;
			isNotFirstTime = true;
			trace('gameng tiem');
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker) {
			new FlxTimer().start(0.5, function (tmr:FlxTimer) {
			MusicBeatState.switchState(new Cache());
			});
		  });
		}

		super.update(elapsed);
	}
}
