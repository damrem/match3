package mygame.states 
{
	import mygame.Board;
	import mygame.Pawn;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author damrem
	 */
	public class Matcher extends AbstractState
	{
		public static var verbose:Boolean;
		
		public const NO_MATCHES_FOUND:Signal = new Signal();
		public const MATCHES_FOUND:Signal = new Signal();
		
		public function Matcher(board:Board) 
		{
			super(board);
		}
		
		override public function enter():void
		{
			if (verbose)	trace(this + "enter(" + arguments);
			
			//if (verbose)	trace("matchables: " + this.board.matchablePawns);
			
			//	we will dispatch only if any of the matchable pawns is part of a match
			var mustDispatchMatches:Boolean;
			
			if (this.board.matchablePawns.length == 0)
			{
				if (verbose)	trace("no matches");
				this.NO_MATCHES_FOUND.dispatch();
				return;
			}
			else
			{
				//	for each matchable pawn
				for (var i:int = 0; i < this.board.matchablePawns.length;i++ )
				{
					var pawn:Pawn = this.board.matchablePawns[i];
					//	if there's at least 1 match on both axis, we register it to dispatch the match(es) later
					var onePawnMatches:Vector.<Vector.<Pawn>> = this.getMatches(pawn);
					
					if (verbose)	trace(pawn+":" + onePawnMatches);
					
					if (onePawnMatches.length)
					{
						mustDispatchMatches = true;
						
						this.electMatchesForDestruction(onePawnMatches);
						
						//if (verbose)	trace("matches");
					}
				}
				this.board.resetMatchablePawns();
				
				if (mustDispatchMatches)
				{
					this.MATCHES_FOUND.dispatch();
				}
				else
				{
					this.NO_MATCHES_FOUND.dispatch();
				}
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
			//if(verbose)	trace("l:"+l);
			
			if (l && l.type == pawn.type)
			{
				match.push(l);
				
				var ll:Pawn = this.board.getLeftPawn(l);
				//if(verbose)	trace("ll:"+ll);
				
				if (ll && ll.type == pawn.type)
				{
					match.push(ll);
				}
			}
			var r:Pawn = this.board.getRightPawn(pawn);
			//if(verbose)	trace("r:" + r);
			if (r && r.type == pawn.type)
			{
				match.push(r);
				var rr:Pawn = this.board.getRightPawn(r);
				//if(verbose)	trace("rr:" + rr);
				if (rr && rr.type == pawn.type)
				{
					match.push(rr);
				}
			}
			if (verbose)	trace("horizontal: " + match);
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
			if (verbose)	trace("vertical: " + match);
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
			if (verbose)	trace(this + "exit(" + arguments);
			if (verbose)	trace(this.board.pawns);
		}
	}

}