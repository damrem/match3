package {
	/**
	 * @author damrem
	 */
	public class Embeds 
	{
		/*
		 * TODO clean up
		[Embed(source="assets/ld/bg.jpg")]
		private static var _Background1x : Class;
		
		[Embed(source="assets/hd/bg.jpg")]
		private static var _Background2x : Class;

		public static function get Background1x() : Class 
		{
			return _Background1x;
		}

		public static function get Background2x() : Class 
		{
			return _Background2x;
		}
		*/
		[Embed(source = 'assets/textures/BackGround.jpg')]
		public static var Background:Class;
		
		
	}
}
