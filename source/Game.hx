import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.system.FlxSound;
import haxe.ds.Vector;

class Game
{
	public var width:Int;
	public var height:Int;

	public static var rand:FlxRandom;

	public var activeGrid:Int = 0;
	public var grids:Array<GameGrid>;

	public var currentPath:Array<Int>;

	private var _selectSound:FlxSound;
	private var _clearSound:FlxSound;
	private var _failureSound:FlxSound;

	public function new(width:Int, height:Int)
	{
		rand = new FlxRandom(Std.int(Date.now().getTime() / 1000));

		this.width = width;
		this.height = height;

		grids = new Array<GameGrid>();

		// start with 3 grids
		grids.push(new GameGrid(width, height));
		grids.push(new GameGrid(width, height));
		grids.push(new GameGrid(width, height));

		grids[0].randomizeTiles();
		grids[0].activated = true;
		grids[0].isRegenerating = Registry.REGENERATE_TILES;

		_selectSound = FlxG.sound.load(AssetPaths.select__wav, 0.3);
		_clearSound = FlxG.sound.load(AssetPaths.clear__wav, 0.5);
		_failureSound = FlxG.sound.load(AssetPaths.failure__wav, 0.5);

		currentPath = new Array<Int>();
	}

	public static function randomTile():Int
	{
		return rand.int(1, Registry.NUM_COLORS);
	}

	public function getTile(x:Int, y:Int, gridId:Int):Int
	{
		var grid = grids[gridId];
		return grid.tiles[grid.getSquare(x, y)];
	}

	public function doMove(squares:Array<Int>, gridId:Int):Bool
	{
		if (gridId < 0 || gridId >= grids.length)
			return false;

		var curGrid = grids[gridId];
		var L = squares.length;

		for (square in squares)
		{
			if (curGrid.tiles[square] == 0)
				return false;
		}

		// note: only supports moving a single tile right now
		var moveTile:Int;
		var recolorTiles:Array<Int>;
		var recolorOffsets:Array<Int>;

		switch (Registry.GAME_RULE)
		{
			case Registry.GameRule.SANDWICH:
				if (L != 3)
					return false;

				if (curGrid.tiles[squares[0]] != curGrid.tiles[squares[2]])
				{
					return false;
				}

				recolorTiles = [squares[0], squares[2]];
				recolorOffsets = [-1, 1];
				moveTile = squares[1];
			case Registry.GameRule.PALINDROME:
				if (L != 5)
					return false;

				if (curGrid.tiles[squares[0]] != curGrid.tiles[squares[4]])
				{
					return false;
				}

				if (curGrid.tiles[squares[1]] != curGrid.tiles[squares[3]])
				{
					return false;
				}

				recolorTiles = [squares[0], squares[1], squares[3], squares[4]];
				recolorOffsets = [-1, -1, 1, 1];
				moveTile = squares[2];
			default:
				trace("Unknown rule");
				return false;
		}
<<<<<<< HEAD
        _clearSound.play(true);
=======
		_clearSound.play();
>>>>>>> d8e64f1b9ae987ddf582fd392095b2bf63966fd9
		// passed checks
		Registry.score += Std.int(Math.pow(3, gridId));
		var deletedTile = curGrid.tiles[moveTile];

		for (i in (0...recolorTiles.length))
		{
			var square = recolorTiles[i];
			var offset = recolorOffsets[i];
			curGrid.cycleTile(square, offset);
		}
		curGrid.setTile(moveTile, 0);

		curGrid.doGravity();

		// move tiles to next grid
		if (gridId + 1 < grids.length)
		{
			var nxtGrid = grids[gridId + 1];
			var nxtSquare = nxtGrid.moveToTop(moveTile);

			if (!nxtGrid.activated)
			{
				grids.push(new GameGrid(width, height));
				nxtGrid.activated = true;
			}

			if (nxtGrid.tiles[nxtSquare] == 0)
			{
				nxtGrid.setTile(nxtSquare, deletedTile);
				nxtGrid.doGravity();
			}
		}

		return true;
	}

	public function hoverOnTile(square:Int):Void
	{
		// Don't do anything if the square is empty.
		if (grids[activeGrid].tiles[square] == 0)
			return;
		// If the path is empty, start it.
		if (currentPath.length == 0)
		{
			addTileToPath(square);
			return;
		}
		// "Undo" if you revisit the square before the end.
		if (currentPath.length >= 2 && square == currentPath[currentPath.length - 2])
		{
			deleteTileFromPath(currentPath[currentPath.length - 1]);
			return;
		}
		// Check that the square already isn't in the path and is adjacent to the last one.
		if (currentPath.indexOf(square) != -1)
			return;
		if (!grids[activeGrid].isAdjacent(square, currentPath[currentPath.length - 1]))
			return;
		addTileToPath(square);
	}

	public function submitPath():Void
	{
<<<<<<< HEAD
		if(!doMove(currentPath, activeGrid)){
            _failureSound.play(true);
        }
=======
		if (!doMove(currentPath, activeGrid))
		{
			_failureSound.play();
		}
>>>>>>> d8e64f1b9ae987ddf582fd392095b2bf63966fd9
		clearPath();
	}

	public function addTileToPath(square:Int):Void
	{
		currentPath.push(square);
		grids[activeGrid].attachedGrid.setTileHighlight(square, true);
<<<<<<< HEAD
        _selectSound.play(true);
=======
		_selectSound.play();
>>>>>>> d8e64f1b9ae987ddf582fd392095b2bf63966fd9
	}

	public function deleteTileFromPath(square:Int):Void
	{
		currentPath.remove(square);
		grids[activeGrid].attachedGrid.setTileHighlight(square, false);
	}

	public function clearPath():Void
	{
		for (square in currentPath)
		{
			grids[activeGrid].attachedGrid.setTileHighlight(square, false);
		}
		currentPath.resize(0);
	}

	public function detachGrids()
	{
		grids[activeGrid].attachedGrid = null;

		if (activeGrid + 1 < grids.length)
			grids[activeGrid + 1].attachedGrid = null;
	}
}
