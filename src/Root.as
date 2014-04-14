package {
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	/**
	 * @author damrem
	 */
	public class Root extends Sprite
	{
		public static var verbose:Boolean;
		
		public function Root() 
		{
			if (verbose)	trace(this + "Root(" + arguments);
			
			var game:Game = new Game();
			this.addChild(game);
		}

		public function start() : void 
		{
			if (verbose)	trace(this + "start(" + arguments);
			
		}
	}
}
