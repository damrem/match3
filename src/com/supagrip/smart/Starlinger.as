package com.supagrip.smart 
{
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.events.Event;

	import org.osflash.signals.Signal;

	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.system.Capabilities;

	/**
	 * @author damrem
	 */
	public class Starlinger extends Starling 
	{
		public const rootCreated : Signal = new Signal();
		public function Starlinger(rootClass : Class, stage : Stage, stage3D : Stage3D = null, renderMode : String = "auto", profile : String = "baselineConstrained") 
		{
			Starling.multitouchEnabled = true;  // useful on mobile devices
            Starling.handleLostContext = true;  // not necessary on iOS. Saves a lot of memory!
            
			var viewPort:Rectangle = new Rectangle(0, 0, Main.STAGE_WIDTH, Main.STAGE_HEIGHT);
			super(rootClass, stage, viewPort, stage3D, renderMode, profile);
			
			this.stage.stageWidth = Main.STAGE_WIDTH;  // <- same size on all devices!
            this.stage.stageHeight = Main.STAGE_HEIGHT; // <- same size on all devices!
            this.simulateMultitouch = false;
            this.enableErrorChecking = Capabilities.isDebugger;
			
			this.addEventListener(Event.ROOT_CREATED, this.onRootCreated);
		}
		
		private function onRootCreated(event:Event, root:IRoot):void
		{
			event;
			this.removeEventListener(Event.ROOT_CREATED, onRootCreated);
			this.rootCreated.dispatch(root);
		}
	}
}
