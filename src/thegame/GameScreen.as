package thegame
{
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GameScreen extends Sprite
	{	
		public static var verbose:Boolean;
		private var board:Board = new Board();
		private var startBtn:Button;
		private var stopBtn:Button;
		
		
		public function GameScreen()
		{
			if (verbose) trace(this + "GameScreen(" + arguments);
			super();
			var game:Assets = Assets.instance();
			
			board = new Board();
			board.addEventListener(Board.NO_MATCH, noMatchAnymore);
			
			addChild(new Image(game.getAssetMgr().getTexture("bg")));
			addChild(board);
			
			board.start();
			/*
			startBtn = new Button(
				game.getAssetMgr().getTexture("start_btn_idle"),"",
				game.getAssetMgr().getTexture("start_btn_active"));
				
			stopBtn = new Button(
				game.getAssetMgr().getTexture("stop_btn_idle"),"",
				game.getAssetMgr().getTexture("stop_btn_active"));
				*/
			
				/*
			startBtn.x = 270;
			startBtn.y = 550;
			startBtn.addEventListener(Event.TRIGGERED, btnPressed);
			stopBtn.x = 440;
			stopBtn.y = 550;
			stopBtn.addEventListener(Event.TRIGGERED, btnPressed);
			*/
			
			//addChild(startBtn);
			//addChild(stopBtn);
			
			//stopBtn.enabled = false;
		}
		
		private function noMatchAnymore(e:Event):void
		{
			startBtn.enabled = true;
			stopBtn.enabled = false;
		}
		
		private function btnPressed(e:Event):void
		{
			if (e.target == startBtn)
			{
				board.start();
				startBtn.enabled = false;
				stopBtn.enabled = true;
			}
			else if (e.target == stopBtn)
			{
				board.stop();
				startBtn.enabled = true;
				stopBtn.enabled = false;
			}
		}
	}
}