package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class GridTile extends FlxSprite
{
	public var grid:Grid;
	public var gridX:Int;
	public var gridY:Int;

	public function new(grid:Grid, gridX:Int, gridY:Int)
	{
		this.grid = grid;
		this.gridX = gridX;
		this.gridY = gridY;

		var X = grid.x + Grid.CELL_WIDTH * gridX;
		var Y = grid.y + Grid.CELL_HEIGHT * gridY;

		makeGraphic(Grid.CELL_WIDTH, Grid.CELL_HEIGHT, FlxColor.GRAY);

		super(X, Y);
	}
}
