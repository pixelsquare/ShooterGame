package shooterGame.mainGame;

import flambe.System;

/**
 * ...
 * @author Anthony Ganzon
 */
class GameEnemy extends GameUnit
{

	private var constraintOffset: Int = 50;
	
	public function new() 
	{
		super();
	}
	
	override public function elementScreenConstraint(): Void
	{
		if (this.x._ <= 0 || this.x._ >= System.stage.width ||
			this.y._ >= System.stage.height + constraintOffset) {
				this.owner.dispose();
				elementIsDead = true;
		}
	}	
}