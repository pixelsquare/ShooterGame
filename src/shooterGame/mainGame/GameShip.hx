package shooterGame.mainGame;

import flambe.Entity;
import flambe.input.PointerEvent;
import flambe.math.FMath;
import flambe.System;


/**
 * ...
 * @author Anthony Ganzon
 */
class GameShip extends GameUnit
{
	public var shipBullets(default, null): Array<GameBullet>;
	private var canMove: Bool;
	
	public function new() 
	{
		super();
		shipBullets = new Array<GameBullet>();
	}
	
	public function fireBullet(): Void {
		spawnBullet();
	}
	
	public function spawnBullet(): Void {
		var bullet: GameBullet = new GameBullet(this.x._, this.y._ - 50);
		bullet.centerAnchor();
		shipBullets.push(bullet);
		this.owner.parent.addChild(new Entity().add(bullet));
	}
	
	public function removeBullet(bullet: GameBullet): Void {
		shipBullets.remove(bullet);
	}
	
	public function onMouseMove(event: PointerEvent): Void {
		canMove = true;
	}
	
	public function clearShipBullets(): Void {
		shipBullets = new Array<GameBullet>();
	}
	
	override public function onUpdate(dt:Float) 
	{	
		if (!canMove) return;
		
		this.x._ = System.pointer.x;
		this.x._ = FMath.clamp(this.x._, getNaturalWidth() / 2, System.stage.width - (getNaturalWidth() / 2));
		
		canMove = false;
	}
	
}