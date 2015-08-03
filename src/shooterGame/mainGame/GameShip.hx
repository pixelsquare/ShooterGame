package shooterGame.mainGame;

import flambe.Entity;
import flambe.System;
import flambe.math.FMath;
import flambe.util.SignalConnection;
import shooterGame.utils.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class GameShip extends GameUnit
{
	private var gameBullet: Array<GameBullet>;
	
	public function new() 
	{
		super();
		gameBullet = new Array<GameBullet>();
	}
	
	public function FireBullet(): Void {
		SpawnBullet();
	}
	
	public function SpawnBullet(): Void {
		var bullet: GameBullet = new GameBullet(this.x._, this.y._);
		bullet.centerAnchor();
		gameBullet.push(bullet);
		this.owner.parent.addChild(new Entity().add(bullet));
	}
	
	override public function onAdded() 
	{
		 super.onAdded();
	}
	
	override public function onRemoved() 
	{
		super.onRemoved();
	}
	
	override public function onUpdate(dt:Float) 
	{	
		this.x._ = System.pointer.x;
		this.x._ = FMath.clamp(this.x._, getNaturalWidth() / 2, System.stage.width - (getNaturalWidth() / 2));
	}
	
}