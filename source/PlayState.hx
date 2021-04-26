package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
// import haxe.ds.Vector;

class PlayState extends FlxState
{
	public static var GRID_OFFSET_X:Int = 25;
	public static var TOP_GRID_OFFSET_Y:Int = 25;
	public static var UP_TMP_GRID_OFFSET_Y:Int = -400;
	public static var DOWN_TMP_GRID_OFFSET_Y:Int = 850;
	public static var GRID_GAP_Y:Int = 10;
	public static var UP_TMP_GRID_SCALE:Float = 1.25;
	public static var MID_GRID_SCALE:Float = 0.75;
	public static var BOT_GRID_SCALE:Float = 0.5;
	public static var DOWN_TMP_GRID_SCALE:Float = 0.25;

	public static var FADE_IN_DURATION:Float = 0.5;
	public static var SCROLL_DURATION:Float = 0.2;

	private static var NUM_WINDOW_SCROLLS = 8;
	private static var DEEPER_BACKGROUND_HEIGHT = 900;

	private var activeGrid:Grid;
	private var nextGrid:Grid;
	private var next2Grid:Grid;
	private var _game:Game;
	private var _hud:HUD;
	private var _background:FlxSprite;
	private var _deeperBackgrounds:FlxSpriteGroup;

	public var paused:Bool = true;

	private var timeStart:Float;

	private var _shiftDownSound:FlxSound;
	private var _shiftUpSound:FlxSound;
	private var _failureSound:FlxSound;

	override public function create()
	{
		_background = new FlxSprite();
		_background.loadGraphic(AssetPaths.bigbackground__png, true, Registry.WINDOW_WIDTH, Registry.WINDOW_HEIGHT * NUM_WINDOW_SCROLLS);
		_background.animation.add("flicker", [0, 1], 1, true);
		_background.animation.play("flicker");
		_background.y = -Registry.BACKGROUND_STARTING_HEIGHT;
		add(_background);

		_deeperBackgrounds = new FlxSpriteGroup();

		reset(true);

		_hud = new HUD(Registry.TIME_LIMIT, this, 260, 20);
		add(_hud);
		_hud.fadeIn(FADE_IN_DURATION);

		_shiftDownSound = FlxG.sound.load(AssetPaths.shiftdown__wav, 0.3);
		_shiftUpSound = FlxG.sound.load(AssetPaths.shiftup__wav, 0.3);
		_failureSound = FlxG.sound.load(AssetPaths.shiftfailure__wav, 0.2);

		super.create();
	}

	public function reset(?init:Bool = false)
	{
		Registry.score = 0;
		_game = new Game(Registry.GAME_WIDTH, Registry.GAME_HEIGHT);
		switchActiveId(0, init);
		timeStart = Date.now().getTime() / 1000;
	}

