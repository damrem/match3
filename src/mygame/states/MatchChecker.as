package mygame.states 
{
	import mygame.Board;
	import mygame.Pawn;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author damrem
	 */
	public class MatchChecker extends AbstractState
	{
		public static var verbose:Boolean;
		
		public const NO_MATCHES:Signal = new Signal();
		public const MATCHES:Signal = new Signal();
		
		public function MatchChecker(board:Board) 
		{
			super(board);
		}
		
		override public function enter():void
		{
			if (verbose)	trace(this + "enter(" + arguments);
			
			if (verbose)	trace("matchables: "+this.board.matchablePawns);
			if (this.board.matchablePawns.length == 0)
			{
				if (verbose)	trace("no matches");
				this.NO_MATCHES.dispatch();
				return;
			}
			else
			{
				for (var i:int = 0; i < this.board.matchablePawns.length;i++ )
				{
					var pawn:Pawn = this.board.matchablePawns[i];
					//	if there's at least 1 match on both axis, we dispatch the match(es)
					var matches:Vector.<Vector.<Pawn>> = this.getMatches(pawn);
					if (matches.length)
					{
						this.electMatchesForDestruction(matches);
						
						if (verbose)	trace("matches");
						this.MATCHES.dispatch(matches);
					}
				}
				this.board.resetMatchablePawns();
				this.NO_MATCHES.dispatch();
			}
		}
		
		private function electMatchesForDestruction(matches:Vector.<Vector.<Pawn>>):void
		{
			for (var i:int = 0; i < matches.length; i++)
			{
				var match:Vector.<Pawn> = matches[i];
				for (var j:int = 0; j < match.length; j++)
				{
					this.board.destroyablePawns.push(match[j]);
				}
			}
		}
		
		private function getMatches(pawn:Pawn):Vector.<Vector.<Pawn>>
		{
			var hMatch:Vector.<Pawn> = this.getHorizontalMatch(pawn);
			var vMatch:Vector.<Pawn> = this.getVerticalMatch(pawn);
			
			var matches:Vector.<Vector.<Pawn>> = new < Vector.<Pawn> > [];
			//	the matches are valid only if they're at least 3 pawn-long.
			if (hMatch.length >= 3)	matches.push(hMatch);
			if (vMatch.length >= 3)	matches.push(vMatch);
			
			return matches;
			
		}
		
		private function getHorizontalMatch(pawn:Pawn):Vector.<Pawn>
		{
			if (verbose)	trace(this + "getHorizontalMatch(" + arguments);
			
			var match:Vector.<Pawn> = new <Pawn>[];
			match.push(pawn);
			var l:Pawn = this.board.getLeftPawn(pawn);
			if (l && l.type == pawn.type)
			{
				match.push(l);
				var ll:Pawn = this.board.getLeftPawn(l);
				if (ll && ll.type == pawn.type)
				{
					match.push(ll);
				}
			}
			var r:Pawn = this.board.getRightPawn(pawn);
			if (r && r.type == pawn.type)
			{
				match.push(r);
				var rr:Pawn = this.board.getRightPawn(r);
				if (rr && rr.type == pawn.type)
				{
					match.push(rr);
				}
			}
			return match;
		}
		
		private function getVerticalMatch(pawn:Pawn):Vector.<Pawn>
		{
			if (verbose)	trace(this + "getVerticalMatch(" + arguments);
			
			var match:Vector.<Pawn> = new <Pawn>[];
			match.push(pawn);
			
			var t:Pawn = this.board.getTopPawn(pawn);
			if (t && t.type == pawn.type)
			{
				match.push(t);
				var tt:Pawn = this.board.getTopPawn(t);
				if (tt && tt.type == pawn.type)
				{
					match.push(tt);
				}
			}
			var b:Pawn = this.board.getBottomPawn(pawn);
			if (b && b.type == pawn.type)
			{
				match.push(b);
				var bb:Pawn = this.board.getBottomPawn(b);
				if (bb && bb.type == pawn.type)
				{
					match.push(bb);
				}
			}
			return match;
		}
		
		/*
		private function checkMatchesInRowFromIndex(index:int):void
		{
			var matches:Vector.<Vector.<Pawn>> = new <Vector.<Pawn>>[];
			var match:Vector.<Pawn> = new <Pawn>[];
			var row:int = this.board.getRowFromIndex(index);
			//	for each pawn of the row
			for (var i:int = row * Board.WIDTH; i < (row + 1) * Board.WIDTH; i++)
			{
				var pawn:Pawn = this.board[i];
				//	if the match is empty or if the pawn matches the match type
				if (match.length == 0 || pawn == match[0])
				{
					match.push(pawn);
				}
				else 
			}
		}
		*/
		
		override public function update():void
		{
			
		}
		
		override public function exit():void
		{
			
		}
	}

}