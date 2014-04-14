package utils.debug {
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	/**
	 * @author damrem
	 */
	public class Dbg 
	{
		/**
		 * Stocke si la classe à été initialisée.
		 * @private
		 */
		static private var isInited:Boolean;
		
		/**
		 * Le conteneur graphique par défaut des champs-texte.
		 * @private
		 */
		static private var _defaultContainer:DisplayObjectContainer;
		
		/**
		 * Dictionnaire dans lequel on stocke les champs-texte associées à des clés.
		 * @private
		 */
		static private var fieldList:Dictionary;
		
		/**
		 * La clé dans le dictionnaire du champ-texte actif.
		 * @private
		 */
		static private var currentFieldKey:Object;
		
		/**
		 * Initialise la classe. Nécessairement appelée avant tout autre opération sur la classe.
		 */
		static public function init(defaultContainer:DisplayObjectContainer):void
		{
			if(isInited)	return;
			isInited = true;
			createFieldList();
			setDefaultContainer(defaultContainer);
		}
		
		/**
		 * Permet de définir le conteneur graphique par défaut pour les prochains champs-texte ajoutés.
		 * @param defaultContainer:DisplayObjectContainer Le conteneur graphique par défaut pour les prochains champs-texte ajoutés.
		 */
		static public function setDefaultContainer(defaultContainer:DisplayObjectContainer):void
		{
			if(!isInited)
			{
				throw new Error("Init Dbg before setting another defaultContainer.");
				return;
			}
			_defaultContainer = defaultContainer;
		}
		
		/**
		 * @return Le champ-texte correspondant à la clé spécifiée en paramètre.
		 */
		static public function get(key:Object):DebugField
		{
			return Dbg.fieldList[key];
		}
		
		/**
		 * @private
		 * @return Le champ-texte actif.
		 */
		static private function getCurrentField():DebugField
		{
			if(fieldList)	return fieldList[currentFieldKey];
			return null;
		}
		
		/**
		 * @private
		 * Crée le dictionnaire de champs-texte.
		 */
		static private function createFieldList():void
		{
			fieldList = new Dictionary();
		}
		
		/**
		 * Crée un champ-texte.
		 * @param key:Object La clé du champ-texte dans le dictionnaire.
		 */
		static public function createField(key:Object, isCurrent:Boolean=true, bgColor:uint=0xffff00):DebugField
		{
			if(!_defaultContainer)	throw new Error("No default container has been set.");
			var field:DebugField = new DebugField(bgColor, key);
			fieldList[key] = field;
			if(isCurrent)	currentFieldKey = key;
			_defaultContainer.addChild(field);
			return field;
		}
		
		/**
		 * Ajoute une ligne de debug dans le champ-texte dont la clé est spécifiée en paramètre.
		 */
		static public function t(...values:Array):void
		{
			var field:DebugField = getCurrentField();
			if(!field)
			{
				//throw new Error("No current field.");
				return;
			}
			
			field.t(values);
		}
	}
}
