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
			return assetMgr;
		}
		
		public function Assets()
		{
			if(verbose)	trace(this + "AutoGemsGame(" + arguments);
			
			loadResources();
		}
		
		public static function instance():Assets
		{
			if (!_instance)
				_instance = new Assets();
			
			return _instance;
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

			/*
			var gem6:Bitmap = new Embeds.Gem6 as Bitmap;
			var gem6_texture:Texture = Texture.fromBitmap(gem6);
			*/
			
			/*
			var start_btn_active:Bitmap = new Embeds.start_btn_active as Bitmap;
			var start_btn_active_texture:Texture = Texture.fromBitmap(start_btn_active);
			
			var start_btn_idle:Bitmap = new Embeds.start_btn_idle as Bitmap;
			var start_btn_idle_texture:Texture = Texture.fromBitmap(start_btn_idle);
			
			var stop_btn_active:Bitmap = new Embeds.stop_btn_active as Bitmap;
			var stop_btn_active_texture:Texture = Texture.fromBitmap(stop_btn_active);
			
			var stop_btn_idle:Bitmap = new Embeds.stop_btn_idle as Bitmap;
			var stop_btn_idle_texture:Texture = Texture.fromBitmap(stop_btn_idle);
			*/
			
			
			var bg:Bitmap = new Embeds.Background() as Bitmap;
			var bg_texture:Texture = Texture.fromBitmap(bg);
			
			assetMgr = new AssetManager();
			assetMgr.addTexture("gem1", gem1_texture);
			assetMgr.addTexture("gem2", gem2_texture);
			assetMgr.addTexture("gem3", gem3_texture);
			assetMgr.addTexture("gem4", gem4_texture);
			assetMgr.addTexture("gem5", gem5_texture);
			//assetMgr.addTexture("gem6", gem6_texture);
			/*
			assetMgr.addTexture("start_btn_active", start_btn_active_texture);
			assetMgr.addTexture("start_btn_idle", start_btn_idle_texture);
			assetMgr.addTexture("stop_btn_active", stop_btn_active_texture);
			assetMgr.addTexture("stop_btn_idle", stop_btn_idle_texture);
			*/
			
			assetMgr.addTexture("bg", bg_texture);
		}
	}
}