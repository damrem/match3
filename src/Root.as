package {
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import thegame.GameScreen;

	/**
	 * @author damrem
	 */
	public class Root extends Sprite
	{
		public static var verbose:Boolean;
		
		public function Root() 
		{
			if (verbose)	trace(this + "Root(" + arguments);
			
			var gameScreen:GameScreen = new GameScreen();
			this.addChild(gameScreen);
		}

		public function start() : void 
		{
			if (verbose)	trace(this + "start(" + arguments);
			
		}
	}
}
