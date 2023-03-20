package;

import lime.app.Application;
import flixel.FlxG;
import Discord.DiscordClient;

using StringTools;

class FirstCheckState extends MusicBeatState
{
	var isDebug:Bool = false;

	override public function create()
	{
		FlxG.mouse.visible = false;

		ClientPrefs.loadDefaultKeys();
		ClientPrefs.loadPrefs();

		super.create();

		#if debug
		isDebug = true;
		#end
	}

	override public function update(elapsed:Float)
	{		
		#if desktop
		#if CHECK_FOR UPDATES
		if (InternetConnection.isAvailable() && !isDebug)
		{
			var http = new haxe.Http("https://raw.githubusercontent.com/LeonGamerPS4/UnknownEngine/main/gitVersion.txt");
			var returnedData:Array<String> = [];

			http.onData = function(data:String)
			{
				returnedData[0] = data.substring(0, data.indexOf(';'));
				returnedData[1] = data.substring(data.indexOf('-'), data.length);

				if (!Application.current.meta.get('version').contains(returnedData[0].trim())
					&& !OutdatedState.leftState
					&& MainMenuState.nightly == "")
				{
					trace('outdated lmao! ' + returnedData[0] + ' != ' + Application.current.meta.get('version'));
					OutOfDate.needVer = returnedData[0];
					OutOfDate.changelog = returnedData[1];

					FlxG.switchState(new OutdatedState());
				}
				else
				{	
					switch (ClientPrefs.firstTime)
					{
						case true:
							FlxG.switchState(new FirstTimeState()); // First time language setting
						case false:
							FlxG.switchState(new TitleState()); // First time language setting
					}
				}
			}
		#end

			http.onError = function(error)
			{
				trace('error: $error');
				switch (ClientPrefs.firstTime)
				{
					case true:
						FlxG.switchState(new FirstTimeState()); // First time language setting
					case false:
						FlxG.switchState(new TitleState()); // First time language setting
				}
			}

			http.request();
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}
		else
		{
			trace('fucking offline noob');
			switch (ClientPrefs.firstTime)
			{
				case true:
					FlxG.switchState(new FirstTimeState()); // First time language setting
				case false:
					FlxG.switchState(new TitleState()); // First time language setting
			}
		}
		#else
		trace('ew html5');
		switch (ClientPrefs.firstTime)
			{
				case true:
					FlxG.switchState(new FirstTimeState()); // First time language setting
				case false:
					FlxG.switchState(new TitleState()); // First time language setting
			}
		#end
	}
}
