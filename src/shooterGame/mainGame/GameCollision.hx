package shooterGame.mainGame;

import flambe.animation.AnimatedFloat;
import flambe.display.Graphics;
import flambe.display.Texture;
import flambe.math.Point;

import shooterGame.mainGame.GameElement;
import shooterGame.utils.pxlSq.Utils;

/**
 * ...
 * @author ...
 */
class GameCollision extends GameElement
{	
	public var bounds: Point;
	
	public function new() 
	{
		super();
		setColliderSize(new Point(this.getNaturalWidth() / 2, this.getNaturalHeight() / 2));
	}
	
	public function setColliderSize(size: Point) {
		bounds = size;
	}
	
	public function hasCollidedWith(other: GameCollision): Bool {
		var xHasNotCollided: Bool =
		this.x._ - this.bounds.x >
		other.x._ + other.bounds.x ||
		this.x._ + this.bounds.x <
		other.x._ - other.bounds.x;
		
		var yHasNotCollided: Bool =
		this.y._ - this.bounds.y >
		other.y._ + other.bounds.y ||
		this.y._ + this.bounds.y <
		other.y._ - other.bounds.y;
		
		if (xHasNotCollided || yHasNotCollided)
			return false;
		
		return true;
	}
	
}