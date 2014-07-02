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
		}
		
		private function drawScore():void
		{
			this.tfScore = new TextField(240, 40, "", "Courier New", 32, 0xffffff, true);
			this.tfScore.hAlign = HAlign.LEFT;
			this.addChild(this.tfScore);
		}
		
		private function drawTimer():void 
		{
			if (verbose)	trace(this + "drawTimer(" + arguments);
			
			this.tfTimeLeft = new TextField(240, 40, "", "Courier New", 24, 0xffffff, true);
			this.tfTimeLeft.hAlign = HAlign.RIGHT;
			this.tfTimeLeft.x = 320 - tfTimeLeft.width;
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