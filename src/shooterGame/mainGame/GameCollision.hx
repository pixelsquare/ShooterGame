package shooterGame.mainGame;

import flambe.display.Texture;
import flambe.math.Point;
import shooterGame.mainGame.GameElement;


/**
 * ...
 * @author Anthony Ganzon
 */
class GameCollision extends GameElement
{	
	private var bounds: Point;
	
	public function new() 
	{
		super();
		setColliderSize(new Point(this.getNaturalWidth() / 2, this.getNaturalHeight() / 2));
	}
	
	override public function setTexture(texture:Texture):Void 
	{
		super.setTexture(texture);
		setColliderSize(new Point(this.getNaturalWidth() / 2, this.getNaturalHeight() / 2));
	}
	
	public function setColliderSize(size: Point): Void {
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
	
	public function getBounds(): Point {
		return bounds;
	}
	
}