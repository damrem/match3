package thegame 
{
	import starling.display.DisplayObjectContainer;
	import flash.geom.Point;
	import starling.animation.Tween;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author damrem
	 */
	public class Board extends Sprite
	{
		public static var verbose:Boolean;
		
		public static var WIDTH:int = 4;
		public static var HEIGHT:int = 4;
		
		/**
		 * A display object to capture touch events.
		 */
		public var touchZone:DisplayObject;
		
		/**
		 * A container for the pawns.
		 */
		public var pawnContainer:DisplayObjectContainer;
		
		/**
		 * Pawns on the board.
		 */
		public var pawns:Vector.<Pawn>;
		
		/**
		 * List of the empty indexes on the board.
		 */
		public var holes:Vector.<int>;
		
		/**
		 * Pawns to swap.
		 */
		public var swappablePawns:Vector.<Pawn>;
		
		/**
		 * Pawns to check matches.
		 */
		public var matchablePawns:Vector.<Pawn>;
		
		/**
		 * Pawns about to be destroyed.
		 */
		public var destroyablePawns:Vector.<Pawn>;
		
		/**
		 * Pawns about to start moving.
		 */
		public var fallablePawns:Vector.<Pawn>;
		
		
		public function Board(w:int=8, h:int=8) 
		{
			if (verbose)	trace(this + "Board(" + arguments);
			
			this.pawnContainer = new Sprite();
			this.addChild(this.pawnContainer);
			
			this.touchZone = new Quad(w * Pawn.SIZE, h * Pawn.SIZE, 0x00ff0000);
			this.touchZone.alpha = 0.0;
			this.addChild(this.touchZone);
			
			WIDTH = w;
			HEIGHT = h;
			
			//this.y = 135;
			
			this.pawns = new <Pawn>[];
			this.resetHoles();
			this.resetSwappablePawns();
			this.resetMatchablePawns();
			this.resetFallablePawns();
			this.resetDestroyablePawns();
			
			//this.fill();
		}
		
		//	TODO no matches
		public function fill():void
		{
			if(verbose)	trace(this + "fill(" + arguments);
			for(var i:int = 0; i < WIDTH * HEIGHT; i++)
			{
				var pawn:Pawn = new Pawn(i);
				pawn.x = (i % WIDTH) * Pawn.SIZE;
				var row:int = Math.floor(i / WIDTH);
				pawn.y = row * Pawn.SIZE;
				this.pawns[i] = pawn;
				this.pawnContainer.addChild(pawn);
			}
			
		}
		
		public function getTopPawn(refPawn:Pawn):Pawn
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
			//if (verbose)	trace(refPawn.index + "%" + WIDTH + "=" + (refPawn.index % WIDTH));
			if (refPawn.index % WIDTH == 0)
			{
				return null;
			}
			//if (verbose)	trace("pawns[" + (refPawn.index - 1) + "]=" + this.pawns[refPawn.index - 1]);
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
		
		
		
		public function getColFromIndex(index:int):int
		{
			return index % WIDTH;
		}
		
		public function getRowFromIndex(index:int):int
		{
			var row:int = index / WIDTH;
			return row;
		}
		
		public function getXfromCol(col:int):Number
		{
			return col * Pawn.SIZE;
		}
		
		public function getColFromX(x:Number):int
		{
			return x / Pawn.SIZE;
		}
		
		public function getYfromRow(row:int):Number
		{
			return row * Pawn.SIZE;
		}
		
		public function getRowFromY(y:Number):int
		{
			return y / Pawn.SIZE;
		}
		
		public function getXYFromIndex(index:int):Point
		{
			return new Point(getXfromCol(getColFromIndex(index)), getYfromRow(getRowFromIndex(index)));
		}
		
		public function getIndexFromXY(xy:Point):int
		{
			var col:int = this.getColFromX(xy.x);
			var row:int = this.getRowFromY(xy.y);
			
			return row * WIDTH + col;
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
			this.setPawnIndex(pawn, destIndex, true);
			
			//	elects the pawn for tween movement (handled by the PawnMover class)
			this.fallablePawns.push(pawn);
		}
		
		/**
		 * Remove the pawn from its origin index and put it in the destination index.
		 * @param	pawn
		 * @param	destIndex
		 */
		public function setPawnIndex(pawn:Pawn, destIndex:int, emptyPrevIndex:Boolean):void
		{
			if (verbose)	trace(this + "setPawnIndex(" + arguments);
			
			if(emptyPrevIndex)	this.pawns[pawn.index] = null;
			this.pawns[destIndex] = pawn;
			pawn.setIndex(destIndex);
		}
		
		public function fillWithHoles():void
		{
			if (verbose)	trace(this + "fillHoles(" + arguments);
			
			this.resetHoles();
			for (var i:int = 0; i < WIDTH * HEIGHT; i++)
			{
				this.pawns.push(null);
				this.holes.push(i);
			}
		}
		
		/**
		 * Empty the holes structure. Called when all the holes have been handled by Fall.
		 */
		public function resetHoles():void
		{
			if (verbose)	trace(this + "resetHoles(" + arguments);
			
			this.holes = new <int>[];
			if (verbose)	trace("holes: " + this.holes);
		}
		
		public function resetSwappablePawns():void 
		{
			if (verbose)	trace(this + "resetSwappablePawns(" + arguments);
			
			this.swappablePawns = new <Pawn>[];
		}
		
		public function resetMatchablePawns():void 
		{
			if (verbose)	trace(this + "resetMatchablePawns(" + arguments);
			
			this.matchablePawns = new <Pawn>[];
		}
		
		public function resetDestroyablePawns():void 
		{
			if (verbose)	trace(this + "resetDestroyablePawns(" + arguments);
			
			this.destroyablePawns = new <Pawn>[];
		}
		
		public function resetFallablePawns():void 
		{
			if (verbose)	trace(this + "resetFallablePawns(" + arguments);
			
			this.fallablePawns = new <Pawn>[];
		}
		
		
		
		
		public function electPawnsForSwapping(pawn1:Pawn, pawn2:Pawn):void 
		{
			if (verbose)	trace(this + "electPawnForMatching(" + arguments);
			
			this.swappablePawns.push(pawn1);
			this.swappablePawns.push(pawn2);
		}
		
		public function electAllPawnsForMatching():void
		{
			if (verbose)	trace(this + "electAllPawnsForMatching(" + arguments);
			
			for (var i:int = 0; i < this.pawns.length; i++) 
			{
				this.electPawnForMatching(this.pawns[i]);
			}
		}
		
		public function electPawnForMatching(pawn:Pawn):void 
		{
			if (verbose)	trace(this + "electPawnForMatching(" + arguments);
			
			this.matchablePawns.push(pawn);
		}
		
		public function electPawnForDestruction(pawn:Pawn):void
		{
			if (verbose)	trace(this + "electPawnForDestruction(" + arguments);
			
			this.destroyablePawns.push(pawn);
		}
		
		
		
		
		
		public function arePawnsNeighbors(pawn1:Pawn, pawn2:Pawn):Boolean
		{
			return (pawn1 == this.getLeftPawn(pawn2) || pawn1 == this.getRightPawn(pawn2) || pawn1 == this.getTopPawn(pawn2) || pawn1 == this.getBottomPawn(pawn2))
		}
		
		
		
	}

}