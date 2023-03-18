package options;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.util.FlxGradient;

class SleepModeState extends MusicBeatState
{	
	var sleepText:FlxText;
	public static var leftState:Bool = false;
	static var wentToPlayState:Bool = false;
	
	public function new(?wentToPlayState:Bool)
	{
		super();
		if (wentToPlayState != null)
			SleepModeState.wentToPlayState = wentToPlayState;
	}
	
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		sleepText = new FlxText(0, 0, FlxG.width,
			"The game is currently in a resting state.\n
			\n
			Press ENTER to Continue.",
			32);
		sleepText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		sleepText.screenCenter(Y);
		add(sleepText);
	}
	
	override function update(elapsed:Float)
	{
		if (controls.ACCEPT) {
			FlxG.sound.play(Paths.sound('confirmMenu'));
			if (wentToPlayState) {
				StageData.loadDirectory(PlayState.SONG);
				wentToPlayState = false;
				LoadingState.loadAndSwitchState(new PlayState(), true);
			} else {
				FlxTween.tween(sleepText, {x: -1500}, 3.7, {ease: FlxEase.expoInOut});
				MusicBeatState.switchState(new options.OptionsState());
		}
	}
}	
	

}