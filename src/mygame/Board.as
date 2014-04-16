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
		
		public static const WIDTH:int = 3;
		public static const HEIGHT:int = 3;
		
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
		 * Pawns currently being destroyed.
		 */
		public var destroyingPawns:Vector.<Pawn>;
		
		/**
		 * Pawns about to start moving.
		 */
		public var movablePawns:Vector.<Pawn>;
		/**
		 * Pawns currently moving.
		 */
		public var movingPawns:Vector.<Pawn>;
		
		
		public function Board() 
		{
			if(verbose)	trace(this + "Board(" + arguments);
			this.pawns = new <Pawn>[];
			this.destroyablePawns = new <Pawn>[];
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
		
		public function getUpperPawn(refPawn:Pawn):Pawn
		{
			if (refPawn.index < WIDTH)
			{
				return null;
			}
			return this.pawns[refPawn.index - WIDTH];
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
		
		public function movePawnTo(movingPawn:Pawn, index:int, onComplete:Function = null, onCompleteArgs:Array = null):void
		{
			if (verbose)	trace(this + "movePawnTo(" + arguments);
			
			movingPawn.moveTo(this.indexToXY(index), onComplete, onCompleteArgs);
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
		
		public function positionPawn(pawn:Pawn, destinationIndex:int):void 
		{
			if (verbose)	trace(this + "positionPawn(" + arguments);
			
			var originIndex:int = pawn.index;
			/*
			this.pawns[destinationIndex].sleep();
			this.pawns[destinationIndex] = pawn;
			pawn.index = destinationIndex;
			
			this.pawns[originIndex] = null;
			*/
		}
		
		
		
	}

}