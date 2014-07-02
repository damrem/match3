package gui
{
	import flash.display.Stage;
	import gui.IScreen;
	import org.osflash.signals.Signal;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	/**
	 * ...
	 * @author damrem
	 */
	public class GameOverScreen extends Sprite implements IScreen
	{
		public static var verbose:Boolean;
		public const PLAY_AGAIN:Signal = new Signal();
		
		private var tf:TextField;

		public function GameOverScreen() 
		{
			if (verbose)	trace(this + "GameOverScreen(" + arguments);
			
			var stage:Stage = Starling.current.nativeStage;

			tf = new TextField(stage.stageWidth, stage.stageHeight, "", "Courier New", 24, 0xffffff, true);
		
			this.addChild(tf);
			
			this.tf.addEventListener(TouchEvent.TOUCH, this.onTouch);
		}
		
		public function enter():void
		{
			
		}
		
		public function exit():void
		{
			
		}
		
		private function onTouch(event:TouchEvent):void 
		{
			var touch:Touch = event.getTouch(this.tf);
			if (touch && touch.phase == TouchPhase.ENDED)
			{
				this.PLAY_AGAIN.dispatch();
			}
		}
		
		public function updateScore(score:uint):void
		{
			this.tf.text = "Time's up!\n";
			this.tf.text += "Final score: "+score+"\n";
			this.tf.text += "Click to play again...";
		}
		
	}

}