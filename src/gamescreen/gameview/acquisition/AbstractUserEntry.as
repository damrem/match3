package gamescreen.gameview.acquisition {
	import starling.core.Starling;

	import org.osflash.signals.Signal;
	/**
	 * @author damrem
	 */
	public class AbstractUserEntry 
	{
		protected var starling:Starling;
		
		public const left:Signal = new Signal();
		public const right:Signal = new Signal();
		public const down:Signal = new Signal();
		
		function AbstractUserEntry(){}
	}
}
