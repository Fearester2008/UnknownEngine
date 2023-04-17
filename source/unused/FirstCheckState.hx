package;

import lime.app.Application;
import flixel.FlxG;
import Discord.DiscordClient;

using StringTools;

class FirstCheckState extends MusicBeatState
{
	var isDebug:Bool = false;
	public static var firstTime:Bool = true;

	override public function create():Void
	{		
		FlxG.mouse.visible = false;

		super.create();

		#if debug
		isDebug = true;
		#end
	}

	override public function update(elapsed:Float)
	{		
		if(firstTime) {
			FlxG.switchState(new FirstTimeState()); // First time language setting
		} else if(!ClientPrefs.firstTime) {
			#if desktop
			FlxG.switchState(new Cache()); // First time language setting
			#else
			FlxG.switchState(new TitleState());
			#end
		}
	}
}
