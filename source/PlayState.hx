package;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	public static var GRID_OFFSET_X:Int = 25;
	public static var TOP_GRID_OFFSET_Y:Int = 25;
	public static var BOTTOM_GRID_OFFSET_Y:Int = 425;

	private var activeGrid:Grid;
	private var nextGrid:Grid;
	private var _game:Game;
	private var _hud:HUD;

	private var timeStart:Float;

	override public function create()
	{
		_game = new Game(Registry.GAME_WIDTH, Registry.GAME_HEIGHT);
		switchActiveId(0);
		timeStart = Date.now().getTime() / 1000;

		_hud = new HUD(Registry.TIME_LIMIT, 260, 50);
		add(_hud);

		super.create();
	}

    public function reset()
        {
            _game = new Game(Registry.GAME_WIDTH, Registry.GAME_HEIGHT);
            switchActiveId(0);
            timeStart = Date.now().getTime()/1000;
            super.create();
    }

	override public function update(elapsed:Float)
	{
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

		if (FlxG.keys.justPressed.DOWN)
		{
			incrementActiveId();
		}
		if (FlxG.keys.justPressed.UP)
		{
			decrementActiveId();
		}

		_hud.setScore(Registry.score);
		var timeElapsed:Float = Date.now().getTime()/1000 - timeStart;
		_hud.setTimeLeft(Registry.TIME_LIMIT - timeElapsed);
		if (timeElapsed > Registry.TIME_LIMIT) {
			FlxG.switchState(new EndState());
		}

		if (FlxG.keys.justPressed.R)
		{
			reset();
		}

		super.update(elapsed);
	}

	public function incrementActiveId()
	{
		var curId = _game.activeGrid;
		if (curId + 2 < _game.grids.length)
		{
			switchActiveId(curId + 1);
		}
	}

	public function decrementActiveId()
	{
		var curId = _game.activeGrid;
		if (curId - 1 >= 0)
		{
			switchActiveId(curId - 1);
		}
	}

	public function switchActiveId(gridId:Int)
	{
		if (activeGrid != null)
		{
			_game.detachGrids();
			remove(activeGrid);
			remove(nextGrid);
		}

		_game.activeGrid = gridId;
		activeGrid = Grid.fromGame(_game, GRID_OFFSET_X, TOP_GRID_OFFSET_Y, gridId);
		nextGrid = Grid.fromGame(_game, GRID_OFFSET_X, BOTTOM_GRID_OFFSET_Y, gridId + 1, 0.75);

		add(activeGrid);
		add(nextGrid);
	}
}
