package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class MiscSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Miscellaneous';
		rpcTitle = 'Miscellaneous Settings Menu'; //for Discord Rich Presence
				
		/*
		var option:Option = new Option('Note Skin:',
			"Based on Mind Games, how should they look like?",
			'noteSkin',
			'string',
			'Default',
			['Default', 'Future', 'Chip']);
		addOption(option);
		*/
		
		var option:Option = new Option('Menu Bottom Text',
			"If unchecked, funny text appears on the bottom\n of the menu, like CDEV.",
			'randomText',
			'bool',
			true);
		addOption(option);
		
		var option:Option = new Option('Icon Bops:',
			"What type should icon bopping be?",
			'iconBop',
			'string',
			'Unknown',
			['Unknown', 'Psych', 'PFNF',  'OS']);
		addOption(option);
		
		var option:Option = new Option('Menu Theme:',
			'What theme should the menu be?',
			'menuTheme',
			'string',
			'Light',
			['Light', 'Dark', 'Vanilla', 'Time of Day']);
		addOption(option);
		
		/*
		var option:Option = new Option('BF Version:',
			"What BF should be used in gameplay?",
			'bfAltVersion',
			'string',
			'Zero',
			['Normal', 'ZERO', 'TzenZoule']);
		addOption(option);
		option.showBoyfriend = true;
		option.onChange = onChangeBoyfriendOption;
		*/
		
		/*
		var option:Option = new Option('Filter:',
			'Change how colors of the game work,\n either for fun or if you\'re colorblind.',
			'colorFilter',
			'string',
			'None',
			['None', 'Tritanopia', 'Protanopia', 'Deutranopia', 'Virtual Boy', 'Gameboy', ' Downer', 'Grayscale', 'Invert']);
		addOption(option);
		*/
		super();
	}

	var changedMusic:Bool = false;
	function onChangePauseMusic()
	{
		if(ClientPrefs.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.pauseMusic)));

		changedMusic = true;
	}

	override function destroy()
	{
		if(changedMusic) FlxG.sound.playMusic(Paths.music('freakyMenu'));
		super.destroy();
	}

	/*
	function onChangeBoyfriendOption()
	{
		for (sprite in members)
		{
			var sprite:Dynamic = sprite; //Make it check for FlxSprite instead of FlxBasic
			var sprite:FlxSprite = sprite; //Don't judge me ok
			if(sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) {
				if (ClientPrefs.bfAltVersion == 'Normal') sprite.loadGraphic('characters/BOYFRIEND', true);
				if (ClientPrefs.bfAltVersion == 'ZERO') sprite.loadGraphic('characters/BOYFRIEND-ZERO', true);
				if (ClientPrefs.bfAltVersion == 'Reanimated') sprite.loadGraphic('characters/BOYFRIEND', true);
			}
		}
	}
	*/

	#if !mobile
	function onChangeFPSCounter()
	{
		if(Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.showFPS;
	}
	#end
}