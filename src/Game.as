package  
{
	import flash.display.Bitmap;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author damrem
	 */
	public class Game extends Sprite
	{
		public static var verbose:Boolean;
		
		public function Game() 
		{
			this.addBg();
			
			
		}
		
		private function addBg():void
		{
			var bgBitmap:Bitmap = new Embeds.Background();
			var bgTexture:Texture = Texture.fromBitmap(bgBitmap);
			this.addChild(new Image(bgTexture));
		}
	}

}