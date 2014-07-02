package game 
{
	import flash.display.Bitmap;
	import gui.HUD;
	import gui.IScreen;
	import org.osflash.signals.Signal;
	import starling.core.Starling;
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
		private var bgMask:Image;
		
		public function GameScreen() 
		{
			if (verbose)	trace(this + "GameScreen(" + arguments);
			
			//	loading textures needs to be done AFTER starling setup
			Embeds.init();
			
			this.addChild(this.createBg());
			this.bgMask = this.createBgMask();
			this.hud = this.createHUD();
			
			this.controller = new GameController();
			
			this.controller.SCORE_UPDATED.add(this.hud.updateScore);
			this.controller.TIME_LEFT_UPDATED.add(this.hud.updateTimeLeft);
			this.controller.TIME_S_UP.add(this.GAME_OVER.dispatch);
			
			this.controller.board.x = 40;
			this.controller.board.y = 40;
			this.addChild(this.controller.board);
			
			this.addChild(this.bgMask);
			
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
		
		
		
		
		private function createHUD():HUD
		{
			var hud:HUD = new HUD();
			hud.x = 40;
			hud.y = 360;
			
			return hud;
		}
		
		/**
		 * Masks the top of the board to hide appearing pawns.
		 * @return
		 */
		private function createBgMask():Image
		{
			var bmp:Bitmap = new Embeds.BackgroundTopMask();
			var img:Image = Image.fromBitmap(bmp);
			//img.x = Starling.current.nativeStage.stageWidth - img.width;
			return img;
		}
		
		private function createBg():Image
		{
			var bmp:Bitmap = new Embeds.Background();
			var img:Image = Image.fromBitmap(bmp);
			return img;
		}
		
		public function get score():uint
		{
			return this.controller.score;
		}
		
	}

}