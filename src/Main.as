package 
{
	
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
	[SWF(backgroundColor="#000000", frameRate=60, width="400", height="400")]
	public class Main extends MovieClip 
	{
		public static var verbose : Boolean;
		
		/**
		 * The customized Starling object.
		 */
		private var starling:CustomStarling;
		
		/**
		 * The bitmap background displayed by the flash display list while waiting for Starling.
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
		 * When the flash Stage is ready, we set up Starling.
		 */
		private function onAddedToStage(event:Event = null):void
		{
			if (verbose)	trace(this + "onAddedToStage(" + arguments);
			
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, false);
			
			//	setting up Starling
			var viewPort:Rectangle = new Rectangle(0, 0, this.stage.stageWidth, this.stage.stageHeight);
			this.starling = new CustomStarling(Root, this.stage, viewPort);
			this.starling.rootCreated.add(this.onRootCreated);
		}
		
		/**
		 * When Starling is ready, we start it.
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
