package com.rubenswieringa.interactivemindmap {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class Model extends EventDispatcher {
		
		private var loader:URLLoader = new URLLoader();
		private var _data:XML;
		private static var _instance:Model;
		
		private static const ILLEGAL_ATTRIBUTE_VALUES:RegExp = /[\s\!@#$%^_=+\[\]\\|:;'",.<>\/\?-]+/ig;
		private static const ERROR_DATA:XML = <mindmap><words><word value="Error" id="error" /></words></mindmap>
		
		public static const READY:String = "ready";
		
		public function Model ():void {
			this.loader.addEventListener(Event.COMPLETE, this.store);
			this.loader.addEventListener(IOErrorEvent.IO_ERROR, this.error);
		}
		
		/**
		 * Loads XML.
		 */
		public function load (url:String):void {
			this.loader.load(new URLRequest(url));
		}
		
		/**
		 * Executes once XML has been loaded. Let's the XML be parsed, stores it, and notifies other classes.
		 */
		private function store (event:Event):void {
			this._data = this.parse(loader.data);
			this.dispatchEvent(new Event(Model.READY));
		}
		
		/**
		 * 
		 */
		private function error (event:Event=null, message:String=""):void {
			this._data = Model.ERROR_DATA;
			if (message != "") this._data.words.word[0].@value = message;
			this.dispatchEvent(new Event(Model.READY));
		}
		
		/**
		 * Parses a given XML structure (makes sure every node has an id and value attribute value) and returns it.
		 */
		private function parse (raw:String):XML {
			
			var xml:XML;
			var nodes:XMLList;
			var node:XML;
			
			// throw Error if XML is not valid:
			try {
				xml = XML(raw);
			}catch (error:Error){
				this.error(null, "Parse-error");
				throw new Error("XML is invalid");
			}
			
			// make sure all words have values:
			nodes = xml..word.(hasOwnProperty("@id") && !hasOwnProperty("@value"));
			for each (node in nodes){
				node.@value = node.@id;
			}
			
			// make sure all words have IDs:
			nodes = xml..word.(!hasOwnProperty("@id") && hasOwnProperty("@value"));
			for each (node in nodes){
				node.@id = node.@value.toString().replace(ILLEGAL_ATTRIBUTE_VALUES, "").toLowerCase();
				if (node.@id.toString().indexOf("(") != -1 || node.@id.toString().indexOf(")") != -1){
					throw new Error("Parenthesis are not allowed in id-values (found in "+node.toXMLString()+")");
				}
			}
			
			// remove links that refer to main-typed words (this is a workaround):
	/*		nodes = xml..link;
			for (var i:int=nodes.length()-1; i>=0; i--){
				if (xml..word.(@id == nodes[i].@a).@type == "main" || xml..word.(@id == nodes[i].@b).@type == "main"){
					delete nodes[i];
				}
			}*/
			// above workaround not necessary anymore, bug fixed
			
			// return value:
			return xml;
			
		}
		
		/**
		 * Getter accessor method for the loaded XML.
		 */
		public function get data ():XML {
			return this._data;
		}
		
		/**
		 * Singleton instance.
		 */
		public static function get instance ():Model {
			if (Model._instance == null){
				Model._instance = new Model();
			}
			return Model._instance;
		}
		
	}
	
}