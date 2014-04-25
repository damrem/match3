package game 
{
	/**
	 * ...
	 * @author damrem
	 */
	public class PawnPool 
	{
		public static var verbose:Boolean;
		
		private static var pawns:Vector.<Pawn>;
		private static var _instance:PawnPool;
		
		function PawnPool(length:uint=128) 
		{
			PawnPool.pawns = new <Pawn>[];
			for (var i:int = 0; i < length; i++) 
			{
				PawnPool.pawns.push(new Pawn());
			}
			if (!PawnPool._instance) PawnPool._instance = this;
		}
		
		static public function loadPawn(i:uint):Pawn
		{
			if (verbose)	trace(PawnPool + "loadPawn(" + arguments);
			
			PawnPool.instance;
			
			var pawn:Pawn = PawnPool.pawns.shift();
			pawn.setIndex(i);
			pawn.reset();
			
			if (verbose)	trace("nb pawns in pool: " + pawns.length);
			
			return pawn;
		}
		
		static public function savePawn(pawn:Pawn):void
		{
			if (verbose)	trace(PawnPool + "savePawn(" + arguments);
			
			PawnPool.instance;
			pawn.remove();
			PawnPool.pawns.push(pawn);
			
			if (verbose)	trace("nb pawns in pool: " + pawns.length);
		}
		
		static public function get instance():PawnPool 
		{
			if (!PawnPool._instance)
			{
				new PawnPool();
			}
			return PawnPool._instance;
		}
		
	}

}