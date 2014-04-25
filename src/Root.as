package 
{
	import game.GameScreen;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import utils.FPSCounter;
	import starling.core.Starling;


	/**
	 * The Starling root will wait for the actual fps to reach the theorical fps
	 * then launch the game.
	 * @author damrem
	 */
	public class Root extends Sprite
	{
		public static var verbose:Boolean;
		
		private var fpsCounter:FPSCounter;
		private var gameScreen:GameScreen;
		private var gameOverScreen:GameOverScreen;
		
		public function Root() 
		{
			if (verbose)	trace(this + "Root(" + arguments);
			
			//	we delay the start in order to wait for the framerate to be ready
			this.fpsCounter = new FPSCounter();
			this.addChild(this.fpsCounter);
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, this.onEnterFrame);
			
			this.gameScreen = new GameScreen();
			
			this.gameOverScreen = new GameOverScreen();
			
		}
		
		/**
		 * Wait for the actual fps to reach the theorical fps then launch the game.
		 * 
		 * @param	event
		 */
		private function onEnterFrame(event:EnterFrameEvent):void
        {
			if (verbose)	trace(this + "onEnterFrame(" + arguments);
			if (this.fpsCounter.fps >= Starling.current.nativeStage.frameRate)
			{
				this.removeEventListener(EnterFrameEvent.ENTER_FRAME, this.onEnterFrame);
				this.removeChild(this.fpsCounter);
				this.fpsCounter = null;
				
				this.addChild(this.gameScreen);
				this.gameScreen.start();
			}
        }

		public function start() : void 
		{
			if (verbose)	trace(this + "start(" + arguments);
			
		}
	}
}
