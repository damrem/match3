package
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
	 * This class encapsulates the Starling settings, and doing so, allows not to have flash events and starling events in the Main class.
	 */
	public class CustomStarling extends Starling 
	{
		public const rootCreated : Signal = new Signal();
		public function CustomStarling(rootClass : Class, stage : Stage, viewPort:Rectangle, stage3D : Stage3D = null, renderMode : String = "auto", profile : String = "baselineConstrained") 
		{
			super(rootClass, stage, viewPort, stage3D, renderMode, profile);            
			
            this.simulateMultitouch = false;
            this.enableErrorChecking = Capabilities.isDebugger;
			
			this.addEventListener(Event.ROOT_CREATED, this.onRootCreated);
			
			this.showStats = true;
		}
		
		private function onRootCreated(event:Event, root:Root):void
		{
			event;
			this.removeEventListener(Event.ROOT_CREATED, onRootCreated);
			this.rootCreated.dispatch(root);
		}
	}
}
