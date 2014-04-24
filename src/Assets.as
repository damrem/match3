package 
{
	import flash.display.Bitmap;
	
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	public class Assets
	{
		public static var verbose:Boolean;
		
		private var assetMgr:AssetManager;
		private static var _instance:Assets = null;
		
		public function getAssetMgr():AssetManager
		{
			return this.assetMgr;
		}
		
		public function Assets()
		{
			if(verbose)	trace(this + "AutoGemsGame(" + arguments);
			
			this.loadResources();
		}
		
		public static function instance():Assets
		{
			if (!this._instance)
				this._instance = new Assets();
			
			return this._instance;
		}
		
		private function loadResources():void
		{
			var gem1:Bitmap = new Embeds.Yellow();
			var gem1_texture:Texture = Texture.fromBitmap(gem1);
			
			var gem2:Bitmap = new Embeds.Red as Bitmap;
			var gem2_texture:Texture = Texture.fromBitmap(gem2);
			
			var gem3:Bitmap = new Embeds.Purple as Bitmap;
			var gem3_texture:Texture = Texture.fromBitmap(gem3);
			
			var gem4:Bitmap = new Embeds.Green as Bitmap;
			var gem4_texture:Texture = Texture.fromBitmap(gem4);
			
			var gem5:Bitmap = new Embeds.Blue as Bitmap;
			var gem5_texture:Texture = Texture.fromBitmap(gem5);

			var bg:Bitmap = new Embeds.Background() as Bitmap;
			var bg_texture:Texture = Texture.fromBitmap(bg);
			
			this.assetMgr = new AssetManager();
			
			this.assetMgr.addTexture("gem1", gem1_texture);
			this.assetMgr.addTexture("gem2", gem2_texture);
			this.assetMgr.addTexture("gem3", gem3_texture);
			this.assetMgr.addTexture("gem4", gem4_texture);
			this.assetMgr.addTexture("gem5", gem5_texture);
			
			this.assetMgr.addTexture("bg", bg_texture);
		}
	}
}