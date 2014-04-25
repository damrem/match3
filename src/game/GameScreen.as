package game 
{
	import flash.display.Bitmap;
	import gui.HUD;
	import gui.IScreen;
	import org.osflash.signals.Signal;
	import starling.display.Image;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author damrem
	 */
	public class GameScreen extends Sprite implements IScreen
	{
		public static var verbose:Boolean;
		public const GAME_OVER:Signal = new Signal();
		
		private var controller:GameController;
		
		/**
		 * The container for time & score.
		 */
		private var hud:HUD;
		
		private var bg:Image;
		
		public function GameScreen() 
		{
			if (verbose)	trace(this + "GameScreen(" + arguments);
			
			//	loading textures needs to be done AFTER starling setup
			Embeds.init();
			
			this.bg = this.drawBackground();
			this.hud = this.createHUD();
			
			this.controller = new GameController();
			
			this.controller.SCORE_UPDATED.add(this.hud.updateScore);
			this.controller.TIME_LEFT_UPDATED.add(this.hud.updateTimeLeft);
			this.controller.TIME_S_UP.add(this.GAME_OVER.dispatch);
			
			this.controller.board.x = 324;
			this.controller.board.y = 98;
			this.addChild(this.controller.board);
			
			this.addChild(this.hud);
		}
		
		public function enter():void
		{	
			if (verbose)	trace(this + "start(" + arguments);
			
			this.controller.start();
		}
		
		public function exit():void
		{
			this.controller.stop();
		}
		
		
		private function timesUp():void 
		{
			if (verbose)	trace(this + "timesUp(" + arguments);
			
			/*
			var boardTween:Tween = new Tween(this.controller.board, 0.25, Transitions.LINEAR);
			boardTween.fadeTo(0.25);
			Starling.juggler.add(boardTween);

			var bgTween:Tween = new Tween(this.bg, 0.25, Transitions.LINEAR);
			bgTween.fadeTo(0.25);
			Starling.juggler.add(bgTween);
			
			var hudTween:Tween = new Tween(this.hud, 0.25, Transitions.LINEAR);
			hudTween.moveTo((this.stage.stageWidth) / 2 - hud.width, (this.stage.stageHeight) / 2  -hud.height);
			hudTween.scaleTo(1.0);
			Starling.juggler.add(hudTween);
			*/
		}
		
		private function createHUD():HUD
		{
			var hud:HUD = new HUD();
			hud.y = 425;
			
			return hud;
		}
		
		private function drawBackground():Image
		{
			if (verbose)	trace(this + "drawBackground(" + arguments);
			
			var bmp:Bitmap = new Embeds.Background();
			var img:Image = Image.fromBitmap(bmp);
			this.addChild(img);
			return img;
			//this.addChild(new Image(new Embeds.Background()));
		}
		
		public function get score():uint
		{
			return this.controller.score;
		}
		
	}

}