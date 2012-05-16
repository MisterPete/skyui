﻿import gfx.events.EventDispatcher;

import skyui.components.list.ListLayout;
import skyui.util.Defines;
import skyui.util.GlobalFunctions;


class skyui.util.ConfigManager
{
  /* CONSTANTS */
  
	private static var _constantTable: Object = {
		
		ASCENDING: 0,
		DESCENDING: Array.DESCENDING,
		CASEINSENSITIVE: Array.CASEINSENSITIVE,
		NUMERIC: Array.NUMERIC,
		
		CAT_INV_ALL: Defines.FLAG_INV_ALL,
		CAT_INV_FAVORITES: Defines.FLAG_INV_FAVORITES,
		CAT_INV_WEAPONS: Defines.FLAG_INV_WEAPONS,
		CAT_INV_ARMOR: Defines.FLAG_INV_ARMOR,
		CAT_INV_POTIONS: Defines.FLAG_INV_POTIONS,
		CAT_INV_SCROLLS: Defines.FLAG_INV_SCROLLS,
		CAT_INV_FOOD: Defines.FLAG_INV_FOOD,
		CAT_INV_INGREDIENTS: Defines.FLAG_INV_INGREDIENTS,
		CAT_INV_BOOKS: Defines.FLAG_INV_BOOKS,
		CAT_INV_KEYS: Defines.FLAG_INV_KEYS,
		CAT_INV_MISC: Defines.FLAG_INV_MISC,
		
		CAT_CONTAINER_ALL: Defines.FLAG_CONTAINER_ALL,
		CAT_CONTAINER_WEAPONS: Defines.FLAG_CONTAINER_WEAPONS,
		CAT_CONTAINER_ARMOR: Defines.FLAG_CONTAINER_ARMOR,
		CAT_CONTAINER_POTIONS: Defines.FLAG_CONTAINER_POTIONS,
		CAT_CONTAINER_SCROLLS: Defines.FLAG_CONTAINER_SCROLLS,
		CAT_CONTAINER_FOOD: Defines.FLAG_CONTAINER_FOOD,
		CAT_CONTAINER_INGREDIENTS: Defines.FLAG_CONTAINER_INGREDIENTS,
		CAT_CONTAINER_BOOKS: Defines.FLAG_CONTAINER_BOOKS,
		CAT_CONTAINER_KEYS: Defines.FLAG_CONTAINER_KEYS,
		CAT_CONTAINER_MISC: Defines.FLAG_CONTAINER_MISC,
		
		CAT_MAG_ALL: Defines.FLAG_MAGIC_ALL,
		CAT_MAG_FAVORITES: Defines.FLAG_MAGIC_FAVORITES,
		CAT_MAG_ALTERATION: Defines.FLAG_MAGIC_ALTERATION,
		CAT_MAG_ILLUSION: Defines.FLAG_MAGIC_ILLUSION,
		CAT_MAG_DESTRUCTION: Defines.FLAG_MAGIC_DESTRUCTION,
		CAT_MAG_CONJURATION: Defines.FLAG_MAGIC_CONJURATION,
		CAT_MAG_RESTORATION: Defines.FLAG_MAGIC_RESTORATION,
		CAT_MAG_SHOUTS: Defines.FLAG_MAGIC_SHOUTS,
		CAT_MAG_POWERS: Defines.FLAG_MAGIC_POWERS,
		CAT_MAG_EFFECTS: Defines.FLAG_MAGIC_ACTIVE_EFFECT
	};
	
	
  /* PRIVATE VARIABLES */	
	
	private static var _eventDummy: Object;
	
	private static var _loaded: Boolean;
	
	private static var _config: Object;
	
	
  /* STATIC INITIALIZER */
  
  	private static var _initialized:Boolean = initialize();
  
	private static function initialize():Boolean
	{
		if (_initialized)
			return;
		
		_eventDummy = {};
		EventDispatcher.initialize(_eventDummy);
		
		var lv = new LoadVars();
		lv.onData = parseData;
		lv.load("skyui_cfg.txt");
		
		return true;
	}
	
	
  /* PUBLIC FUNCTIONS */
  
	public static function registerLoadCallback(a_scope: Object, a_callBack: String)
	{
		// Not loaded yet
		if (!_loaded) {
			_eventDummy.addEventListener("configLoad", a_scope, a_callBack);
			return;
		}
		
		// Already loaded, generate event instantly.
		a_scope[a_callBack]({type: "configLoad", config: _config});
	}
	
