package 
{
	import game.GameScreen;
	import gui.IScreen;
	import gui.GameOverScreen;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import utils.FPSCounter;


	/**
	 * The Starling root will wait for the actual fps to reach the theorical fps
	 * then launch the game.
	 * @author damrem
	 */
	public class Root extends Sprite
	{
		public static var verbose:Boolean;
		
		private var fpsCounter:FPSCounter;

		private var currentScreen:IScreen;
		
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
			this.gameScreen.GAME_OVER.add(this.gotoGameOverScreen);
			
			this.gameOverScreen = new GameOverScreen();
			this.gameOverScreen.PLAY_AGAIN.add(this.gotoGameScreen);
		}
		
		/**
		 * Wait for the actual fps to reach the theorical fps then launch the game.
		 * 
		 * @param	event
		 */
		private function onEnterFrame(event:EnterFrameEvent):void
        {
			//if (verbose)	trace(this + "onEnterFrame(" + arguments);
			if (this.fpsCounter.fps >= Starling.current.nativeStage.frameRate)
			{
				this.removeEventListener(EnterFrameEvent.ENTER_FRAME, this.onEnterFrame);
				this.removeChild(this.fpsCounter);
				this.fpsCounter = null;
				
				this.gotoGameScreen();
			}
        }
		
		private function gotoScreen(screen:IScreen):void
		{
			if (verbose)	trace(this + "gotoScreen(" + arguments);
			
			if (currentScreen)
			{
				this.removeChild(currentScreen as Sprite);
				this.currentScreen.exit();
			}
			this.currentScreen = screen;
			this.addChild(this.currentScreen as Sprite);
			this.currentScreen.enter();
		}
		
		private function gotoGameScreen():void
		{
			if (verbose)	trace(this + "gotoGameScreen(" + arguments);
			
			this.gotoScreen(this.gameScreen);
		}
		
		private function gotoGameOverScreen():void
		{
			if (verbose)	trace(this + "gotoGameOverScreen(" + arguments);
			
			this.gameOverScreen.updateScore(this.gameScreen.score);
			this.gotoScreen(this.gameOverScreen);
		}

		public function start() : void 
		{
			if (verbose)	trace(this + "start(" + arguments);
			
		}
	}
}
