package mygame 
{
	import flash.geom.Point;
	import starling.animation.Tween;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author damrem
	 */
	public class Board extends Sprite
	{
		public static var verbose:Boolean;
		
		public static const WIDTH:int = 4;
		public static const HEIGHT:int = 4;
		
		/**
		 * Pawns on the board.
		 */
		public var pawns:Vector.<Pawn>;
		
		/**
		 * List of the empty indexes on the board.
		 */
		public var holes:Vector.<int>;
		
		/**
		 * Pawns about to be destroyed.
		 */
		public var destroyablePawns:Vector.<Pawn>;
		
		/**
		 * Pawns about to start moving.
		 */
		public var fallablePawns:Vector.<Pawn>;
		
		
		public function Board() 
		{
			if (verbose)	trace(this + "Board(" + arguments);
			
			this.y = 135;
			
			this.pawns = new <Pawn>[];
			this.resetHoles();
			this.resetFallablePawns();
			this.resetDestroyablePawns();
			
			this.fill();
		}
		
		//	TODO no matches
		public function fill():void
		{
			if(verbose)	trace(this + "fill(" + arguments);
			for(var i:int = 0; i < WIDTH * HEIGHT; i++)
			{
				var pawn:Pawn = new Pawn(i);
				pawn.x = (i % WIDTH) * Pawn.SIZE;
				var row:int = i / HEIGHT;
				pawn.y = row * Pawn.SIZE;
				this.pawns[i] = pawn;
				this.addChild(pawn);
			}
			
		}
		
		public function get isFull():Boolean
		{
			for (var i:int = 0; i < this.pawns.length; i++)
			{
				if (!pawns[i])
				{
					return false;
				}
			}
			return true;
		}
		
		public function getAbovePawnByPawn(refPawn:Pawn):Pawn
		{
			if (refPawn.index < WIDTH)
			{
				return null;
			}
			return this.pawns[refPawn.index - WIDTH];
		}
		
		/** 
		 * @param	holeIndex
		 * @return	the pawn which is supposed to fall into the hole; null if there is none.
		 */
		public function getPawnAboveHole(holeIndex:int):Pawn 
		{
			var pawnAboveHole:Pawn;
			
			//	if we're checking a hole on the top row, there's no pawn above
			if (holeIndex < WIDTH)
			{
				return null;
			}
			
			while (holeIndex >= WIDTH)
			{
				pawnAboveHole = this.pawns[holeIndex - WIDTH];
				if (pawnAboveHole)
				{
					return pawnAboveHole;
				}
				else
				{
					holeIndex -= WIDTH;
				}
			}
			//	ultimately, we did not find any pawn above
			return null;
		}
		
		public function getBottomPawn(refPawn:Pawn):Pawn
		{
			if (verbose)	trace(this + "getLowerPawn(" + arguments);
			
			if (refPawn.index >= (HEIGHT - 1) * WIDTH)
			{
				return null;
			}
			return this.pawns[refPawn.index + WIDTH];
		}
		
		public function getBottomIndex(pawn:Pawn):int
		{
			return pawn.index + WIDTH;
		}
		
		public function getLeftPawn(refPawn:Pawn):Pawn
		{
			if (refPawn.index % WIDTH == 0)
			{
				return null;
			}
			return this.pawns[refPawn.index - 1];
		}
		
		public function getRightPawn(refPawn:Pawn):Pawn
		{
			if (refPawn.index % WIDTH == WIDTH - 1)
			{
				return null;
			}
			return this.pawns[refPawn.index + 1];
		}
		
		public function indexToCol(index:int):int
		{
			return index % WIDTH;
		}
		
		public function indexToRow(index:int):int
		{
			var row:int = index / WIDTH;
			return row;
		}
		
		public function colToX(col:int):Number
		{
			return col * Pawn.SIZE;
		}
		
		public function rowToY(row:int):Number
		{
			return row * Pawn.SIZE;
		}
		
		public function indexToXY(index:int):Point
		{
			return new Point(colToX(indexToCol(index)), rowToY(indexToRow(index)));
		}
		
		/**
		 * Elects the pawn for tween movement by setting its new index and registering the pawn as movable.
		 * @param	pawn
		 * @param	destIndex
		 */
		public function electPawnForFalling(pawn:Pawn, destIndex:int):void 
		{
			if (verbose)	trace(this + "electPawnForFalling(" + arguments);
			
			//	sets the new index
			this.setPawnIndex(pawn, destIndex);
			
			//	elects the pawn for tween movement (handled by the PawnMover class)
			this.fallablePawns.push(pawn);
		}
		
		/**
		 * Remove the pawn from its origin index and put it in the destination index.
		 * @param	pawn
		 * @param	destIndex
		 */
		public function setPawnIndex(pawn:Pawn, destIndex:int):void
		{
			if (verbose)	trace(this + "setPawnIndex(" + arguments);
			
			this.pawns[pawn.index] = null;
			this.pawns[destIndex] = pawn;
			pawn.index = destIndex;
		}
		
		/**
		 * Empty the holes structure. Called when all the holes have been handled by Fall.
		 */
		public function resetHoles():void
		{
			if (verbose)	trace(this + "resetHoles(" + arguments);
			
			this.holes = new <int>[];
		}
		
		public function resetFallablePawns():void 
		{
			if (verbose)	trace(this + "resetFallablePawns(" + arguments);
			
			this.fallablePawns = new <Pawn>[];
		}
		
		public function resetDestroyablePawns():void 
		{
			if (verbose)	trace(this + "resetDestroyablePawns(" + arguments);
			
			this.destroyablePawns = new <Pawn>[];
		}
		
		public function electPawnForDestruction(pawn:Pawn):void
		{
			if (verbose)	trace(this + "electPawnForDestruction(" + arguments);
			
			this.destroyablePawns.push(pawn);
		}
		
		
		
	}

}