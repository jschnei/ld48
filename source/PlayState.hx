package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxTween;

class PlayState extends FlxState
{
	public static var GRID_OFFSET_X:Int = 25;
	public static var TOP_GRID_OFFSET_Y:Int = 25;
	public static var MIDDLE_GRID_OFFSET_Y:Int = 350;
	public static var BOTTOM_GRID_OFFSET_Y:Int = 600;

	private var activeGrid:Grid;
	private var nextGrid:Grid;
	private var next2Grid:Grid;
	private var _game:Game;
	private var _hud:HUD;
	private var _background:FlxBackdrop;

	public var paused:Bool = false;

	private var timeStart:Float;

	override public function create()
	{
		_background = new FlxBackdrop(AssetPaths.bg__png);
		add(_background);

		reset();

		_hud = new HUD(Registry.TIME_LIMIT, 260, 50);
		add(_hud);

		super.create();
	}

	public function reset()
	{
		Registry.score = 0;
		_game = new Game(Registry.GAME_WIDTH, Registry.GAME_HEIGHT);
		switchActiveId(0);
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

		if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S)
		{
			incrementActiveId();
		}
		if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W)
		{
			decrementActiveId();
		}

		_hud.setScore(Registry.score);
		var timeElapsed:Float = Date.now().getTime() / 1000 - timeStart;
		_hud.setTimeLeft(Registry.TIME_LIMIT - timeElapsed);
		if (timeElapsed > Registry.TIME_LIMIT)
		{
			FlxG.switchState(new EndState());
		}

		if (FlxG.keys.justPressed.R)
		{
			reset();
		}

        if(FlxG.keys.justPressed.A)
        {
            Registry.accessible = !Registry.accessible;
            _game.refreshTiles();
        }

		super.update(elapsed);
	}

	public function incrementActiveId()
	{
		var curId = _game.activeGrid;
		if (curId + 3 < _game.grids.length)
		{
			paused = true;
			FlxTween.tween(activeGrid, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					switchActiveId(curId + 1);
				}
			});

			nextGrid.tweenToGrid(activeGrid);
			next2Grid.tweenToGrid(nextGrid);
		}
	}

	public function decrementActiveId()
	{
		var curId = _game.activeGrid;
		if (curId - 1 >= 0)
		{
			paused = true;
			FlxTween.tween(next2Grid, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					switchActiveId(curId - 1);
				}
			});

			activeGrid.tweenToGrid(nextGrid);
			nextGrid.tweenToGrid(next2Grid);
		}
	}

	public function switchActiveId(gridId:Int)
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
		nextGrid = Grid.fromGame(_game, GRID_OFFSET_X, MIDDLE_GRID_OFFSET_Y, gridId + 1, 0.75);
		next2Grid = Grid.fromGame(_game, GRID_OFFSET_X, BOTTOM_GRID_OFFSET_Y, gridId + 2, 0.5);

		add(activeGrid);
		add(nextGrid);
		add(next2Grid);

		paused = false;
	}
}
