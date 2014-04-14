package gamescreen.gamemodel {
	import gamescreen.GameConf;

	import org.osflash.signals.Signal;
	/**
	 * @author damrem
	 */
	public class Column 
	{
		static private var DBG:Boolean = true;
		
		private var cells:Vector.<uint>;
		private var onOverFilled:Signal = new Signal();
		
		function Column()
		{
			this.reset();
		}
		
		public function reset():void
		{
			this.cells = new <uint>[];
			for(var i:uint=0; i<GameConf.NB_ROWS; i++)
			{
				this.cells[i] = 0;
			}
		}
		
		public function get(row:uint):uint
		{
			return this.cells[row];
		}
		
		public function getLowestFreeRow():int
		{
			if(DBG)	trace(this+"getLowestFreeRow(");
			
			for(var i:uint=this.cells.length; i>0; i--)
			{
				var j:uint = i-1;
				var type:uint = this.cells[j];
				if(type == 0)	return j;
			}
			 
			 /*
			for(var i:uint=0; i<this.cells.length; i++)
			{
				var type:uint = this.cells[i];
				if(type == 0)	return i;
			}
			 
			 */
			return -1;
		}
		
		public function add(type:uint):void
		{
			var lowest:int = this.getLowestFreeRow();
			if(lowest < 0)
			{
				this.onOverFilled.dispatch();
				return;
			}
			this.cells[lowest] = type;
		}
		
		public function getOnOverFilled():Signal
		{
			return this.onOverFilled;
		}
		
	}
}
