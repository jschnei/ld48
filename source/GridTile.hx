package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class GridTile extends FlxSprite
{
	public var tileColors:Array<String> = [
		AssetPaths.grey__png, // no color
		AssetPaths.red__png,
		AssetPaths.orange__png,
		AssetPaths.yellow__png,
		AssetPaths.green__png,
		AssetPaths.blue__png
	];

	public var grid:Grid;
	public var gridX:Int;
	public var gridY:Int;

	public function new(grid:Grid, gridX:Int, gridY:Int, colorId:Int)
	{
		this.grid = grid;
		this.gridX = gridX;
		this.gridY = gridY;

		var X = Grid.CELL_WIDTH * gridX;
		var Y = Grid.CELL_HEIGHT * gridY;

		super(X, Y);
		loadGraphic(tileColors[colorId], false, Grid.CELL_WIDTH, Grid.CELL_HEIGHT);
	}

	public function changeColorTo(colorId:Int)
	{
		loadGraphic(tileColors[colorId], false, Grid.CELL_WIDTH, Grid.CELL_HEIGHT);
	}

	public function setHighlighted(highlighted:Bool) {
		if (highlighted) {
			this.alpha = 0.7;
		} else {
			this.alpha = 1.0;
		}
	}
}
