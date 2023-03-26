package;

import lime.app.Application;
import flixel.FlxG;
import Discord.DiscordClient;

using StringTools;

class FirstCheckState extends MusicBeatState
{
	var isDebug:Bool = false;
	public static var firstTime:Bool = true;

	override public function create()
	{
		FlxG.mouse.visible = false;

		super.create();

		#if debug
		isDebug = true;
		#end
	}

	override public function update(elapsed:Float)
	{		
		if(firstTime == true) {
			FlxG.switchState(new FirstTimeState()); // First time language setting
		} else {
			FlxG.switchState(new Cache()); // First time language setting
		}
		
	}
}
