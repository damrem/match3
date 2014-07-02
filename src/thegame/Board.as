package thegame
{
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	

	public class Board extends Sprite
	{
		public static var verbose:Boolean;
		
		public static const MAX_COLS:int = 8;
		public static const MAX_ROWS:int = 8;
		
		public static const X_OFFSET:Number = 325;
		public static const Y_OFFSET:Number = 95;
		
		public static const GEM_WIDTH:Number = 45
		public static const GEM_HEIGHT:Number = 45;
		
		private var allgems:Vector.<Gem>;
		private var gempool:GemPool;
		
		public static const NO_MATCH:String = "NoMatchEvent";
		private var clicksLeft:int = 3;
		
		private var _running:Boolean;
		public function get running():Boolean { return _running; }
		
		public function set running(value:Boolean):void
		{
			if (_running == value)
				return;
			_running = value;
			
			if (running == false)
				clicksLeft = 3;
		}
		
		
		public function Board()
		{
			//creating the gems
			allgems = new Vector.<Gem>;
			allgems.length = Board.MAX_COLS * Board.MAX_ROWS;
			allgems.fixed = true;
			
			//create and fill the pool 
			gempool = new GemPool(allgems.length);
			for (var n:int = 0; n < allgems.length; n++)
				gempool.addGem(new Gem());
			
			for (var i:int = 0; i < Board.MAX_ROWS; i++)
			{
				for (var j:int = 0; j < Board.MAX_COLS; j++)
				{
					var g:Gem = gempool.getGem();
					g.addEventListener(Gem.GEM_TOUCHED, gemTouched);
					g.addEventListener(Gem.GEM_SWIPED, gemSwiped);
					g.addEventListener(Gem.GEM_MOVED, gemMoved);
					
					putGemAtRowCol(g, i, j);
					
					g.x = X_OFFSET + j * GEM_WIDTH;
					g.y = Y_OFFSET + i * GEM_HEIGHT;
					
					addChild (g);
				}
			}
			
			//until a no match level is made successfully
			var result:Boolean = false;
			
			while (!result)
				result = makeLevelHaveNoMatch();
		}
		
		private function makeLevelHaveNoMatch():Boolean
		{
			//assign a random gem to the current position
			
			//if there are 2 gems to the left, check horizontal match with left 2 gems
			//if there are 2 gems in the top, check vertical match with 2 gems in the bottom
			
			//if no match, move to next gem, else do it again
			
			for (var row:int = Board.MAX_ROWS -1 ; row > -1; row--)
			{
				for (var col:int = Board.MAX_COLS- 1; col > -1; col--)
				{
					var g:Gem = getGemAtRowCol(row, col);
					
					var match:Boolean = true;
					
					var n:int = 0;
					
					while (match && n < 100)
					{	
						if (n == 0) 
							g.randomize();
						else 
							g.cycle();
						
						match = false;
						
						//search for horizontal match at point if it has three more elements on the right
						if (col < Board.MAX_COLS - 2)
							if (checkTripletAtPoint(row, col, true, false)) match = true;
						
						//search for vertical match at point if it has three more elements on the bottom
						if (row < Board.MAX_ROWS - 2)
							if (checkTripletAtPoint(row, col, false, false)) match = true;
						
						n++;
						
						if (n == 100)
						{
							trace ("1000 !!! row : " + row + " , col : " + col);
							return false;
						}
					}
					
					//trace ("row : " + row + " , col : " + col + " has gem type " + g.gemType);
				}
			}
			
			return true;
		}
		
		private function gemMoved(e:Event):void
		{
			if(verbose)	trace(this + "gemMoved(" + arguments);
			searchForTriplets();
		}
		
		private function gemSwiped(e:Event):void
		{
			var dir:Point = e.data as Point;
			
			var fromGem:Gem = e.target as Gem;
			var toGem:Gem = getGemAtRowCol(fromGem.row + dir.y, fromGem.col + dir.x);
			
			if (toGem)
			{
				//do the swipe and run the check once after the swipe animation is complete..
				//trace ("Gem at " + (e.target as Gem).row + "," + (e.target as Gem).col + " has been swiped " + dir);
				moveGemToLocation(fromGem, toGem.row, toGem.col);
				moveGemToLocation(toGem, fromGem.row, fromGem.col, true);
				
				dir.x = fromGem.col; dir.y = fromGem.row; //reusing dir instead of another local var
				
				putGemAtRowCol(fromGem, toGem.row, toGem.col);
				putGemAtRowCol(toGem, dir.y, dir.x);				
			}
		}
		
		private function gemTouched(e:starling.events.Event):void
		{
			
//			if (running) return;
//			
//			if (clicksLeft > 0)
//			{
//				var g:Gem = e.target as Gem;
//				g.gemType = 3;
//				clicksLeft--;
//			}
			
			
		}
		
		private function putGemAtRowCol(g:Gem, row:int, col:int, fromrow:int = -1, fromcol:int = -1):void
		{
			if (g)
			{
				g.row = row;
				g.col = col;
			}
			
			if (fromrow != -1 && fromcol != -1)
				allgems[fromcol + fromrow * Board.MAX_COLS] = null;
			
			allgems[col + row * Board.MAX_COLS] = g;
		}
		
		private function getGemAtRowCol(row:int, col:int):Gem
		{
			var idx:int = col + row*Board.MAX_COLS;
			
			if (row < 0 || col < 0 || row > Board.MAX_ROWS - 1 || col > Board.MAX_COLS - 1) return null;
			
			return	(allgems[idx]) as Gem;
		}
		
		private function hasAnyMatch():Boolean
		{
			for (var row:int = 0; row < Board.MAX_ROWS; row++)
			{
				for (var col:int = 0; col < Board.MAX_COLS; col++)
				{
					//search for horizontal match at point if it has three more elements on the right
					if (col < Board.MAX_COLS - 2)
						if (checkTripletAtPoint(row, col, true, false)) 
							return true;
					
					//search for vertical match at point if it has three more elements on the bottom
					if (row < Board.MAX_ROWS - 2)
						if (checkTripletAtPoint(row, col, false, false)) 
							return true;
				}
			}
			
			return false;
		}

		private function swapAndSearch():void
		{
			if (verbose)	trace(this + "swapAndSearch(" + arguments);
			
			if (!running) return;
			
			var matchFound:Boolean = false;
			
			//loop and swap until match found, 
			outerLoop: for (var row:int = 0; row < Board.MAX_ROWS; row++)
			{
				for (var col:int = 0; col < Board.MAX_COLS; col++)
				{
					//if hori possible do it and check
					//if not, reverse
					var currentGem:Gem, nextGem:Gem;
					
					//horizontal swap check
					if ((col < Board.MAX_COLS - 1))
					{
						currentGem = getGemAtRowCol(row, col);
						nextGem = getGemAtRowCol(row, col + 1);
						
						//swap non visually
						putGemAtRowCol(currentGem, row, col + 1);
						putGemAtRowCol(nextGem, row, col);
						
						if (hasAnyMatch())
						{
							//move the gems visually
							moveGemToLocation(currentGem, row, col + 1);
							moveGemToLocation(nextGem, row, col);
							
							//set flag to say to do the usual game
							matchFound = true;
							//break loops
							break outerLoop;
						}
						else
						{
							//put them back in same place non-visually
							putGemAtRowCol(currentGem, row, col);
							putGemAtRowCol(nextGem, row, col + 1);
						}
					}
					
					//vertical swap check
					if ((row < Board.MAX_ROWS - 1))
					{
						currentGem = getGemAtRowCol(row, col);
						nextGem = getGemAtRowCol(row + 1, col);
						
						//swap non visually
						putGemAtRowCol(currentGem, row + 1, col);
						putGemAtRowCol(nextGem, row, col);

						if (hasAnyMatch())
						{
							//move the gems visually
							moveGemToLocation(currentGem, row + 1, col);
							moveGemToLocation(nextGem, row, col);
							
							//set flag to say to do the usual game
							matchFound = true;
							//break loops
							break outerLoop;
						}
						else
						{
							//put them back in same place non-visually
							putGemAtRowCol(currentGem, row, col);
							putGemAtRowCol(nextGem, row + 1, col);
						}
					}
				}
			}
			
			//when found swap visually and execute the usual game
			if (matchFound)
			{
				if(verbose)	trace(this + "matchFound in swapAndSearch(" + arguments);
				Starling.juggler.delayCall(searchForTriplets, 1.0);
			}
			//if not found stop game
			else
			{
				this.dispatchEventWith(Board.NO_MATCH);
				running = false;
			}
		}
		
		private function searchForTriplets(autorun:Boolean = false):void
		{	
			if(verbose)	trace(this + "searchForTriplets(" + arguments);
			
			var anyMatch:Boolean = false;
			
			//loop through every element, in each row, length - 2 elements should be checked for horizontal match only vertical
			//in the each column, length - 2 elements should not be checked for vertical match only horizontal
			outerLoop: for (var row:int = 0; row < Board.MAX_ROWS; row++)
			{
				for (var col:int = 0; col < Board.MAX_COLS; col++)
				{
					//search for horizontal match at point if it has three more elements on the right
					if (col < Board.MAX_COLS - 2)
						if (checkTripletAtPoint(row, col))
							anyMatch = true;
					
					//search for vertical match at point if it has three more elements on the bottom
					if (row < Board.MAX_ROWS - 2)
						if (checkTripletAtPoint(row, col, false))
							anyMatch = true;
				}
			}

			if (anyMatch)
			{
				Starling.juggler.delayCall(gemsFillGaps, 0.8);
				Starling.juggler.delayCall(dropNewGems, 1.5);
			}
			else
			{
				if (autorun)
					Starling.juggler.delayCall(swapAndSearch, 0.5);
			}
		}
		
		private function moveGemToLocation(g:Gem, row:int, col:int, userInited:Boolean = false):void
		{
			g.moveTo(
				X_OFFSET + col * GEM_WIDTH, 
				Y_OFFSET + row * GEM_HEIGHT, userInited);
		}
		
		private function locationForRowCol(row:int, col:int):Point
		{
			var p:Point = new Point();
			p.x = X_OFFSET + col * GEM_WIDTH;
			p.y = Y_OFFSET + row * GEM_HEIGHT;
			
			return p;
		}
		
		private function dropNewGems():void
		{
			if(verbose)	trace(this + "dropNewGems(" + arguments);
			//from left col to right most
			for (var n:int = 0; n < Board.MAX_COLS; n++)
			{
				var gapStarted:Boolean = false;
				
				//from bottom cell of each col to top
				for (var m:int = Board.MAX_ROWS-1; m > -1; m--)
				{
					if (!gapStarted)
					{
						if (getGemAtRowCol(m, n)) 
							continue;
						
						gapStarted = true;
					}
					
					var newgem:Gem = gempool.getGem();
					newgem.revive();
					putGemAtRowCol(newgem, m, n);
					
					//now make gem fall from top to down
					var p:Point = locationForRowCol(m, n);
					newgem.x = p.x;
					newgem.y = p.y - (Board.MAX_ROWS-2) * GEM_HEIGHT;
					moveGemToLocation(newgem, m, n);
				}
			}
			
			Starling.juggler.delayCall(searchForTriplets, 1.0);
		}
		
		private function gemsFillGaps():void
		{
			//first remove all marked gems
			for each (var g:Gem in allgems)
				if (g.marked) removeGemFromRowCol(g.row, g.col);
			
			//from left col to right most
			for (var n:int = 0; n < Board.MAX_COLS; n++)
			{
				//from bottom cell of each col to top
				EachRow: for (var m:int = Board.MAX_ROWS-1; m > -1; m--)
				{
					g = getGemAtRowCol(m, n);
					if (g) continue;
					else
					{	
						//search for a gem in the above rows, when found bring it down
						//if nothing found until top, then fill all of them with new gems
						for (var o:int = m - 1; o > -1; o--)
						{
							var sg:Gem = getGemAtRowCol(o, n);
							if (sg)
							{
								//remove gem from current position, assign new position
								//make it move
								
								putGemAtRowCol(sg, m, n, o, n);
								moveGemToLocation(sg, m, n);
								continue EachRow;
							}
						}
							
						if (o == -1)
							break EachRow;
					}
				}
			}
		}
		
		private function checkTripletAtPoint(row:int, col:int, horizontal:Boolean = true, shouldDisappear:Boolean = true):Boolean
		{
			var colInc:int = horizontal? 1:0; 
			var rowInc:int = horizontal? 0:1;
			
			var firstType:int = getGemAtRowCol(row, col).gemType;
			var matched:Boolean = true;
			
			if (!(getGemAtRowCol(row + rowInc, col + colInc).gemType == firstType))
				matched = false;
			
			if (!(getGemAtRowCol(row + (rowInc<<1), col + (colInc<<1)).gemType == firstType))
				matched = false;
			
			if (shouldDisappear && matched)
			{
				//mark for removal and do the rest
				getGemAtRowCol(row, col).disappear();
				getGemAtRowCol(row + rowInc, col + colInc).disappear();
				getGemAtRowCol(row + (rowInc<<1), col + (colInc<<1)).disappear();
			}
			
			return matched;
		}
		
		private function removeGemFromRowCol(row:int, col:int):void
		{
			gempool.addGem(getGemAtRowCol(row, col));
			putGemAtRowCol(null, row, col);
		}
		
		public function start():void
		{
			if(verbose) trace(this + "start(" + arguments);
			running = true;
			Starling.juggler.delayCall(searchForTriplets, 0.2, false);
		}
		
		public function stop():void
		{
			running = false;
		}
	}
}