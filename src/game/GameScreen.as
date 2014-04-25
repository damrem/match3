package game 
{
	import flash.display.Bitmap;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.text.TextField;
	import utils.formatTime;
	/**
	 * ...
	 * @author damrem
	 */
	public class GameScreen extends Sprite
	{
		public static var verbose:Boolean;
		
		private var controller:GameController;
		private var tfTimeLeft:TextField;
		private var tfScore:TextField;
		
		public function GameScreen() 
		{
			if (verbose)	trace(this + "GameScreen(" + arguments);
			
			//	loading textures needs to be done AFTER starling setup
			Embeds.init();
			
			this.drawBackground();
			this.drawTimer();
			this.drawScore();
			
			this.controller = new GameController();
			
			this.controller.SCORE_UPDATED.add(this.updateScore);
			this.controller.TIME_LEFT_UPDATED.add(this.updateTimeLeft);
			this.controller.TIME_S_UP.add(this.timesUp);
			
			this.controller.board.x = 324;
			this.controller.board.y = 98;
			this.addChild(this.controller.board);
			
			this.controller.start();
		}
		
		private function timesUp():void 
		{
			
		}
		
		private function updateTimeLeft():void 
		{
			if (verbose)	trace(this + "updateTimer(" + arguments);
			
			this.tfTimeLeft.text = formatTime(this.controller.timeLeft_sec);
		}
		
		private function updateScore():void 
		{
			if (verbose)	trace(this + "updateScore(" + arguments);
			
			this.tfScore.text = "" + this.controller.score;
		}
		
		private function drawScore():void 
		{
			if (verbose)	trace(this + "drawScore(" + arguments);
			
			this.tfScore = new TextField(256, 64, "", "Courier New", 48);
			this.tfScore.y = 425;
			this.addChild(this.tfScore);
		}
		
		private function drawTimer():void 
		{
			if (verbose)	trace(this + "drawTimer(" + arguments);
			
			this.tfTimeLeft = new TextField(256, 40, "", "Courier New", 32);
			this.tfTimeLeft.y = 475;
			this.addChild(this.tfTimeLeft);
		}
		
		private function drawBackground():void
		{
			if (verbose)	trace(this + "drawBackground(" + arguments);
			
			var bmp:Bitmap = new Embeds.Background();
			var img:Image = Image.fromBitmap(bmp);
			this.addChild(img);
			//this.addChild(new Image(new Embeds.Background()));
		}
		
	}

}