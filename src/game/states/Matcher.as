package game.states 
{
	import game.Board;
	import game.Pawn;
	import org.osflash.signals.Signal;
	/**
	 * Controller which detects matches.
	 * @author damrem
	 */
	public class Matcher extends AbstractState
	{
		public static var verbose:Boolean;
		
		public const NO_MATCHES_FOUND:Signal = new Signal();
		public const MATCHES_FOUND:Signal = new Signal();
		public const INVALID_SWAP:Signal = new Signal();
		
		public function Matcher(board:Board) 
		{
			if (verbose)	trace(this + "Matcher(" + arguments);
			
			super(board);
		}
		
		override public function enter(caller:String="other"):void
		{
			if (verbose)	trace(this + "enter(" + arguments);
			
			//	if no pawns have to be checked, we consider and dispatch that there's no matches found
			if (this.board.matchablePawns.length == 0)
			{
				if (verbose)	trace("NO MATCHES because no matchable pawns");
				this.NO_MATCHES_FOUND.dispatch("matcher.enter with no matchables");
				return;
			}
			
			//	we check if there are matches
			//	for each matchable pawn
			var areMatchesFound:Boolean;	//	we will dispatch only if any of the matchable pawns is part of a match
			for (var i:int = 0; i < this.board.matchablePawns.length;i++ )
			{
				var pawn:Pawn = this.board.matchablePawns[i];
				
				var onePawnMatches:Vector.<Vector.<Pawn>> = this.getMatches(pawn);
				
				if (verbose)	if(onePawnMatches.length)	trace(this+"matches for "+pawn+":" + onePawnMatches);
				
				//	if there's at least 1 match (vertical and/or horizontal)
				//	we will dispatch it, and we elect the pawns for later destruction
				if (onePawnMatches.length)
				{
					areMatchesFound = true;
					
					this.electMatchesForDestruction(onePawnMatches);
				}
			}
			
			if(verbose)	trace(this+"matchables: " + this.board.matchablePawns);
			
			//	swap check and no matches
			if (this.board.matchablePawns.length == 2 && !areMatchesFound)
			{
				if (verbose)	trace(this+"swap check and no matches");
				this.board.electPawnsForSwapping(this.board.matchablePawns[0], this.board.matchablePawns[1]);
				this.board.resetMatchablePawns();
				this.INVALID_SWAP.dispatch(true);
			}

			//	global check and no matches
			else if (this.board.matchablePawns.length > 2 && !areMatchesFound)
			{
				if (verbose)	trace(this+"global check and no matches");
				this.board.resetMatchablePawns();
				this.NO_MATCHES_FOUND.dispatch("matcher.enter with no matches on board");
			}
			
			//	any check and matches found
			else if (areMatchesFound)
			{
				if (verbose)	trace(this+"any check and matches found");
				this.board.resetMatchablePawns();
				this.MATCHES_FOUND.dispatch();
			}
		}
		
		private function electMatchesForDestruction(matches:Vector.<Vector.<Pawn>>):void
		{
			if (verbose)	trace(this + "electMatchesForDestruction(" + arguments);
			
			//	for each match of the set of matches
			for (var i:int = 0; i < matches.length; i++)
			{
				//	for each pawn of the match
				var match:Vector.<Pawn> = matches[i];
				for (var j:int = 0; j < match.length; j++)
				{
					var pawn:Pawn = match[j];
					if (this.board.destroyablePawns.indexOf(pawn) < 0)
					{
						this.board.destroyablePawns.push(match[j]);
					}
				}
			}
			
			if(verbose)	trace("destroyables: " + this.board.destroyablePawns);
		}
		
		/**
		 * TODO Unit test me!
		 * @param	pawn
		 * @return	The pawns matching the specified pawn. It's a vector, containing a vector of vectors of pawns: the horizontal match and the vertical match (if they're at least 3-long).
		 */
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

		/**
		 * TODO Unit test me!
		 * @param	pawn
		 * @return	The pawns horizontally matching the specified pawn, whatever the length (1 if no actual match).
		 */
		private function getHorizontalMatch(pawn:Pawn):Vector.<Pawn>
		{
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
		
		/**
		 * TODO Unit test me!
		 * @param	pawn
		 * @return	The pawns vertically matching the specified pawn, whatever the length (1 if no actual match).
		 */
		private function getVerticalMatch(pawn:Pawn):Vector.<Pawn>
		{
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
		
		override public function exit(caller:String="other"):void
		{
			if (verbose)	trace(this + "exit(" + arguments);
		}
	}

}