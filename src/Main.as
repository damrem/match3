package {
	import fl.video.ReconnectClient;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import starling.textures.Texture;

	import starling.core.Starling;

	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	/**
	 * @author damrem
	 */
	[SWF(backgroundColor="#000000", frameRate=60, width="755", height="600")]
	public class Main extends MovieClip 
	{
		public static var verbose : Boolean;
		
		public static const STAGE_WIDTH:uint = 755;
		public static const STAGE_HEIGHT:uint = 600;
		
		/**
		 * L'objet starling un peu boosté.
		 */
		private var starling:CustomStarling;
		
		/**
		 * Le fond bitmap affiché par la displayList en attendant Starling
		 */
		private var backgroundBitmap:Bitmap;
		
		
		public function Main() 
		{
			Verbosifier.setup();
			
			if(verbose)	trace(this + "Main(" + arguments);
			
			if (this.stage)
			{
				this.onAddedToStage();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, false, 0, true);
			}
		}
		
		/**
		 * Appelé quand le Stage est en place.
		 */
		private function onAddedToStage(event:Event = null):void
		{
			if (verbose)	trace(this + "onAddedToStage(" + arguments);
			
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, false);
			
			//	setting up Starling
			var viewPort:Rectangle = new Rectangle(0, 0, STAGE_WIDTH, STAGE_HEIGHT);
			this.starling = new CustomStarling(Root, this.stage, viewPort);
			this.starling.rootCreated.add(this.onRootCreated);
		}
		
		/**
		 * Appelé quand Starling est en place.
		 */
		private function onRootCreated(root:Root):void
		{
			if (verbose)	trace(this + "onRootCreated(" + arguments);
			
			this.starling.rootCreated.removeAll();
			
			
			
			//	lancement de Starling
            this.starling.start();
		}
	}
}
