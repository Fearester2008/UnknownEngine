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
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxGradient;
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

class ControlsSubState extends MusicBeatSubstate {
	private static var curSelected:Int = 1;
	private static var curAlt:Bool = false;
	
	var bg:FlxSprite = new FlxSprite(-89).loadGraphic(Paths.image('cBG_Main'));
	var checker:FlxBackdrop = new FlxBackdrop(Paths.image('Cont_Checker'), 0.2, 0.2, true, true);
	var gradientBar:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 300, 0xFFAA00AA);

	private static var defaultKey:String = 'Reset to Default Keys';
	private var bindLength:Int = 0;

	var optionShit:Array<Dynamic> = [
		['NOTES'],
		['Left', 'note_left'],
		['Down', 'note_down'],
		['Up', 'note_up'],
		['Right', 'note_right'],
		[''],
		['UI'],
		['Left', 'ui_left'],
		['Down', 'ui_down'],
		['Up', 'ui_up'],
		['Right', 'ui_right'],
		[''],
		['Reset', 'reset'],
		['Accept', 'accept'],
		['Back', 'back'],
		['Pause', 'pause'],
		[''],
		['VOLUME'],
		['Mute', 'volume_mute'],
		['Up', 'volume_up'],
		['Down', 'volume_down'],
		[''],
		['DEBUG'],
		['Key 1', 'debug_1'],
		['Key 2', 'debug_2']
	];

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var grpInputs:Array<AttachedText> = [];
	private var grpInputsAlt:Array<AttachedText> = [];
	var rebindingKey:Bool = false;
	var nextAccept:Int = 5;

	public function new() {
		super();

		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		
		gradientBar = FlxGradient.createGradientFlxSprite(Math.round(FlxG.width), 512, [0x00ff0000, 0x55FFBDF8, 0xAAFFFDF3], 1, 90, true);
		gradientBar.y = FlxG.height - gradientBar.height;
		add(gradientBar);
		gradientBar.scrollFactor.set(0, 0);

		add(checker);
		checker.scrollFactor.set(0, 0.07);

		var side:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('SideControls'));
		side.scrollFactor.x = 0;
		side.scrollFactor.y = 0;
		side.antialiasing = true;
		add(side);
		side.x = 0;
		
		if(ClientPrefs.menuTheme == 'Dark') {
			bg.loadGraphic(Paths.image('menuBGDarkO'));
			checker.visible = false;
			gradientBar.visible = false;
		}
		
		if(ClientPrefs.menuTheme == 'Vanilla') {
			bg.color = 0xFFea71fd;
			bg.loadGraphic(Paths.image('menuDesat'));
			checker.visible = false;
			gradientBar.visible = false;
		}
		
		if(ClientPrefs.menuTheme == 'Time of Day') {
            var hours:Int = Date.now().getHours();
            if(hours > 18) {
                bg.loadGraphic(Paths.image('menuBGDarkO'));
				checker.visible = false;
				gradientBar.visible = false;
            } else if(hours > 8) {
                bg.loadGraphic(Paths.image('cBG_Main'));
				checker.visible = true;
				gradientBar.visible = true;
            }
        }

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		optionShit.push(['']);
		optionShit.push([defaultKey]);

		for (i in 0...optionShit.length) {
			var isCentered:Bool = false;
			var isDefaultKey:Bool = (optionShit[i][0] == defaultKey);
			if(unselectableCheck(i, true)) {
				isCentered = true;
			}

			var optionText:Alphabet = new Alphabet(200, 300, optionShit[i][0], (!isCentered || isDefaultKey));
			optionText.isMenuItem = true;
			if(isCentered) {
				optionText.screenCenter(X);
				optionText.y -= 55;
				optionText.startPosition.y -= 55;
			}
			optionText.changeX = false;
			optionText.distancePerItem.y = 60;
			optionText.targetY = i - curSelected;
			optionText.snapToPosition();
			grpOptions.add(optionText);

			if(!isCentered) {
				addBindTexts(optionText, i);
				bindLength++;
				if(curSelected < 0) curSelected = i;
			}
		}
		changeSelection();
	}

	var leaving:Bool = false;
	var bindingTime:Float = 0;
	override function update(elapsed:Float) {
		checker.x -= 0.21;
		checker.y -= 0.51;
		if(!rebindingKey) {
			if (controls.UI_UP_P) {
				changeSelection(-1);
			}
			if (controls.UI_DOWN_P) {
				changeSelection(1);
			}
			if (controls.UI_LEFT_P || controls.UI_RIGHT_P) {
				changeAlt();
			}

			if (controls.BACK) {
				ClientPrefs.reloadControls();
				close();
				FlxG.sound.play(Paths.sound('cancelMenu'));
			}

			if(controls.ACCEPT && nextAccept <= 0) {
				if(optionShit[curSelected][0] == defaultKey) {
					ClientPrefs.keyBinds = ClientPrefs.defaultKeys.copy();
					reloadKeys();
					changeSelection();
					FlxG.sound.play(Paths.sound('confirmMenu'));
				} else if(!unselectableCheck(curSelected)) {
					bindingTime = 0;
					rebindingKey = true;
					if (curAlt) {
						grpInputsAlt[getInputTextNum()].alpha = 0;
					} else {
						grpInputs[getInputTextNum()].alpha = 0;
					}
					FlxG.sound.play(Paths.sound('scrollMenu'));
				}
			}
		} else {
			var keyPressed:Int = FlxG.keys.firstJustPressed();
			if (keyPressed > -1) {
				var keysArray:Array<FlxKey> = ClientPrefs.keyBinds.get(optionShit[curSelected][1]);
				keysArray[curAlt ? 1 : 0] = keyPressed;

				var opposite:Int = (curAlt ? 0 : 1);
				if(keysArray[opposite] == keysArray[1 - opposite]) {
					keysArray[opposite] = NONE;
				}
				ClientPrefs.keyBinds.set(optionShit[curSelected][1], keysArray);

				reloadKeys();
				FlxG.sound.play(Paths.sound('confirmMenu'));
				rebindingKey = false;
			}

			bindingTime += elapsed;
			if(bindingTime > 5) {
				if (curAlt) {
					grpInputsAlt[curSelected].alpha = 1;
				} else {
					grpInputs[curSelected].alpha = 1;
				}
				FlxG.sound.play(Paths.sound('scrollMenu'));
				rebindingKey = false;
				bindingTime = 0;
			}
		}

		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);
	}

	function getInputTextNum() {
		var num:Int = 0;
		for (i in 0...curSelected) {
			if(optionShit[i].length > 1) {
				num++;
			}
		}
		return num;
	}
	
	function changeSelection(change:Int = 0) {
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = optionShit.length - 1;
			if (curSelected >= optionShit.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var bullShit:Int = 0;

		for (i in 0...grpInputs.length) {
			grpInputs[i].alpha = 0.6;
		}
		for (i in 0...grpInputsAlt.length) {
			grpInputsAlt[i].alpha = 0.6;
		}

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
					if(curAlt) {
						for (i in 0...grpInputsAlt.length) {
							if(grpInputsAlt[i].sprTracker == item) {
								grpInputsAlt[i].alpha = 1;
								break;
							}
						}
					} else {
						for (i in 0...grpInputs.length) {
							if(grpInputs[i].sprTracker == item) {
								grpInputs[i].alpha = 1;
								break;
							}
						}
					}
				}
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	function changeAlt() {
		curAlt = !curAlt;
		for (i in 0...grpInputs.length) {
			if(grpInputs[i].sprTracker == grpOptions.members[curSelected]) {
				grpInputs[i].alpha = 0.6;
				if(!curAlt) {
					grpInputs[i].alpha = 1;
				}
				break;
			}
		}
		for (i in 0...grpInputsAlt.length) {
			if(grpInputsAlt[i].sprTracker == grpOptions.members[curSelected]) {
				grpInputsAlt[i].alpha = 0.6;
				if(curAlt) {
					grpInputsAlt[i].alpha = 1;
				}
				break;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	private function unselectableCheck(num:Int, ?checkDefaultKey:Bool = false):Bool {
		if(optionShit[num][0] == defaultKey) {
			return checkDefaultKey;
		}
		return optionShit[num].length < 2 && optionShit[num][0] != defaultKey;
	}

	private function addBindTexts(optionText:Alphabet, num:Int) {
		var keys:Array<Dynamic> = ClientPrefs.keyBinds.get(optionShit[num][1]);
		var text1 = new AttachedText(InputFormatter.getKeyName(keys[0]), 400, -55);
		text1.setPosition(optionText.x + 400, optionText.y - 55);
		text1.sprTracker = optionText;
		grpInputs.push(text1);
		add(text1);

		var text2 = new AttachedText(InputFormatter.getKeyName(keys[1]), 650, -55);
		text2.setPosition(optionText.x + 650, optionText.y - 55);
		text2.sprTracker = optionText;
		grpInputsAlt.push(text2);
		add(text2);
	}

	function reloadKeys() {
		while(grpInputs.length > 0) {
			var item:AttachedText = grpInputs[0];
			item.kill();
			grpInputs.remove(item);
			item.destroy();
		}
		while(grpInputsAlt.length > 0) {
			var item:AttachedText = grpInputsAlt[0];
			item.kill();
			grpInputsAlt.remove(item);
			item.destroy();
		}

		trace('Reloaded keys: ' + ClientPrefs.keyBinds);

		for (i in 0...grpOptions.length) {
			if(!unselectableCheck(i, true)) {
				addBindTexts(grpOptions.members[i], i);
			}
		}


		var bullShit:Int = 0;
		for (i in 0...grpInputs.length) {
			grpInputs[i].alpha = 0.6;
		}
		for (i in 0...grpInputsAlt.length) {
			grpInputsAlt[i].alpha = 0.6;
		}

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
					if(curAlt) {
						for (i in 0...grpInputsAlt.length) {
							if(grpInputsAlt[i].sprTracker == item) {
								grpInputsAlt[i].alpha = 1;
							}
						}
					} else {
						for (i in 0...grpInputs.length) {
							if(grpInputs[i].sprTracker == item) {
								grpInputs[i].alpha = 1;
							}
						}
					}
				}
			}
		}
	}
}