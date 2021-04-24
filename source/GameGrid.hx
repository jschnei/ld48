import flixel.math.FlxRandom;
import haxe.ds.Vector;

class GameGrid
{
	// 0 = empty square
	// positive numbers are colors
	public var tiles:Vector<Int>;

	public var width:Int;
	public var height:Int;

	public var attachedGrid:Grid;
	public var activated:Bool = false;

	// whether the grid regenerates new blocks from the top
	public var isRegenerating:Bool = false;

	public function new(width:Int, height:Int)
	{
		this.width = width;
		this.height = height;

		tiles = new Vector<Int>(width * height);
		for (i in 0...(width * height))
		{
			tiles[i] = 0;
		}
	}

	public function randomizeTiles()
	{
		for (i in 0...(width * height))
		{
			tiles[i] = Game.randomTile();
		}
	}

	public function getSquare(x:Int, y:Int):Int
	{
		return y * width + x;
	}

	public function moveToTop(square:Int)
	{
		while (square >= width)
		{
			square -= width;
		}
		return square;
	}

	public function getTile(x:Int, y:Int):Int
	{
		return tiles[getSquare(x, y)];
	}

	public function setTile(square:Int, value:Int)
	{
		var oldValue = tiles[square];
		tiles[square] = value;

		if (attachedGrid != null)
		{
			if (oldValue != 0 && value == 0)
			{
				// delete tile
				attachedGrid.deleteTile(square);
			}
			else if (oldValue != 0 && value != 0)
			{
				// change color
				attachedGrid.changeColor(square, value);
			}
			else if (oldValue == 0 && value != 0)
			{
				// createTile
				attachedGrid.createTile(square, value);
			}
		}
	}

	public function isAdjacent(square1:Int, square2:Int)
	{
		var x1 = square1 % width;
		var y1 = Std.int(square1 / width);

		var x2 = square2 % width;
		var y2 = Std.int(square2 / width);

		var dx = x1 - x2;
		if (dx < 0)
			dx *= -1;
		var dy = y1 - y2;
		if (dy < 0)
			dy *= -1;
		return (dx + dy == 1);
	}

	public function doGravity()
	{
		for (i in 0...width)
		{
			doGravityForColumn(i);
		}
	}

	public function doGravityForColumn(column:Int)
	{
		var readRow = height - 1;
		var row = height - 1;
		while (readRow >= 0)
		{
			while (readRow >= 0 && getTile(column, readRow) == 0)
			{
				readRow--;
			}
			var tile = getTile(column, readRow);
			if (tile > 0)
			{
				setTile(getSquare(column, row), getTile(column, readRow));
				row--;
				readRow--;
			}
		}
		while (row >= 0)
		{
			var tile = 0;
			if (isRegenerating)
			{
				tile = Game.randomTile();
			}
			setTile(getSquare(column, row), tile);
			row--;
		}
	}
}
