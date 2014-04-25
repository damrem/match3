package game 
{
	import starling.core.Starling;
	/**
	 * ...
	 * @author damrem
	 */
	public class PawnPool 
	{
		public static var verbose:Boolean;
		
		private static var pawns:Vector.<Pawn>;
		private static var _instance:PawnPool;
		
		function PawnPool(length:uint=80) 
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
			//	since the pawns are pooled, they could be trapped in tweens, 
			//	so we remove them from the juggler
			Starling.juggler.removeTweens(pawn);
			
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