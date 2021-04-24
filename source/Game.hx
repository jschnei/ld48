import flixel.math.FlxRandom;
import haxe.ds.Vector;

class Game
{
	public var width:Int;
	public var height:Int;

	public static var numColors:Int = 5;
	public static var rand:FlxRandom;

	public var grids:Array<GameGrid>;

	public function new(width:Int, height:Int)
	{
		rand = new FlxRandom(Std.int(Date.now().getTime() / 1000));

		this.width = width;
		this.height = height;

		grids = new Array<GameGrid>();
		grids.push(new GameGrid(width, height));
	}

	public static function randomTile():Int
	{
		return rand.int(1, numColors);
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

		if (!curGrid.isAdjacent(squares[0], squares[1]))
			return false;
		if (!curGrid.isAdjacent(squares[1], squares[2]))
			return false;

		if (squares[0] == squares[2])
			return false;

		for (square in squares)
		{
			if (curGrid.tiles[square] == 0)
				return false;
		}

		// passed checks
		curGrid.tiles[squares[1]] = 0;
		curGrid.tiles[squares[0]] = randomTile();
		curGrid.tiles[squares[2]] = randomTile();

		// move tiles to next grid
		// TODO

		return true;
	}
}