	override public function update(elapsed:Float)
	{
		if (paused)
			return;

		if (FlxG.mouse.pressed)
		{
			var hoveringTile = activeGrid.getSquare(FlxG.mouse.x, FlxG.mouse.y);
			if (hoveringTile != -1)
			{
				_game.hoverOnTile(hoveringTile);
			}
		}
		if (FlxG.mouse.justReleased)
		{
			_game.submitPath();
		}

		// trace(FlxG.mouse.wheel);

		if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S || FlxG.mouse.wheel < 0)
		{
			incrementActiveId();
		}
		if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W || FlxG.mouse.wheel > 0)
		{
			decrementActiveId();
		}

		_hud.setScore(Registry.score);
		if (Registry.TIME_ON)
		{
			updateTime();
		}

		if (FlxG.keys.justPressed.R)
		{
			reset();
		}

		if (FlxG.keys.justPressed.A)
		{
			Registry.accessible = !Registry.accessible;
			_game.refreshTiles();
		}

		super.update(elapsed);
	}

	public function endGame()
	{
		FlxG.switchState(new EndState());
	}

	public function updateTime()
	{
		var timeElapsed:Float = Date.now().getTime() / 1000 - timeStart;
		_hud.setTimeLeft(Registry.TIME_LIMIT - timeElapsed);
		if (timeElapsed > Registry.TIME_LIMIT)
		{
			endGame();
		}
	}

	public function incrementActiveId()
	{
		var curId = _game.activeGrid;
		if (curId + 3 < _game.grids.length)
		{
			_shiftDownSound.play();
			paused = true;

			FlxTween.tween(_background, {
				y: _background.y - Registry.SCROLL_HEIGHT
			}, SCROLL_DURATION);

			if (curId >= NUM_WINDOW_SCROLLS-2)
			{
				var numBackgrounds = _deeperBackgrounds.length;
				if (numBackgrounds == 0 || _deeperBackgrounds.members[numBackgrounds-1].y < Registry.WINDOW_HEIGHT) {
					var newBackground = new FlxSprite();
					newBackground.loadGraphic(
						AssetPaths.deeperBackground__png,
						true,
						Registry.WINDOW_WIDTH,
						DEEPER_BACKGROUND_HEIGHT);
					newBackground.animation.add("flicker", [0, 1], 1, true);
					newBackground.animation.play("flicker");
					newBackground.y = Registry.WINDOW_HEIGHT;
					add(newBackground);
					_deeperBackgrounds.add(newBackground);
				}
			}
			for (sprite in _deeperBackgrounds)
			{
				FlxTween.tween(sprite, {
					y: sprite.y - Registry.SCROLL_HEIGHT
				}, SCROLL_DURATION);
			}
			
			var tempUpGrid = Grid.fromGame(_game, GRID_OFFSET_X, UP_TMP_GRID_OFFSET_Y, curId + 3, UP_TMP_GRID_SCALE, false);
			tempUpGrid.alpha = 0;

			var tempDownGrid = Grid.fromGame(_game, GRID_OFFSET_X, DOWN_TMP_GRID_OFFSET_Y, curId + 3, DOWN_TMP_GRID_SCALE, false);
			tempDownGrid.alpha = 0;
			add(tempDownGrid);

			activeGrid.tweenToGrid(tempUpGrid, function(tween:FlxTween)
			{
				switchActiveId(curId + 1);
			});
			nextGrid.tweenToGrid(activeGrid);
			next2Grid.tweenToGrid(nextGrid);
			tempDownGrid.tweenToGrid(next2Grid, function(tween:FlxTween)
			{
				remove(tempDownGrid);
			});
		}
		else
		{
			_failureSound.play();
		}
	}

	public function decrementActiveId()
	{
		var curId = _game.activeGrid;
		if (curId - 1 >= 0)
		{
			_shiftUpSound.play();
			paused = true;

			FlxTween.tween(_background, {
				y: _background.y + Registry.SCROLL_HEIGHT
			}, SCROLL_DURATION);
			for (sprite in _deeperBackgrounds)
			{
				FlxTween.tween(sprite, {
					y: sprite.y + Registry.SCROLL_HEIGHT
				}, SCROLL_DURATION);
			}

			var tempUpGrid = Grid.fromGame(_game, GRID_OFFSET_X, UP_TMP_GRID_OFFSET_Y, curId - 1, 1.25, false);
			tempUpGrid.alpha = 0;
			add(tempUpGrid);

			var tempDownGrid = Grid.fromGame(_game, GRID_OFFSET_X, DOWN_TMP_GRID_OFFSET_Y, curId - 1, 0.4, false);
			tempDownGrid.alpha = 0;

			next2Grid.tweenToGrid(tempDownGrid, function(tween:FlxTween)
			{
				switchActiveId(curId - 1);
			});

			tempUpGrid.tweenToGrid(activeGrid, function(tween:FlxTween)
			{
				remove(tempUpGrid);
			});

			activeGrid.tweenToGrid(nextGrid);
			nextGrid.tweenToGrid(next2Grid);
		}
		else
		{
			_failureSound.play();
		}
	}

	public function switchActiveId(gridId:Int, ?init:Bool = false)
	{
		if (activeGrid != null)
		{
			_game.detachGrids();
			remove(activeGrid);
			remove(nextGrid);
			remove(next2Grid);
		}

		_game.activeGrid = gridId;
		activeGrid = Grid.fromGame(_game, GRID_OFFSET_X, TOP_GRID_OFFSET_Y, gridId);
		var midGridOffsetY = TOP_GRID_OFFSET_Y + activeGrid.gridPixHeight + GRID_GAP_Y;
		nextGrid = Grid.fromGame(_game, GRID_OFFSET_X, midGridOffsetY, gridId + 1, MID_GRID_SCALE);
		var botGridOffsetY = midGridOffsetY + nextGrid.gridPixHeight + GRID_GAP_Y;
		next2Grid = Grid.fromGame(_game, GRID_OFFSET_X, botGridOffsetY, gridId + 2, BOT_GRID_SCALE);

		add(activeGrid);
		add(nextGrid);
		add(next2Grid);

		if (init)
		{
			activeGrid.alpha = 0;
			nextGrid.alpha = 0;
			next2Grid.alpha = 0;

			FlxTween.tween(activeGrid, {alpha: 1}, FADE_IN_DURATION, {
				onComplete: function(tween:FlxTween)
				{
					paused = false;
				}
			});
			FlxTween.tween(nextGrid, {alpha: 1}, FADE_IN_DURATION);
			FlxTween.tween(next2Grid, {alpha: 1}, FADE_IN_DURATION);
		}
		else
		{
			paused = false;
		}
	}
}
