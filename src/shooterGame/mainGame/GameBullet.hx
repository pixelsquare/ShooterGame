package shooterGame.mainGame;

import flambe.animation.AnimatedFloat;
import flambe.System;
import flambe.display.Graphics;
import flambe.display.FillSprite;
import flambe.Entity;
import flambe.math.Point;

import shooterGame.utils.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class GameBullet extends GameCollision
{

	private var bulletShape: FillSprite;
	private var bulletSize: Float;
	
	public static inline var BULLET_SIZE: Int = 20;
	
	public function new(x: Float, y: Float) 
	{
		super();
		this.setXY(x, y);
		setBulletSize(BULLET_SIZE);
		bulletShape = new FillSprite(Std.random(0x1000000), this.getNaturalWidth(), this.getNaturalHeight());
		this.y.animateTo(0, 1);
	}
	
	public function setBulletSize(size: Float): Void {
		this.bulletSize = size;
		setColliderSize(new Point(this.getNaturalWidth() / 2, this.getNaturalHeight() / 2));
	}
	
	override public function onAdded() 
	{
		this.owner.addChild(new Entity().add(this.bulletShape));
	}
	
	override public function getNaturalWidth():Float 
	{
		return bulletSize;
	}
	
	override public function getNaturalHeight():Float 
	{
		return bulletSize;
	}
}