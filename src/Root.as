package {
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	import com.supagrip.smart.IRoot;

	/**
	 * @author damrem
	 */
	public class Root extends Sprite implements IRoot 
	{
		public static var verbose:Boolean;
		
		public function Root() 
		{
			if(verbose)	trace(this + "Root(" + arguments);
		}

		public function start() : void 
		{
			if(verbose)	trace(this + "start(" + arguments);
			this.addChild(new Image(backgroundTexture));
			
			var navigator:Navigator = new Navigator();
			this.addChild(navigator);
			navigator.gotoMenu();
		}
	}
}
