package shooterGame;

import flambe.animation.AnimatedFloat;
import flambe.Entity;
import flambe.input.PointerEvent;
import flambe.math.Point;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import haxe.Timer;
import shooterGame.mainGame.GameBullet;
import shooterGame.mainGame.GameElement;
import shooterGame.mainGame.GameEnemy;
import shooterGame.mainGame.GameShip;
import shooterGame.mainGame.GameUnit;

import shooterGame.mainGame.GameCollision;
import shooterGame.utils.AssetName;
import shooterGame.utils.pxlSq.Utils;

class Main
{
	private static var assetPack: AssetPack;
	
	//private static var gameBullet: Array<GameBullet>;
	
	private static var mainGame: Entity;
	private static var endGame: Entity;
	
	private static var playerUnit: GameShip;
	private static var testEnemy: GameEnemy;
	
	private static inline var ENEMY_LIFE: Int = 1;
	private static inline var PLAYER_LIFE: Int = 1;
	
	// Update time is used for the timer, it is expressed in milliseconds
	private static inline var UPDATE_TIME: Int = 200;
	
    private static function main ()
    {
        // Wind up all platform-specific stuff
        System.init();

        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.fromAssets("bootstrap");
        var loader = System.loadAssetPack(manifest);
        loader.get(onSuccess);
    }

    private static function onSuccess (pack :AssetPack)
    {	
		// Make the asset package available elsewhere
		assetPack = pack;
		
        // Add a solid color background
        var background = new FillSprite(0x202020, System.stage.width, System.stage.height);
        System.root.addChild(new Entity().add(background));

        // Add a plane that moves along the screen
        //var plane = new ImageSprite(pack.getTexture(AssetName.PLANE));
        //plane.x._ = 30;
        //plane.y.animateTo(200, 6);
        //System.root.addChild(new Entity().add(plane));
		//
		//var plane1 = new ImageSprite(pack.getTexture(AssetName.PLANE));
		//plane1.x._ = 30;
		//plane1.y._ = 200;
		//System.root.addChild(new Entity().add(plane1));
		
		//var a: GameCollision = new GameCollision();
		//a.setTexture(assetPack.getTexture(AssetName.PLANE));
		//System.root.addChild(new Entity().add(a));
		
		//var a: GameBullet = new GameBullet();
		//System.root.addChild(new Entity().add(a));
		
		createMainGame();
		createEndGame();
		
		System.root.addChild(mainGame);
    }
	
	private static function createMainGame(): Void {
		mainGame = new Entity();
		
		playerUnit = new GameShip();
		playerUnit.setTexture(assetPack.getTexture(AssetName.PLANE));
		playerUnit.centerAnchor();
		playerUnit.setXY(50, System.stage.height * 0.9);
		playerUnit.setRotation(180);
		mainGame.addChild(new Entity().add(playerUnit));
		
		testEnemy = new GameEnemy();
		testEnemy.setTexture(assetPack.getTexture(AssetName.PLANE));
		testEnemy.centerAnchor();
		testEnemy.setXY(System.stage.width / 2, System.stage.height * 0.1);
		mainGame.addChild(new Entity().add(testEnemy));
		
		//Utils.ConsoleLog(testEnemy.boundsToString());
		
		//System.pointer.move.connect(onPointerMove);
		System.pointer.down.connect(onPointerDown);
		
		var timer: Timer = new Timer(200);
		timer.run = onUpdate;
	}
	
	private static function createEndGame(): Void {
		endGame = new Entity();
	}
	
	private static function onUpdate(): Void {
		//Utils.ConsoleLog(System.pointer.x + " " + System.pointer.y);
		
		if(playerUnit.gameBullet != null) {
			for (bullet in playerUnit.gameBullet) {
				if (testEnemy.hasCollidedWith(bullet)) {
					testEnemy.dispose();
					bullet.dispose();
				}
			}
		}
	}
	
	//private static function onPointerMove(event: PointerEvent) {
		//
	//}
	
	private static function onPointerDown(event: PointerEvent) {
		playerUnit.FireBullet();
		//SpawnBullet(event.viewX, event.viewY);
	}
	
	//private static function SpawnBullet(x: Float, y: Float) {
		//var bullet: GameBullet = new GameBullet(x, y);
		//bullet.centerAnchor();
		//gameBullet.push(bullet);
		//mainGame.addChild(new Entity().add(bullet));
		//
		////Utils.ConsoleLog(gameBullet.length + "");
	//}
}
