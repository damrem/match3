package {
	import gamescreen.GameMVC;
	import gamescreen.GameScreen;
	import gamescreen.gamecontroller.GameController;
	import gamescreen.gamemodel.GameModel;
	import gamescreen.gameview.GameView;
	import menuscreen.MenuScreen;
	import com.supagrip.getSimpleToString;
	/**
	 * @author damrem
	 */
	public class Debug 
	{		
		public static function setup():void
		{
			var classes:Vector.<Class> = new <Class>
			[
				Preloader, 
				Main,
				//DeviceSettings,
				
				//Navigator,
				
				//AssetBank,
				//ProgressBar,
				
				//MenuScreen,
				
				//GameScreen,
				//GameMVC,
				//GameController,
				//GameModel,
				//GameView
			];
			
			for each(var classToDebug:Class in classes)
			{
				classToDebug['verbose'] = true;
				classToDebug.prototype['toString'] = getSimpleToString(classToDebug);
			}
		}
	}
}
