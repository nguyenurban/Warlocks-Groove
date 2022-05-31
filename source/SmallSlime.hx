import flixel.tile.FlxTilemap;

class SmallSlime extends Slime
{
	public function new(x:Float, y:Float, target:Player, tilemap:FlxTilemap)
	{
		super(x, y, target, tilemap);
		_size = 25;
		setSize(_size, _size);
		scale.set(_size / 25, _size / 25);
		BASE_SPEED = 40;
		updateHitbox();
		health = 25;
		_dps = 10;
		BASE_SPEED = 40;
		pellet_drop = 1;
		pd_25_combo = 1;
		pd_100_combo = 1;
	}
}
