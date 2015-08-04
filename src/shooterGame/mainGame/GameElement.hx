package shooterGame.mainGame;

import flambe.display.Graphics;
import flambe.display.Sprite;
import flambe.display.Texture;
import flambe.System;

/**
 * ...
 * @author Anthony Ganzon
 */
class GameElement extends Sprite
{
	private var elementTexture: Texture;
	private var elementIsDead: Bool;
	
	private static inline var SCREEN_OFFSET: Int = 50;
	
	public function new() 
	{
		super();
		elementTexture = null;
		elementIsDead = false;
	}
	
	public function setTexture(texture: Texture): Void {
		elementTexture = texture;
	}
	
	public function isDead(): Bool {
		return elementIsDead;
	}
	
	public function elementScreenConstraint(): Void {
		// Remove the element when is out of the screen bounds
		if (this.x._ <= 0 || this.x._ >= System.stage.width + getNaturalWidth() ||
			this.y._ <= 0 || this.y._ >= System.stage.height + getNaturalHeight()) {
				this.owner.dispose();
				elementIsDead = true;
		}
	}
	
	override public function onUpdate(dt:Float)
	{
		super.onUpdate(dt);
		elementScreenConstraint();
	}
	
	override public function draw(g:Graphics) 
	{
		if (elementTexture != null) {
			g.drawTexture(elementTexture, 0, 0);
		}
	}
	
	override public function getNaturalWidth():Float 
	{
		return (elementTexture != null) ? elementTexture.width : 0;
	}
	
	override public function getNaturalHeight():Float 
	{
		return (elementTexture != null) ? elementTexture.height : 0;
	}
}