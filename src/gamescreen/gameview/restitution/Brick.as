package gamescreen.gameview.restitution {
	import gamescreen.GameConf;

	import starling.display.Shape;

	import utils.debug.Dbg;
	/**
	 * @author damrem
	 */
	public class Brick extends Shape
	{
		private var type:uint, col:uint, row:uint;
		
		public static var SIZE:uint;
		
		function Brick(type:uint)
		{
			super();
			Dbg.t("new "+this+"("+arguments);
			
			this.type = type;
		
			this.graphics.beginFill(GameConf.COLORS[this.type]);
			this.graphics.lineStyle(1.0, 0x000000, 0.5);
			this.graphics.drawRect(0, 0, SIZE - 2.0, SIZE - 2.0);
		}
		
		public function toString() : String {
			return "[object Brick (type="+this.type+")]";
		}
		
		public function getCol():uint
		{
			return this.col;
		}
		
		public function setCol(col:uint):void
		{
			this.col = col;
		}
		
		public function getRow():uint
		{
			return this.row;
		}
		
		public function setRow(row:uint):void
		{
			this.row = row;
		}
		
		static public function vector_getCopy(original:Vector.<Brick>):Vector.<Brick>
		{
			var copy:Vector.<Brick> = new <Brick>[];
			for(var i:uint=0; i<original.length; i++)
			{
				copy[i] = original[i];
			}
			return copy;
		}
	}
}
