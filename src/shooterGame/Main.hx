package shooterGame;

import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.Font;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.input.PointerEvent;
import flambe.System;
import flambe.util.SignalConnection;
import haxe.Timer;

import shooterGame.mainGame.GameEnemy;
import shooterGame.mainGame.GameShip;
import shooterGame.utils.AssetName;


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
	private static var enemiesDestroyedText: TextSprite;
	
	// End Game Data
	private static var gameOverScoreText: TextSprite;
	private static var playAgainBG: FillSprite;
	private static var playAgainText: TextSprite;
	
	// Game Font
	private static var gameFont: Font;
	
	// Signal connection used for firing
	private static var playerFireSignalConnection: SignalConnection;
	
	// Signal connection used for moving
	private static var playerMoveSignalConnection: SignalConnection;
	
	// Constants for unit lives
	private static inline var ENEMY_LIFE: Int = 1;
	private static inline var PLAYER_LIFE: Int = 1;
	
	// Update time is used for the timer (expressed in milliseconds)
	private static inline var UPDATE_TIME: Int = 100;
	
	// Spawn rate of the enemies (expressed in milliseconds)
	private static inline var SPAWN_RATE: Int = 1500;
	
	// Used to store enemies and accessing them
	private static inline var ENEMY_NAME_FORMAT = "enemies/ship_";
	
	// UI background height
	private static inline var UI_BACKGROUND_HEIGHT = 50;
	
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
        var background: FillSprite = new FillSprite(0x202020, System.stage.width, System.stage.height);
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
		
		// UI for enemies destroyed
		var enemiesDestroyedEntity: Entity = new Entity();
		var enemiesDestroyedBG: FillSprite = new FillSprite(0xFF9200, System.stage.width, UI_BACKGROUND_HEIGHT);
		enemiesDestroyedBG.setXY(0, System.stage.height - UI_BACKGROUND_HEIGHT);
		enemiesDestroyedEntity.add(enemiesDestroyedBG);
		
		enemiesDestroyedText = new TextSprite(gameFont, "Enemies Destroyed:");
		enemiesDestroyedText.y._ += enemiesDestroyedText.getNaturalHeight() / 3;
		setScoreDirty();
		enemiesDestroyedEntity.addChild(new Entity().add(enemiesDestroyedText));
		
		mainGame.addChild(enemiesDestroyedEntity);
	}
	
	private static function createEndGame(): Void {
		endGame = new Entity();
		
		var headerEntity: Entity = new Entity();
		var headerBG: FillSprite = new FillSprite(0xFF9200, System.stage.width, UI_BACKGROUND_HEIGHT);
		headerBG.y._ = System.stage.height / 3 - (headerBG.height._ / 2);
		headerEntity.add(headerBG);
		
		var gameOverText: TextSprite = new TextSprite(gameFont, "GAME OVER");
		gameOverText.centerAnchor();
		gameOverText.x._ = System.stage.width / 2;
		gameOverText.y._ += headerBG.getNaturalHeight() / 2;
		headerEntity.addChild(new Entity().add(gameOverText));
		
		endGame.addChild(headerEntity);
		
		var scoreEntity: Entity = new Entity();
		var scoreBG: FillSprite = new FillSprite(0x9B61A4, System.stage.width, UI_BACKGROUND_HEIGHT);
		scoreBG.y._ = System.stage.height / 3 + (scoreBG.height._ / 2);
		scoreEntity.add(scoreBG);
		
		gameOverScoreText = new TextSprite(gameFont, "SCORE: 0000000");
		gameOverScoreText.align = TextAlign.Center;
		gameOverScoreText.centerAnchor();
		gameOverScoreText.x._ = (System.stage.width / 2) + (gameOverScoreText.getNaturalWidth() / 2);
		gameOverScoreText.y._ += scoreBG.getNaturalHeight() / 2;
		scoreEntity.addChild(new Entity().add(gameOverScoreText));
		
		endGame.addChild(scoreEntity);
		
		var playAgainEntity: Entity = new Entity();
		playAgainBG = new FillSprite(0xFFFCBD, System.stage.width, UI_BACKGROUND_HEIGHT);
		playAgainBG.y._ = System.stage.height / 3 + ((playAgainBG.height._ / 2) * 3);
		
		// Hover In on play again button
		playAgainBG.pointerIn.connect(function(event: PointerEvent) {
			playAgainBG.color = 0xFFF98A;
		});
		
		// Hover Out on play again button
		playAgainBG.pointerOut.connect(function(event: PointerEvent) {
			playAgainBG.color = 0xFFFCBD;
		});
		
		playAgainEntity.add(playAgainBG);
		
		playAgainText = new TextSprite(gameFont, "PLAY AGAIN!");
		playAgainText.centerAnchor();
		
		playAgainText.x._ = System.stage.width / 2;
		playAgainText.y._ += playAgainBG.getNaturalHeight() / 2;
		playAgainEntity.addChild(new Entity().add(playAgainText));
		
		endGame.addChild(playAgainEntity);
	}
	
	private static function showMainGame() {	
		enemiesDestroyed = 0;
		setScoreDirty();
		
		spawnerTimer = new Timer(SPAWN_RATE);
		spawnerTimer.run = spawnEnemy;
		
		updateTimer = new Timer(UPDATE_TIME);
		updateTimer.run = onUpdate;

		// Dispose any remaining enemies from last game
		if(enemyUnits.length > 0) {
			for (enemy in enemyUnits) {
				enemy.dispose();
			}
		}
		enemyUnits = new Array<GameEnemy>();
		
		// Dispose any remaining bullets from last game
		if (playerUnit.shipBullets.length > 0) {
			for (bullet in playerUnit.shipBullets) {
				bullet.dispose();
			}
		}
		playerUnit.clearShipBullets();
		
		playerUnit.setRotation(180);
		playerUnit.setXY(System.stage.width / 2, System.stage.height * 0.8);
		
		// We need to re-add the player unit to the main game entity
		mainGame.addChild(new Entity().add(playerUnit));
		
		System.root.removeChild(endGame);
		System.root.addChild(mainGame);
		
		playerFireSignalConnection = System.pointer.down.connect(onMouseDown);
		playerMoveSignalConnection = System.pointer.move.connect(playerUnit.onMouseMove);
	}
	
	private static function showGameEnd() {	
		gameOverScoreText.text = "Score: " + enemiesDestroyed;
		
		// Pointer trigger for play again button
		playAgainBG.pointerUp.connect(function(event: PointerEvent) {
			showMainGame();
		}).once();	
		
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
		var xPos: Float = (randXpos < enemy.getNaturalWidth()) ? randXpos + enemy.getNaturalWidth() * 2 : randXpos - enemy.getNaturalWidth() * 2;
		enemy.setXY(xPos, 0);
		enemy.y.animateTo(System.stage.height + 100, 5);
		
		mainGame.addChild(new Entity().add(enemy), false);
		enemyUnits.push(enemy);		
	}
	
	private static function onUpdate(): Void {
		// Collision detection for player's ship bullet and enemies
		if (playerUnit.shipBullets != null && enemyUnits != null) {
			for (bullet in playerUnit.shipBullets) {
				for (enemy in enemyUnits) {
					if (bullet.hasCollidedWith(enemy)) {
						enemy.subtractLife();
						if (enemy.isDead()) {
							enemyUnits.remove(enemy);
							enemiesDestroyed++;
							setScoreDirty();
						}
						
						bullet.dispose();
						playerUnit.removeBullet(bullet);
					}
				}
			}
		}
		
		// Cleaning bullet list 
		if (playerUnit.shipBullets!= null) {
			for (bullet in playerUnit.shipBullets) {
				if (bullet != null && bullet.isDead()) {
					playerUnit.removeBullet(bullet);
				}
			}
		}
		
		if (enemyUnits != null) {
			for (enemy in enemyUnits) {
				if (enemy != null) {
					// Cleaning enemy List
					if(enemy.isDead()) {
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
							
							playerFireSignalConnection.dispose();
							playerMoveSignalConnection.dispose();
							
							showGameEnd();
						}
					}
				}
			}
		}
	}
	
	private static function onMouseDown(event: PointerEvent): Void {
		playerUnit.fireBullet();
	}
	
	private static function setScoreDirty(): Void {
		enemiesDestroyedText.text = "Enemies Destroyed: " + enemiesDestroyed;
	}
}
