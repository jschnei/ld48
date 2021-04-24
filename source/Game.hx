import flixel.math.FlxRandom;
import haxe.ds.Vector;

class Game
{
	public var width:Int;
	public var height:Int;

	public static var rand:FlxRandom;

	public var activeGrid:Int = 0;
	public var grids:Array<GameGrid>;

	public var currentPath:Array<Int>;

	public function new(width:Int, height:Int)
	{
		rand = new FlxRandom(Std.int(Date.now().getTime() / 1000));

		this.width = width;
		this.height = height;

		grids = new Array<GameGrid>();
		// start with 2 grids
		grids.push(new GameGrid(width, height));
		grids.push(new GameGrid(width, height));

		grids[0].randomizeTiles();
		grids[0].activated = true;
		grids[0].isRegenerating = Registry.REGENERATE_TILES;

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

		if (L != 3)
			return false;

		for (square in squares)
		{
			if (curGrid.tiles[square] == 0)
				return false;
		}

		if (curGrid.tiles[squares[0]] != curGrid.tiles[squares[2]])
		{
			return false;
		}

		// passed checks
		Registry.score += Std.int(Math.pow(3, gridId));
		var deletedTile = curGrid.tiles[squares[1]];

		curGrid.setTile(squares[1], 0);
		curGrid.setTile(squares[0], randomTile());
		curGrid.setTile(squares[2], randomTile());
		curGrid.doGravity();

		// move tiles to next grid
		if (gridId + 1 < grids.length)
		{
			var nxtGrid = grids[gridId + 1];
			var nxtSquare = nxtGrid.moveToTop(squares[1]);

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
		if (currentPath.length == 0)
		{
			addTileToPath(square);
			return;
		}
		// Allow "undo"
		if (square == currentPath[currentPath.length - 2])
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
		doMove(currentPath, activeGrid);
		clearPath();
	}

	public function addTileToPath(square:Int):Void
	{
		currentPath.push(square);
		grids[activeGrid].attachedGrid.setTileHighlight(square, true);
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
