package gamescreen.gamemodel {
	/**
	 * @author damrem
	 */
	public class Coord 
	{
		public var
			col:uint,
			row:uint;
			
		function Coord(col:uint, row:uint)
		{
			this.col = col;
			this.row = row;
		}
		
		public function toString():String
		{
			return "[Coord (col="+this.col+",row="+row+")]";
		}
	}
}
