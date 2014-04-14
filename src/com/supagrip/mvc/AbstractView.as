package com.supagrip.mvc 
{
	import org.osflash.signals.Signal;
	import starling.display.Sprite;

	import com.supagrip.abstract;

	/**
	 * @author damrem
	 */
	public class AbstractView extends Sprite 
	{
		protected var model:AbstractModel;
		
		public const started:Signal = new Signal();
		public const stopped:Signal = new Signal();
		
		function AbstractView(model:AbstractModel) 
		{
			this.model = model;
		}
		
		public function start():void
		{
			abstract(this, "start");
		}
		
		public function stop():void
		{
			abstract(this, "stop");
		}
	}
}
