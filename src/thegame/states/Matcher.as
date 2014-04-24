package thegame.states 
{
	import flash.utils.Dictionary;
	import thegame.Board;
	import thegame.Pawn;
	import org.osflash.signals.Signal;
	import utils.ToString;
	/**
	 * ...
	 * @author damrem
	 */
	public class Matcher extends AbstractState
	{
		public static var verbose:Boolean;
		
		public const NO_MATCHES_FOUND:Signal = new Signal();
		public const MATCHES_FOUND:Signal = new Signal();
		public const INVALID_SWAP:Signal = new Signal();
		
		/**
		 * The context  within which we check matchings.
		 */
		/*
		public var matchingContext:int;
		public static const FILL:int = 0;
		public static const SWAP:int = 1;
		*/
		
		public function Matcher(board:Board) 
		{
			super(board);
		}
		
		override public function enter():void
		{
			if (verbose)	trace(this + "enter(" + arguments);
			
			//	if no pawns have to be checked, we consider and dispatch that there's no matches found
			if (this.board.matchablePawns.length == 0)
			{
				if (verbose)	trace("NO MATCHES because no matchable pawns");
				this.NO_MATCHES_FOUND.dispatch();
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
			
			trace(this+"matchables: " + this.board.matchablePawns);
			
			//	swap check and no matches
			if (this.board.matchablePawns.length == 2 && !areMatchesFound)
			{
				if (verbose)	trace(this+"swap check and no matches");
				this.board.electPawnsForSwapping(this.board.matchablePawns[0], this.board.matchablePawns[1]);
				//this.board.electPawnsForSwappingswappablePawns[0] = this.board.matchablePawns[0];
				//this.board.swappablePawns[1] = this.board.matchablePawns[1];
				this.board.resetMatchablePawns();
				this.INVALID_SWAP.dispatch(true);
			}

			//	global check and no matches
			else if (this.board.matchablePawns.length > 2 && !areMatchesFound)
			{
				if (verbose)	trace(this+"global check and no matches");
				this.board.resetMatchablePawns();
				this.NO_MATCHES_FOUND.dispatch();
			}
			
			//	any check and matches found
			else if (areMatchesFound)
			{
				if (verbose)	trace(this+"any check and matches found");
				this.board.resetMatchablePawns();
				this.MATCHES_FOUND.dispatch();
			}
			
			
			
			
			/*
			//	if pawns (the 2 swapped, or all the board) have to be checked, 
			//	we check them and elect the matching one for destruction
			else
			{
				
				
				//	if it's a swap (2 matchables only) and no match are found, we elect them for swapping again.
				if (!areMatchesFound && this.board.matchablePawns.length == 2)
				{
					if(verbose)	trace(this + "INVALID SWAP");
					this.board.swappablePawns[0] = this.board.matchablePawns[0];
					this.board.swappablePawns[1] = this.board.matchablePawns[1];
					this.INVALID_SWAP.dispatch();
				}
				
				this.board.resetMatchablePawns();
				
				if (areMatchesFound)
				{
					if (verbose)	trace("MATCHES FOUND");
					this.MATCHES_FOUND.dispatch();
				}
				else
				{
					if (verbose)	trace("NO MATCHES because of invalid swap");
					
					this.NO_MATCHES_FOUND.dispatch();
				}
			}
			*/
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
			//if (verbose)	trace(this + "getHorizontalMatch(" + arguments);
			
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
			//if (verbose)	trace("horizontal: " + match);
			return match;
		}
		
		private function getVerticalMatch(pawn:Pawn):Vector.<Pawn>
		{
			//if (verbose)	trace(this + "getVerticalMatch(" + arguments);
			
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
			//if (verbose)	trace("vertical: " + match);
			return match;
		}
		
		override public function update():void
		{
			
		}
		
		override public function exit():void
		{
			if (verbose)	trace(this + "exit(" + arguments);
			//if (verbose)	trace(this.board.pawns);
		}
	}

}