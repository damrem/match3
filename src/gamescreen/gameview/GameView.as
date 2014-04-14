package gamescreen.gameview 
{
	import fl.motion.easing.Linear;
	import fl.transitions.Tween;

	import gamescreen.GameConf;
	import gamescreen.gamemodel.GameModel;
	import gamescreen.gameview.restitution.Brick;

	import starling.events.Event;

	import utils.TweenManager;

	import com.supagrip.mvc.AbstractView;

	/**
	 * @author damrem
	 */
	public class GameView extends AbstractView
	{
		public static var verbose:Boolean;
		
		private var fullModel:GameModel;
		
		private var 
			fallingBricks:Vector.<Brick>,
			standingBricks:Vector.<Brick>;
			
		private var tweenManager:TweenManager = new TweenManager();
		
		public function GameView(gameModel:GameModel)
		{
			if(verbose)	trace(this + "GameView(" + arguments);
			
			this.tweenManager.DBG = verbose;
			
			super(gameModel);
			this.fullModel = gameModel;
			
			Brick.SIZE = Main.STAGE_WIDTH / GameConf.NB_COLS;
			
			this.resetFallingBricks();
			this.standingBricks = new <Brick>[];
			
			this.addEventListener(Event.ADDED_TO_STAGE, this.onStage);
		}

		private function onStage(event : Event) : void 
		{
			if(verbose)	trace(this + "onStage(" + event);
		}
		
		override public function start():void
		{
			if(verbose)	trace(this + "start(" + arguments);
			
			this.fullModel.onFloatingsGenerated.add(this.generateBricks);
			this.fullModel.onFallDown.add(this.fallDown);
			this.fullModel.onFloatLeft.add(this.floatLeft);
			this.fullModel.onFloatRight.add(this.floatRight);
		}
		
		override public function stop():void
		{
			this.stopped.dispatch();
		}
		
		private function resetFallingBricks():void
		{
			if(verbose)	trace(this + "resetFallingBricks(" + arguments);
			
			this.fallingBricks = new <Brick>[];
		}
		
		public function generateBricks(floatings:Vector.<uint>):void
		{
			if(verbose)	trace(this + "generateBricks(" + arguments);
			this.resetFallingBricks();
			var nbCols:uint = floatings.length;
			if(verbose)	trace("floatings = "+floatings);
			
			for(var col:uint=0; col<nbCols; col++)
			{
				var type:uint = floatings[col];
				if(type > 0)
				{
					var brick:Brick = new Brick(type);
					brick.x = col * Brick.SIZE;
					this.addChild(brick);
					this.fallingBricks.push(brick);
				}
				else
				{
					this.fallingBricks.push(null);
				}
			}	 
			if(verbose)	trace(this.fallingBricks);
		}
		
		
		public function fallDown(col:uint, row:uint):void
		{
			if(verbose)	trace(this+"fallDown("+arguments);
			if(verbose)	trace(this.fallingBricks);
			if(verbose)	trace(this.fallingBricks[col]);
			var brick:Brick = this.fallingBricks[col];
			var begin:Number = this.fallingBricks[col].y;
			var finish:Number = (row + 1) * Brick.SIZE;
			var duration:Number = (finish - begin) / GameConf.FALLING_SPEED_PX_PER_SEC;
			if(verbose)	trace("duration = "+duration);
			
			var tween_fall:Tween = new Tween(brick, "y", Linear.easeNone, begin, finish, duration, true);
			this.tweenManager.registerShortLivedTween(tween_fall);
			tween_fall.start();
		}
		
		
		
		/**
		 * Décale les briques flottantes vers la gauche.
		 */
		public function floatLeft():void
		{
			if(verbose)	trace(this + "floatLeft(" + arguments);
			
			var nbCols:uint = this.fallingBricks.length;
			var copy:Vector.<Brick> = Brick.vector_getCopy(this.fallingBricks);
			for(var col:uint=0; col<nbCols; col++)
			{
				var nextCol:uint = col + 1;
				if(nextCol > GameConf.NB_COLS - 1)	nextCol = 0;
				this.fallingBricks[col] = copy[nextCol];
				
				var brick:Brick = fallingBricks[col];
				if(brick)
				{
					var begin:Number = this.fallingBricks[col].x;
					var finish:Number = col * Brick.SIZE;
					var duration:Number = Math.abs(finish - begin) / GameConf.FALLING_SPEED_PX_PER_SEC;
					if(verbose)	trace("duration = "+duration);
					
					var tween_float:Tween = new Tween(brick, "x", Linear.easeNone, begin, finish, duration, true);
					this.tweenManager.registerShortLivedTween(tween_float);
					tween_float.start();
				}
			}
		}
		
		/**
		 * Décale les briques flottantes vers la droite.
		 */
		public function floatRight():void
		{
			if(verbose)	trace(this+"floatRight("+arguments);
			var nbCols:uint = this.fallingBricks.length;
			var copy:Vector.<Brick> = Brick.vector_getCopy(this.fallingBricks);
			//Dbg.t("copy = "+copy);
			for(var col:uint=0; col<nbCols; col++)
			{
				var prevCol:int = col - 1;
				if(prevCol < 0)	prevCol = GameConf.NB_COLS - 1;
				//Dbg.t(prevCol);
				this.fallingBricks[col] = copy[prevCol];
				
				var brick:Brick = fallingBricks[col];
				if(brick)
				{
					var begin:Number = this.fallingBricks[col].x;
					var finish:Number = col * Brick.SIZE;
					var duration:Number = Math.abs(finish - begin) / GameConf.FALLING_SPEED_PX_PER_SEC;
					if(verbose)	trace("duration = "+duration);
					
					var tween_float:Tween = new Tween(brick, "x", Linear.easeNone, begin, finish, duration, true);
					this.tweenManager.registerShortLivedTween(tween_float);
					tween_float.start();
				}
			}
		}
	}
}
