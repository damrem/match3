package com.supagrip.navigation 
{
	import org.osflash.signals.Signal;
	import starling.display.Sprite;

	import com.supagrip.abstract;
	/**
	 * @author damrem
	 */
	public class AbstractScreen extends Sprite 
	{
		public const started:Signal = new Signal();
		public const stopped:Signal = new Signal();
		
		public const shown:Signal = new Signal();
		public const hidden:Signal = new Signal();
		
		public var destroyable:Boolean;
		
		function AbstractScreen(){}
		
		public function show():void
		{
			abstract(this, "show");
		}
		
		public function hide():void
		{
			abstract(this, "hide");
		}
		
		public function start():void
		{
			abstract(this, "start");
		}
		
		public function stop():void
		{
			abstract(this, "stop");
		}
		
		public function destroy():void
		{
			abstract(this, "destroy");
		}
	}
}
