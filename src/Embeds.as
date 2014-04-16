package 
{
	import flash.display.Bitmap;
	import starling.textures.Texture;
	/**
	 * @author damrem
	 */
	public class Embeds 
	{
		public static var verbose:Boolean;
		
		[Embed(source = 'assets/textures/BackGround.jpg')]
		public static const Background:Class;
		
		[Embed(source = 'assets/textures/Yellow.png')]
		public static const Yellow:Class;
		
		[Embed(source = 'assets/textures/Red.png')]
		public static const Red:Class;
		
		[Embed(source = 'assets/textures/Purple.png')]
		public static const Purple:Class;
		
		[Embed(source = 'assets/textures/Green.png')]
		public static const Green:Class;
		
		[Embed(source = 'assets/textures/Blue.png')]
		public static const Blue:Class;
		
		public static var gemTextures:Vector.<Texture>;
		
		public static function init():void
		{
			if (verbose)	trace(Embeds+"init(" + arguments);
			
			gemTextures = new <Texture>[];
			gemTextures.push(Texture.fromBitmap(new Yellow() as Bitmap));
			gemTextures.push(Texture.fromBitmap(new Red() as Bitmap));
			gemTextures.push(Texture.fromBitmap(new Purple() as Bitmap));
			gemTextures.push(Texture.fromBitmap(new Green() as Bitmap));
			gemTextures.push(Texture.fromBitmap(new Blue() as Bitmap));
			
		}
		
	}
}