	public static function registerUpdateCallback(a_scope: Object, a_callBack: String)
	{
		_eventDummy.addEventListener("configUpdate", a_scope, a_callBack);
	}
	
	public static function setConstant(a_name: String, a_value)
	{
		var type = typeof(a_value);
		if (type != "number" && type != "boolean" && type != "string")
			return;
		
		_constantTable[a_name] = a_value;
	}
	
	public static function setOverride(a_section: String, a_key: String, a_value): Void
	{
		skse.Log("settingOverride " + a_section + " " + a_key + " " + a_value);
		
		// Allow to add new sections
		if (_config[a_section] == undefined)
			_config[a_section] = {};
		
		// Prepare key subsections
		var a = a_key.split(".");
		var loc = _config[a_section];
		for (var j=0; j<a.length-1; j++) {
			if (loc[a[j]] == undefined)
				loc[a[j]] = {};
			loc = loc[a[j]];
		}

		// Store value
		loc[a[a.length-1]] = a_value;
		
		_eventDummy.dispatchEvent({type: "configUpdate", config: _config});
	}


  /* PRIVATE FUNCTIONS */

	private static function parseData(a_data:Array)
	{
		_config = {};
		
		var lines = a_data.split("\r\n");
		if (lines.length == 1)
			lines = a_data.split("\n");

		var section = undefined;

		for (var i = 0; i < lines.length; i++) {

			// Comment
			if (lines[i].charAt(0) == ";")
				continue;

			// Section start
			if (lines[i].charAt(0) == "[") {
				section = lines[i].slice(1, lines[i].lastIndexOf("]"));
//				trace("Section: [" + section + "]");
				
				if (_config[section] == undefined)
					_config[section] = {};
					
				continue;
			}

			if (lines[i].length < 3 || section == undefined)
				continue;
			
			// Get raw key string
			var key = GlobalFunctions.clean(lines[i].slice(0, lines[i].indexOf("=")));
			if (key == undefined)
				continue;
				
			// Prepare key subsections
			var a = key.split(".");
			var loc = _config[section];
			for (var j=0; j<a.length-1; j++) {
				if (loc[a[j]] == undefined)
					loc[a[j]] = {};
				loc = loc[a[j]];
			}

			// Detect value type & extract
			var val = parseValueString(GlobalFunctions.clean(lines[i].slice(lines[i].indexOf("=") + 1)), _constantTable, _config[section]);
			
			if (val == undefined)
				continue;
			
//			trace(key + "=" + val + "%");

			// Store val at config.section.a.b.c.d
			loc[a[a.length-1]] = val;
		}
		
		_loaded = true;
		
		_eventDummy.dispatchEvent({type: "configLoad", config: _config});
	}
	
	private static function parseValueString(a_str: String, a_constantTable: Object, a_root: Object): Object
	{
		if (a_str == undefined)
			return undefined;

		// Number?
		if (!isNaN(a_str)) {
			return Number(a_str);
			
		// Bool true?
		} else if (a_str.toLowerCase() == "true") {
			return true;
			
		// Bool false?
		} else if (a_str.toLowerCase() == "false") {
			return false;
			
		// Explicit String?
		} else if (a_str.charAt(0) == "'") {
			return GlobalFunctions.extract(a_str, "'", "'");
			
		// Entry property? - substituted later
		} else if (a_str.charAt(0) == "@") {
			return a_str;
			
		// List?
		} else if (a_str.charAt(0) == "<") {
			var values = GlobalFunctions.extract(a_str, "<", ">").split(",");
			for (var i=0; i<values.length; i++)
				values[i] = parseValueString(GlobalFunctions.clean(values[i]), a_constantTable, a_root);
				
			return values;
			
		// Flags?
		} else if (a_str.charAt(0) == "{") {
			var values = GlobalFunctions.extract(a_str, "{", "}").split("|");
			var flags = 0;
			for (var i=0; i<values.length; i++) {
				var t = parseValueString(GlobalFunctions.clean(values[i]), a_constantTable, a_root);
				if (isNaN(t))
					return undefined;
					
				flags = flags | t;
			}
			return flags;
		
		// Constant?
		} else if (a_constantTable[a_str] != undefined) {
			return a_constantTable[a_str];

		// No longer used. Lookup is done at runtime now. Otherwise the names of the top level elements would no longer be available,
		// which is a problem because it's needed to create the column descriptors for overrides.
		//
		// Top-level property?
		//} else if (a_root[a_str] != undefined) {
		//	return a_root[a_str];
		}
		
		// Default String
		return a_str;
	}
}