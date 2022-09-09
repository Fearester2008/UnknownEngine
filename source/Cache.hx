#if sys
package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxGradient;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import lime.app.Application;
#if windows
import Discord.DiscordClient;
#end
import openfl.display.BitmapData;
import openfl.utils.Assets;
import haxe.Exception;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.FlxState;
import flixel.math.FlxRect;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import lime.system.ThreadPool;
#if cpp
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class Cache extends FlxState
{	
	public static var bitmapData:Map<String,FlxGraphic>;
	public static var bitmapData2:Map<String,FlxGraphic>;
	var gradientBar:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 1, 0xFFAA00AA);
	var splash:FlxSprite;
	var text:FlxText;

	var images = [];
	var music = [];
	
	/**var factsShit = [
		[Tip Don't\n spam like\n a fuckin noob.], 
		[Tip If you make\n a Psych Port,\n don't expect free\n clout.], 
		[Fact This "ENGINE"\n is just a\n Psych Engine fork.], 
		[Fact This engine is truly unknown.], 
		[Tip Don't be fucking\n idiotic and\n press any hurt\n notes.], 
		[Fact This isn't a\n kids game.], 
		[Tip Don't play mods\n online, it's \n basically piracy.], 
		[Tip No tip here.],
		[Tip Spammy songs\n require ghost \ntapping. If \nyou don't use\n it, you're\n fucked.], 
		[Fact Input in the vanilla engine sucked ass.], 
		[];
	]**/

	override function create()
	{
		FlxG.mouse.visible = true;

		FlxG.worldBounds.set(0,0);

		bitmapData = new Map<String,FlxGraphic>();
		bitmapData2 = new Map<String,FlxGraphic>();
		
		super.create();

		splash = new FlxSprite().loadGraphic(Paths.image("titlelogo"));
		splash.screenCenter();
		splash.y -= 30;
		splash.antialiasing = true;
		add(splash);
		
		gradientBar = FlxGradient.createGradientFlxSprite(Math.round(FlxG.width), 512, [0x00ff0000, 0x553D0468, 0xAABF1943], 1, 90, true);
		gradientBar.y = FlxG.height - gradientBar.height;
		add(gradientBar);
		gradientBar.scrollFactor.set(0, 0);
		
		text = new FlxText(200, 630, 0, "Loading...");
		text.setFormat("VCR OSD Mono", 50, FlxColor.WHITE, CENTER);
		text.updateHitbox();
		text.screenCenter(X);
		text.x = Math.ffloor(text.x);
		text.y = Math.ffloor(splash.y + splash.height + 45);
		text.antialiasing = true;
		add(text);
		
		//tipText = new FlxText(-270, 630, 0, 

		#if cpp
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters")))
		{
			if (!i.endsWith(".png"))
				continue;
			images.push(i);
		}

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs")))
		{
			music.push(i);
		}
		#end

		sys.thread.Thread.create(() -> {
			cache();
		});

		super.create();
	}

	override function update(elapsed) 
	{
		super.update(elapsed);
	}

	function cache()
	{
		#if !linux

		for (i in images)
		{
			var replaced = i.replace(".png","");
			var data:BitmapData = BitmapData.fromFile("assets/shared/images/characters/" + i);
			var graph = FlxGraphic.fromBitmapData(data);
			graph.persist = true;
			graph.destroyOnNoUse = false;
			bitmapData.set(replaced,graph);
			trace(i);
		}



		for (i in music)
		{
			trace(i);
		}


		#end
		FlxG.switchState(new TitleState());
	}

}
#end