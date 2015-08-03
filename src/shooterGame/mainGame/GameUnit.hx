package shooterGame.mainGame;

/**
 * ...
 * @author Anthony Ganzon
 */
class GameUnit extends GameCollision
{

	private var life: Int;
	
	public function new() 
	{
		super();
	}
	
	public function subtractLife(life:Int = 1): Void {
		this.life -= life;
	}
	
	public function setLife(life: Int): Void {
		this.life = life;
	}
	
	public function getLife(): Int {
		return life;
	}
}