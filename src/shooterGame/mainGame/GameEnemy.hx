package shooterGame.mainGame;

import flambe.System;

/**
 * ...
 * @author Anthony Ganzon
 */
class GameEnemy extends GameUnit
{

	public function new() 
	{
		super();
	}
	
	override public function elementGameBounds() 
	{
		//super.elementGameBounds();
		if (this.x._ <= 0 || this.x._ >= System.stage.width ||
			this.y._ >= System.stage.height + 50) {
				this.owner.dispose();
				isDead = true;
		}
	}
	
	//override public function onRemoved() 
	//{
		////super.onRemoved();
	//}
	
	//override public function onUpdate(dt:Float) 
	//{
		//super.onUpdate(dt);
	//}
	
}