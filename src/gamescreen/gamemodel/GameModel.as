package gamescreen.gamemodel 
{
	import gamescreen.GameConf;

	import utils.Random;
	import utils.UINT;

	import com.supagrip.mvc.AbstractModel;

	import org.osflash.signals.Signal;
	/**
	 * @author damrem
	 */
	public class GameModel extends AbstractModel
	{
		public static var verbose:Boolean;
		
		private var 	standings:Vector.<Column>, 
						floatings:Vector.<uint>, nbFloatings:uint,
						fallings:Vector.<uint>;
			
		public const 	onFloatingsGenerated:Signal = new Signal(), 
						onFloatLeft:Signal = new Signal(),
						onFloatRight:Signal = new Signal(),
		
						/**
						 * Signal émis lorsqu'une brique flottante tombe.
						 */
						onFallDown:Signal = new Signal();
		
		function GameModel()
		{
			if(verbose)	trace(this + "GameModel(" + arguments);
			
			this.resetStandings();
		}
		
		override public function start():void
		{
			if(verbose)	trace(this + "start(" + arguments);
			
			this.setNbFloatings(2);
			this.generateFloatings();
		}
		
		override public function stop():void
		{
			this.stopped.dispatch();
		}
		
		private function resetStandings():void
		{
			if(verbose)	trace(this + "resetStandings(" + arguments);

			this.standings = new <Column>[];
			for(var col:uint=0; col<GameConf.NB_COLS; col++)
			{
				
				var column:Column = new Column(); 
				this.standings.push(column);
			}
			if(verbose)	trace(this.standings.length);
		}
		
		private function resetFloatings():void
		{
			if(verbose)	trace(this + "resetFloatings(" + arguments);
			
			this.floatings = new <uint>[];
			for(var col:uint=0; col<GameConf.NB_COLS; col++)
			{
				this.floatings.push(0);
			}
		}
		
		public function generateFloatings():void
		{
			if(verbose)	trace(this + "generateFloatings(" + arguments);
			
			this.resetFloatings();
			
			//	on définit les indexes des nb colonnes où l'on va ajouter des briques
			var indexes:Vector.<int> = Random.getListOfUniqueIntegers(this.nbFloatings, 0, GameConf.NB_COLS - 1);
			if(verbose)	trace("indexes = "+indexes);
			for(var i:uint=0; i<indexes.length; i++)
			{
				var col:uint = indexes[i];
				var color:uint = Random.getInteger(1, GameConf.COLORS.length - 1);
				this.floatings[col] = color;
			}
			if(verbose)	trace("floatings = " + this.floatings);
			
			this.onFloatingsGenerated.dispatch(this.floatings);
		}
		
		public function setNbFloatings(nb:uint):void
		{
			if(verbose)	trace(this + "setNbFloatings(" + arguments);
			
			if(nb > GameConf.NB_ROWS)	nb = GameConf.NB_ROWS;
			this.nbFloatings = nb;
		}
		
		public function getNbFloatings():uint
		{
			return this.nbFloatings;
		}
		
		public function fall():void
		{
			if(verbose)	trace(this + "fall(" + arguments);
			
			//	on va enregistrer quelles colonnes sont à checker
			var cols:Vector.<uint> = new <uint>[];
			
			//	les flottants deviennent tombants
			this.fallings = this.floatings;
			
			var nbFallings:uint = fallings.length;
			//	on lève un événement par brique qui tombe
			//	et on enregistre chaque brique dans sa colonne
			for(var col:uint=0; col<nbFallings; col++)
			{
				var type:uint = fallings[col]; 
				if(type)
				{
					var column:Column = this.standings[col];
					column.add(type);
					
					trace(this.standings[col]);
					this.onFallDown.dispatch(col, column.getLowestFreeRow());
					cols.push(col);
				}				 
			}
			
			if(verbose)	trace(":"+this.getFormattedStandings());
			
			//	on vérifie s'il y a des groupes à partir des colonnes où l'on a fait tomber les briques
			this.checkGroupsForCols(cols);
			
			this.generateFloatings();
		}
		
		private function getFormattedStandings():String
		{
			if(verbose)	trace(this + "getFormattedStandings(" + arguments);
			
			var stringRows:Vector.<String> = new <String>[];
			
			var row0:uint=0;
			
			for(row0; row0<GameConf.NB_ROWS; row0++)
			{
				stringRows.push("");
			}
			//trace("stringRows="+stringRows);
			
			var col:uint=0;
			var nbCols:uint = this.standings.length;
			//trace("nbCols="+nbCols);
			
			var column:Column;
			for(col; col<nbCols; col++)
			{
				column = this.standings[col];
				//trace(col+": column="+column);
				var row:uint=0;
				for(row; row<GameConf.NB_ROWS; row++)
				{
					//trace("row="+row+"->"+column.get(row));
					stringRows[row] += ""+column.get(row);
				}
				//trace("stringRows="+stringRows);
			}
			
			var stringResult:String = "";
			for(var i:uint=0; i<stringRows.length; i++)
			{
				stringResult += stringRows[i] + "\n";
			}
			return stringResult;
		}
		
		private function checkGroupsForCols(cols:Vector.<uint>):void
		{
			if(verbose)	trace(this + "checkGroupsForCols(" + arguments);
			
			//	pour chaque colonne où une brique est tombée
			for each(var col:uint in cols)
			{
				var column:Column = this.standings[col];
				if(verbose)	trace(this+"column = "+column);
				//	pour chaque cellule de la colonne
				
				var row:uint=0;
				var nbRows:uint = GameConf.NB_ROWS;
				for(row; row<nbRows; row++)
				{
					if(column.get(row))	trace(this+"group: "+this.getGroup(col, row));
				}
				 
			}
		}
		
		//TODO pousser les détections sur les cases adjacentes aux cases déjà détectées
		private function getGroup(col:uint, row:uint):Vector.<Coord>
		{
			if(verbose)	trace(this + "getGroup(" + arguments);
			
			var group:Vector.<Coord> = new <Coord>[];
			var coord:Coord = new Coord(col, row);
			group.push(coord);
			var type:uint = this.getTypeAtCoord(coord);
			if(verbose)	trace("type="+type);
			
			var left:Coord = new Coord(col - 1, row);
			var right:Coord = new Coord(col + 1, row);
			var down:Coord = new Coord(col, row + 1);			
			var up:Coord = new Coord(col, row - 1);
			
			var typeLeft:uint = this.getTypeAtCoord(left);
			var typeRight:uint = this.getTypeAtCoord(right);
			var typeDown:uint = this.getTypeAtCoord(down);
			var typeUp:uint = this.getTypeAtCoord(up);
			
			if(verbose)	trace(typeLeft, typeRight, typeDown, typeUp);
			
			if(this.getTypeAtCoord(left) == type)	group.push(left);
			if(this.getTypeAtCoord(down) == type)	group.push(down);
			if(this.getTypeAtCoord(right) == type)	group.push(right);
			
			return group;
		}
		
		private function getTypeAtCoord(coord:Coord):int
		{
			if(verbose)	trace(this + "getTypeAtCoord(" + arguments);
			if(coord.col < 0 || coord.col >= GameConf.NB_COLS 
			|| coord.row < 0 || coord.row >= GameConf.NB_ROWS)
			{
				return -1;
			}
			trace("in");
			return this.standings[coord.col].get(coord.row);
		}
		
		

		public function floatLeft():void
		{
			if(verbose)	trace(this + "floatLeft(" + arguments);
			
			var copy:Vector.<uint> = UINT.vector_getCopy(this.floatings);
			for(var col:uint=0; col<this.floatings.length; col++)
			{
				var nextCol:uint = col + 1;
				if(nextCol > GameConf.NB_COLS - 1)	nextCol = 0;
				this.floatings[col] = copy[nextCol];
			}
			if(verbose)	trace("floatings = " + floatings);
			this.onFloatLeft.dispatch(/*this.floatings*/);
			 
		}
		
		public function floatRight():void
		{
			if(verbose)	trace(this + "floatRight(" + arguments);
			var copy:Vector.<uint> = UINT.vector_getCopy(this.floatings);
			for(var col:uint=0; col<this.floatings.length; col++)
			{
				var prevCol:int = col - 1;
				if(prevCol < 0)	prevCol = GameConf.NB_COLS - 1;
				this.floatings[col] = copy[prevCol];
			}
			if(verbose)	trace("floatings = " + floatings);
			this.onFloatRight.dispatch(/*this.floatings*/);
		}
	}
}
