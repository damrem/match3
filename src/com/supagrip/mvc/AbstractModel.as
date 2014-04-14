package com.supagrip.mvc 
{
	import com.supagrip.abstract;

	import org.osflash.signals.Signal;
	/**
	 * @author damrem
	 */
	public class AbstractModel 
	{
		public const started:Signal = new Signal();
		public const stopped:Signal = new Signal();
		
		function AbstractModel(){}
		
		public function start():void
		{
			abstract(this, "start");
		}
		
		public function stop():void
		{
			abstract(this, "start");
		}
	}
}
