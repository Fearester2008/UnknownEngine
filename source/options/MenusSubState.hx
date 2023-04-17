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

class MenusSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Menu Settings';
		rpcTitle = 'Menu Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Disable Menu Text',
			"If checked, text at the bottom of menu will be disabled.",
			'randomText',
			'bool',
			true);
		addOption(option);
		
		var option:Option = new Option('Menu Theme:',
			'What theme should the menu be?',
			'menuTheme',
			'string',
			'Light',
			['Light', 'Dark', 'Vanilla', 'Time of Day']);
		addOption(option);
		
		/*	
		var option:Option = new Option('Language:',
			'Choose a language to pick.',
			'langOption',
			'string',
			'English',
			['English', 'French', 'Portuguese']);
		addOption(option);
		*/

		super();
	}
}