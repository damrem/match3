package thegame 
{
	import flash.display.Bitmap;
	import starling.display.Sprite;
	import starling.display.Image;
	/**
	 * ...
	 * @author damrem
	 */
	public class GameScreen extends Sprite
	{
		public static var verbose:Boolean;
		
		private var controller:GameController;
		
		public function GameScreen() 
		{
			if (verbose)	trace(this + "GameScreen(" + arguments);
			
			//	loading textures needs to be done AFTER starling setup
			Embeds.init();
			
			//	background
			this.drawBackground();
			
			
			this.controller = new GameController();
			this.controller.board.x = 324;
			this.controller.board.y = 98;
			this.addChild(this.controller.board);
			this.controller.start();
		}
		
		private function drawBackground():void
		{
			var bmp:Bitmap = new Embeds.Background();
			var img:Image = Image.fromBitmap(bmp);
			this.addChild(img);
			//this.addChild(new Image(new Embeds.Background()));
		}
		
	}

}