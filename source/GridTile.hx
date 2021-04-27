package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class GridTile extends FlxSpriteGroup
{
	public var tileColors:Array<String> = [
		AssetPaths.grey__png, // not used
		AssetPaths.red__png,
		AssetPaths.orange__png,
		AssetPaths.yellow__png,
		AssetPaths.green__png,
		AssetPaths.blue__png,
		AssetPaths.purple__png,
	];

	public var accessibleTiles:Array<String> = [
		AssetPaths.grey__png, // not used
		AssetPaths.reda__png,
		AssetPaths.orangea__png,
		AssetPaths.yellowa__png,
		AssetPaths.greena__png,
		AssetPaths.bluea__png,
		AssetPaths.purplea__png,
	];

	public var grid:Grid;
	public var gridX:Int;
	public var gridY:Int;
	public var colorId:Int;

	private var _tileSprite:FlxSprite;
	// Used when changing color.
	private var _nextTileSprite:FlxSprite;

	public function new(grid:Grid, gridX:Int, gridY:Int, colorId:Int)
	{
		this.grid = grid;
		this.gridX = gridX;
		this.gridY = gridY;
		this.colorId = colorId;

		var X = grid.cellWidth * gridX;
		var Y = grid.cellHeight * gridY;

		super(X, Y);
		_tileSprite = new FlxSprite();
		if (Registry.accessible)
		{
			_tileSprite.loadGraphic(accessibleTiles[colorId], false, Grid.CELL_WIDTH, Grid.CELL_HEIGHT);
		}
		else
		{
			_tileSprite.loadGraphic(tileColors[colorId], false, Grid.CELL_WIDTH, Grid.CELL_HEIGHT);
		}
		add(_tileSprite);
		scale.set(grid.gridScale, grid.gridScale);
		_nextTileSprite = new FlxSprite();
		if (Registry.accessible)
		{
			_nextTileSprite.loadGraphic(accessibleTiles[colorId], false, Grid.CELL_WIDTH, Grid.CELL_HEIGHT);
		}
		else
		{
			_nextTileSprite.loadGraphic(tileColors[colorId], false, Grid.CELL_WIDTH, Grid.CELL_HEIGHT);
		}
		_nextTileSprite.alpha = 0;
		add(_nextTileSprite);

		// hacky method of reorienting point since setting origin doesn't seem to work

		x = X - (1 - grid.gridScale) * width / 2;
		y = Y - (1 - grid.gridScale) * height / 2;
	}

	public function changeColorTo(colorId:Int)
	{
		if (this.colorId == colorId)
			return;
		this.colorId = colorId;
		if (Registry.accessible)
		{
			_nextTileSprite.loadGraphic(accessibleTiles[colorId], false, Grid.CELL_WIDTH, Grid.CELL_HEIGHT);
		}
		else
		{
			_nextTileSprite.loadGraphic(tileColors[colorId], false, Grid.CELL_WIDTH, Grid.CELL_HEIGHT);
		}
		_nextTileSprite.alpha = 0;
		FlxTween.tween(_tileSprite, {alpha: 0}, 0.1);
		FlxTween.tween(_nextTileSprite, {alpha: 1}, 0.1, {onComplete: finishChangeColor});
	}

	public function finishChangeColor(tween:FlxTween)
	{
		_tileSprite = _nextTileSprite;
	}

	public function setHighlighted(highlighted:Bool)
	{
		_nextTileSprite.alpha = 0;
		if (highlighted)
		{
			_tileSprite.alpha = 0.7;
		}
		else
		{
			_tileSprite.alpha = 1.0;
		}
	}

	public function refresh()
	{
		if (Registry.accessible)
		{
			_tileSprite.loadGraphic(accessibleTiles[colorId], false, Grid.CELL_WIDTH, Grid.CELL_HEIGHT);
            _nextTileSprite.loadGraphic(accessibleTiles[colorId], false, Grid.CELL_WIDTH, Grid.CELL_HEIGHT);
		}
		else
		{
			_tileSprite.loadGraphic(tileColors[colorId], false, Grid.CELL_WIDTH, Grid.CELL_HEIGHT);
            _nextTileSprite.loadGraphic(tileColors[colorId], false, Grid.CELL_WIDTH, Grid.CELL_HEIGHT);
		}
	}
}
