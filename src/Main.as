package {
	import starling.textures.Texture;

	import com.supagrip.smart.IRoot;
	import com.supagrip.smart.Starlinger;

	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	/**
	 * @author damrem
	 */
	//[Frame (factoryClass='Preloader')]
	[SWF(backgroundColor="#000000", frameRate=30, width="755", height="600")]
	public class Main extends MovieClip 
	{
		public static var verbose : Boolean;
		
		public static const STAGE_WIDTH:uint = 755;
		public static const STAGE_HEIGHT:uint = 600;
		
		/**
		 * L'objet starling un peu boosté.
		 */
		private var starling:Starlinger;
		
		/**
		 * Le fond bitmap affiché par la displayList en attendant Starling
		 */
		private var backgroundBitmap:Bitmap;
		
		
		public function Main() 
		{
			Debug.setup();
			
			if(verbose)	trace(this + "Main(" + arguments);
			
			this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, false, 0, true);
		}
		
		/**
		 * Appelé quand le Stage est en place.
		 */
		private function onAddedToStage(event:Event):void
		{
			if (verbose)	trace(this + "onAddedToStage(" + arguments);
			
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, false);
			
			//	mise en place de starling
			this.starling = new Starlinger(Navigator, this.stage);
			this.starling.rootCreated.add(this.onRootCreated);
		}
		
		/**
		 * Appelé quand Starling est en place.
		 */
		private function onRootCreated(root:IRoot):void
		{
			if(verbose)	trace(this+"onRootCreated("+arguments);
			
			//	lancement de Starling
            this.starling.start();

			root.start();
		}
	}
}
