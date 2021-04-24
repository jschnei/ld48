import flixel.math.FlxRandom;
import haxe.ds.Vector;

class Game
{
	// 0 = empty square
	// positive numbers are colors
	public var tiles:Vector<Int>;

	public var width:Int;
	public var height:Int;
	public var numColors:Int = 5;

	public var rand:FlxRandom;

	public function new(width:Int, height:Int)
	{
		rand = new FlxRandom(Std.int(Date.now().getTime() / 1000));

		this.width = width;
		this.height = height;

		tiles = new Vector<Int>(width * height);

		for (i in 0...(width * height))
		{
			tiles[i] = randomTile();
		}
	}

	public function randomTile():Int
	{
		return rand.int(1, numColors);
	}

	public function getSquare(x:Int, y:Int):Int
	{
		return y * width + x;
	}

	public function getTile(x:Int, y:Int):Int
	{
		return tiles[getSquare(x, y)];
	}

	public function isAdjacent(square1:Int, square2:Int)
	{
		var x1 = square1 % width;
		var y1 = square1 / width;

		var x2 = square2 % width;
		var y2 = square2 / width;

		var dx = x1 - x2;
		if (dx < 0)
			dx *= -1;
		var dy = y1 - y2;
		if (dy < 0)
			dy *= -1;

		return (dx + dy == 1);
	}

	public function doMove(squares:Array<Int>):Bool
	{
		var L = squares.length;

		if (L != 3)
			return false;

		if (!isAdjacent(squares[0], squares[1]))
			return false;
		if (!isAdjacent(squares[1], squares[2]))
			return false;

		if (squares[0] == squares[2])
			return false;

		if (tiles[squares[0]] == 0 || tiles[squares[1]] == 0 || tiles[squares[2]] == 0)
		{
			return false;
		}

		// passed checks
		tiles[squares[1]] = 0;
		tiles[squares[0]] = randomTile();
		tiles[squares[2]] = randomTile();

		return true;
	}
}
