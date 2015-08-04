package shooterGame;

import flambe.animation.AnimatedFloat;
import flambe.Component;
import flambe.display.Font;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.input.PointerEvent;
import flambe.math.Point;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.util.SignalConnection;
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
	
	// Entities for game scenes
	private static var mainGame: Entity;
	private static var endGame: Entity;
	
	// Units inside the game
	private static var playerUnit: GameShip;
	private static var enemyUnits: Array<GameEnemy>;
	
	// Timers for collision detection and spawner
	private static var updateTimer: Timer;
	private static var spawnerTimer: Timer;
	
	// Game data
	private static var enemiesDestroyed: Int;
	private static var enemiesDestryoedText: TextSprite;
	
	// End Game Data
	private static var gameOverScoreText: TextSprite;
	private static var playAgainText: TextSprite;
	
	// Game Font
	private static var gameFont: Font;
	
	// Signal connection used for firing
	private static var gameSignalConnection: SignalConnection;
	
	// Constants for unit lives
	private static inline var ENEMY_LIFE: Int = 1;
	private static inline var PLAYER_LIFE: Int = 1;
	
	// Update time is used for the timer (expressed in milliseconds)
	private static inline var UPDATE_TIME: Int = 100;
	
	// Spawn rate of the enemies (expressed in milliseconds)
	private static inline var SPAWN_RATE: Int = 1500;
	
	// Used to store enemies and accessing them
	private static inline var ENEMY_NAME_FORMAT = "enemies/ship_";
	
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
		
		gameFont = new Font(assetPack, AssetName.FONT_BEBASNEUE);
		
		createMainGame();
		createEndGame();
		
		showMainGame();
    }
	
	private static function createMainGame(): Void {
		mainGame = new Entity();
	
		playerUnit = new GameShip();
		playerUnit.setTexture(assetPack.getTexture(AssetName.PLANE));
		playerUnit.centerAnchor();
		
		enemyUnits = new Array<GameEnemy>();
		
		enemiesDestroyed = 0;
		var enemiesDestroyedEntity: Entity = new Entity();
		var enemiesDestroyedBG = new FillSprite(0xFF9200, System.stage.width, 40);
		enemiesDestroyedBG.setXY(0, System.stage.height - 40);
		enemiesDestroyedEntity.add(enemiesDestroyedBG);
		
		enemiesDestryoedText = new TextSprite(gameFont, "Enemies Destroyed:");
		setScoreDirty();
		enemiesDestroyedEntity.addChild(new Entity().add(enemiesDestryoedText));
		
		mainGame.addChild(enemiesDestroyedEntity);
	}
	
	private static function createEndGame(): Void {
		endGame = new Entity();
		
		var headerEntity: Entity = new Entity();
		var headerBG = new FillSprite(0xFF9200, System.stage.width, 40);
		headerBG.y._ = System.stage.height / 2 - (headerBG.height._ / 2);
		headerEntity.add(headerBG);
		
		var gameOverText = new TextSprite(gameFont, "GAME OVER");
		gameOverText.centerAnchor();
		gameOverText.x._ = System.stage.width / 2;
		gameOverText.y._ += gameOverText.getNaturalHeight() / 2;
		headerEntity.addChild(new Entity().add(gameOverText));
		
		endGame.addChild(headerEntity);
		
		var scoreEntity: Entity = new Entity();
		var scoreBG = new FillSprite(0x9B61A4, System.stage.width, 40);
		scoreBG.y._ = System.stage.height / 2 + (scoreBG.height._ / 2);
		scoreEntity.add(scoreBG);
		
		gameOverScoreText = new TextSprite(gameFont, "SCORE: 0000000");
		gameOverScoreText.align = TextAlign.Center;
		gameOverScoreText.centerAnchor();
		gameOverScoreText.x._ = (System.stage.width / 2) + (gameOverScoreText.getNaturalWidth() / 2);
		gameOverScoreText.y._ += gameOverScoreText.getNaturalHeight() / 2;
		scoreEntity.addChild(new Entity().add(gameOverScoreText));
		
		endGame.addChild(scoreEntity);
		
		playAgainText = new TextSprite(gameFont, "PLAY AGAIN!");
		playAgainText.centerAnchor();
		
		playAgainText.x._ = System.stage.width / 2;
		playAgainText.y._ = scoreBG.y._ + (playAgainText.getNaturalHeight() * 2);
		endGame.addChild(new Entity().add(playAgainText));
	}
	
	private static function showMainGame() {	
		enemiesDestroyed = 0;
		setScoreDirty();
		
		spawnerTimer = new Timer(SPAWN_RATE);
		spawnerTimer.run = spawnEnemy;
		
		updateTimer = new Timer(UPDATE_TIME);
		updateTimer.run = onUpdate;

		// Dispose left over enemies from last game
		if(enemyUnits.length > 0) {
			for (enemy in enemyUnits) {
				enemy.dispose();
			}
		}
		enemyUnits = new Array<GameEnemy>();
		
		// Dispose left over bullets from last game
		if (playerUnit.gameBullet.length > 0) {
			for (bullet in playerUnit.gameBullet) {
				bullet.dispose();
			}
		}
		playerUnit.gameBullet = new Array<GameBullet>();
		
		playerUnit.setXY(50, System.stage.height * 0.8);
		playerUnit.setRotation(180);
		
		mainGame.addChild(new Entity().add(playerUnit));
		
		System.root.removeChild(endGame);
		System.root.addChild(mainGame);
		
		gameSignalConnection = System.pointer.down.connect(onMouseDown);
	}
	
	private static function showGameEnd() {	
		gameOverScoreText.text = "Score: " + enemiesDestroyed;
		
		playAgainText.pointerUp.connect(function(event: PointerEvent) {
			showMainGame();
		}).once();
		
		//Utils.ConsoleLog(playerUnit.gameBullet.length + " " + enemyUnits.length);
		
		
		System.root.removeChild(mainGame);
		System.root.addChild(endGame);
	}
	
	private static function spawnEnemy(): Void {
		var randIndx: Int = Std.random(8) + 1;
		var enemy: GameEnemy = new GameEnemy();
		enemy.setTexture(assetPack.getTexture(ENEMY_NAME_FORMAT + randIndx));
		enemy.centerAnchor();
		enemy.setLife(ENEMY_LIFE);
		
		var randXpos: Float = Std.random(System.stage.width);
		var xPos: Float = (randXpos < enemy.getNaturalWidth()) ? randXpos + enemy.getNaturalWidth() : randXpos - enemy.getNaturalWidth();
		enemy.setXY(xPos, 0);
		enemy.y.animateBy(600, 5);
		//enemy.y.animateTo(System.stage.height, 5);
		
		//Utils.ConsoleLog(enemyUnits.length + "");
		
		mainGame.addChild(new Entity().add(enemy));
		enemyUnits.push(enemy);		
	}
	
	private static function onUpdate(): Void {
		// Collision detection for player's ship bullet and enemies
		if (playerUnit.gameBullet != null && enemyUnits != null) {
			for (bullet in playerUnit.gameBullet) {
				for (enemy in enemyUnits) {
					if (bullet.hasCollidedWith(enemy)) {
						enemy.subtractLife();
						if (enemy.IsDead()) {
							enemyUnits.remove(enemy);
							enemiesDestroyed++;
							setScoreDirty();
						}
						
						bullet.dispose();
						playerUnit.RemoveBullet(bullet);
					}
				}
			}
		}
		
		// Cleaning bullet list 
		if (playerUnit.gameBullet != null) {
			for (bullet in playerUnit.gameBullet) {
				if (bullet != null && bullet.IsDead()) {
					playerUnit.RemoveBullet(bullet);
				}
			}
		}
		
		if (enemyUnits != null) {
			for (enemy in enemyUnits) {
				if (enemy != null) {
					// Cleaning enemy List
					if(enemy.IsDead()) {
						enemyUnits.remove(enemy);
					}
					else {
						// Collision detection for enemy and player's ship
						if (playerUnit.hasCollidedWith(enemy)) {
							playerUnit.dispose();
							enemy.subtractLife(ENEMY_LIFE);
							
							updateTimer.stop();
							updateTimer = null;
							
							spawnerTimer.stop();
							spawnerTimer = null;
							
							gameSignalConnection.dispose();
							
							showGameEnd();
						}
					}
				}
			}
		}
	}
	
	private static function onMouseDown(event: PointerEvent): Void {
		playerUnit.FireBullet();
	}
	
	private static function setScoreDirty(): Void {
		enemiesDestryoedText.text = "Enemies Destroyed: " + enemiesDestroyed;
	}
}
