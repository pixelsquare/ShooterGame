package shooterGame.mainGame;

import flambe.System;
import flambe.display.Graphics;
import flambe.display.Texture;
import flambe.display.Sprite;
import flambe.Entity;
import format.agal.Data.Tex;

import shooterGame.utils.pxlSq.Utils;

/**
 * ...
 * @author ...
 */
class GameElement extends Sprite
{

	public var texture: Texture;
	private var isDead: Bool;
	
	public function new() 
	{
		super();
		isDead = false;
	}
	
	public function setTexture(texture: Texture): Void {
		this.texture = texture;
	}
	
	public function IsDead(): Bool {
		return isDead;
	}
	
	public function elementGameBounds() {
				// Remove the element when is out of the screen bounds
		if (this.x._ <= 0 || this.x._ >= System.stage.width ||
			this.y._ <= 0 || this.y._ >= System.stage.height) {
				this.owner.dispose();
				isDead = true;
		}
	}
	
	override public function onAdded() 
	{
		super.onAdded();
	}
	
	override public function onRemoved() 
	{
		this.owner.dispose();
	}
	
	override public function onUpdate(dt:Float) 
	{
		super.onUpdate(dt);
		elementGameBounds();
	}
	
	override public function draw(g:Graphics) 
	{
		if (texture != null) {
			g.drawTexture(texture, 0, 0);
		}
	}
	
	override public function getNaturalWidth():Float 
	{
		return (texture != null) ? texture.width : 0;
	}
	
	override public function getNaturalHeight():Float 
	{
		return (texture != null) ? texture.height : 0;
	}
}