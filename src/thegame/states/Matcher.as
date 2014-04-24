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
			
			//	we will dispatch only if any of the matchable pawns is part of a match
			var mustDispatchMatches:Boolean;
			
			if (this.board.matchablePawns.length == 0)
			{
				if (verbose)	trace("NO MATCHES");
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
					
					if (verbose)	if(onePawnMatches.length)	trace(this+"matches for "+pawn+":" + onePawnMatches);
					
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
					if (verbose)	trace("MATCHES FOUND");
					this.MATCHES_FOUND.dispatch();
				}
				else
				{
					if (verbose)	trace("NO MATCHES");
					this.NO_MATCHES_FOUND.dispatch();
				}
			}
		}
		
		private function electMatchesForDestruction(matches:Vector.<Vector.<Pawn>>):void
		{
			if (verbose)	trace(this + "electMatchesForDestruction(" + arguments);
			
			//	we will deduplicate the destroyable pawns
			//var deduplicatedDestroyablePawns:Dictionary = new Dictionary();
			
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
					
					//	we register the pawn at its own index in order to deduplicate it
					//deduplicatedDestroyablePawns[pawn.index] = pawn;
				}
			}
			//if(verbose)	trace(this, "deduplicated: " + ToString.dictionary(deduplicatedDestroyablePawns));
			
			//	we deduplicate the destroyables
			/*
			var deduplicated:Dictionary = new Dictionary();
			for (var k:int = 0; k < this.board.destroyablePawns.length; k++)
			{
				var pawn:Pawn = this.board.destroyablePawns[k];
				deduplicated[pawn.index] = pawn;
			}
			*/
			//trace("--------dedup");
			/*
			for (var index:String in deduplicatedDestroyablePawns)
			{
				//trace(prop + ":" + deduplicated[prop]);
				this.board.destroyablePawns.push(deduplicatedDestroyablePawns[index]);
				
			}
			*/
			if(verbose)	trace("destroyables: " + this.board.destroyablePawns);
			//trace("dedup--------");
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