package gui 
{
	import starling.display.Sprite;
	import starling.text.TextField;
	import utils.formatTime;
	import starling.utils.HAlign;
	/**
	 * ...
	 * @author damrem
	 */
	public class HUD extends Sprite
	{
		public static var verbose:Boolean;
		
		private var tfTimeLeft:TextField;
		private var tfScore:TextField;
		
		public function HUD() 
		{
			this.drawTimer();
			this.drawScore();
			this.scaleX = this.scaleY = 0.5;
		}
		
		private function drawScore():void
		{
			this.tfScore = new TextField(512, 128, "", "Courier New", 96, 0x000000, true);
			//tfScore.border = true;
			this.tfScore.hAlign = HAlign.CENTER;
			this.addChild(this.tfScore);
		}
		
		private function drawTimer():void 
		{
			if (verbose)	trace(this + "drawTimer(" + arguments);
			
			this.tfTimeLeft = new TextField(512, 80, "", "Courier New", 64, 0x000000, true);
			//tfTimeLeft.border = true;
			this.tfTimeLeft.hAlign = HAlign.CENTER;
			this.tfTimeLeft.y = 100;
			this.addChild(this.tfTimeLeft);
		}
		
		public function updateTimeLeft(timeLeft:uint):void 
		{
			if (verbose)	trace(this + "updateTimer(" + arguments);
			
			this.tfTimeLeft.text = formatTime(timeLeft);
		}
		
		public function updateScore(score:uint):void 
		{
			if (verbose)	trace(this + "updateScore(" + arguments);
			
			this.tfScore.text = "" + score;
		}
		
		
		
	}

}