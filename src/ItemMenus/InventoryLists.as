﻿import gfx.io.GameDelegate;
import gfx.ui.NavigationCode;
import gfx.events.EventDispatcher;
import gfx.managers.FocusHandler;
import gfx.controls.Button;
import Shared.GlobalFunc;

import skyui.components.SearchWidget;
import skyui.components.TabBar;
import skyui.components.list.FilteredEnumeration;
import skyui.components.list.BasicEnumeration;
import skyui.components.list.TabularList;
import skyui.components.list.SortedListHeader;
import skyui.filter.ItemTypeFilter;
import skyui.filter.ItemNameFilter;
import skyui.filter.ItemSorter;
import skyui.util.ConfigManager;
import skyui.util.GlobalFunctions;
import skyui.util.Translator;
import skyui.util.DialogManager;


class InventoryLists extends MovieClip
{
  /* CONSTANTS */
	
	static var HIDE_PANEL = 0;
	static var SHOW_PANEL = 1;
	static var TRANSITIONING_TO_HIDE_PANEL = 2;
	static var TRANSITIONING_TO_SHOW_PANEL = 3;
	
	
  /* STAGE ELEMENTS */
  
	public var panelContainer: MovieClip;
	public var zoomButtonHolder: MovieClip;


  /* PRIVATE VARIABLES */

	private var _config: Object;

	private var _typeFilter: ItemTypeFilter;
	private var _nameFilter: ItemNameFilter;
	private var _sortFilter: ItemSorter;
	
	private var _platform: Number;
	
	private var _currCategoryIndex: Number;
	private var _savedSelectionIndex: Number = -1;

	private var _searchKey: Number;
	private var _tabToggleKey: Number;
	
	private var _bTabbed = false;

	private var _columnSelectDialog: MovieClip;
	

  /* PROPERTIES */

	public var itemList: TabularList;
	
	public var categoryList: CategoryList;
	
	public var tabBar: TabBar;
	
	public var searchWidget: SearchWidget;
	
	public var categoryLabel: MovieClip;
	
	public var columnSelectButton: Button;
	
	private var _currentState: Number;
	
	public function get currentState()
	{
		return _currentState;
	}

	public function set currentState(a_newState: Number)
	{
		if (a_newState == SHOW_PANEL)
			FocusHandler.instance.setFocus(itemList,0);

		_currentState = a_newState;
	}
	
	private var _tabBarIconArt: Array;
	
	public function set tabBarIconArt(a_iconArt: Array)
	{
		_tabBarIconArt = a_iconArt;
		
		if (tabBar)
			tabBar.setIcons(_tabBarIconArt[0], _tabBarIconArt[1]);
	}
	
	public function get tabBarIconArt(): Array
	{
		return _tabBarIconArt;
	}


  /* CONSTRUCTORS */

	public function InventoryLists()
	{
		super();

		GlobalFunctions.addArrayFunctions();

		EventDispatcher.initialize(this);

		gotoAndStop("NoPanels");

		GameDelegate.addCallBack("SetCategoriesList", this, "SetCategoriesList");
		GameDelegate.addCallBack("InvalidateListData", this, "InvalidateListData");

		_typeFilter = new ItemTypeFilter();
		_nameFilter = new ItemNameFilter();
		_sortFilter = new ItemSorter();

		_searchKey = undefined;
		_tabToggleKey = undefined;
		
		categoryList = panelContainer.categoryList;
		categoryLabel = panelContainer.categoryLabel;
		itemList = panelContainer.itemList;
		searchWidget = panelContainer.searchWidget;
		columnSelectButton = panelContainer.columnSelectButton;

		ConfigManager.registerLoadCallback(this, "onConfigLoad");
	}
	
	
  /* PUBLIC FUNCTIONS */

	// @mixin by gfx.events.EventDispatcher
	public var dispatchEvent: Function;
	public var dispatchQueue: Function;
	public var hasEventListener: Function;
	public var addEventListener: Function;
	public var removeEventListener: Function;
	public var removeAllEventListeners: Function;
	public var cleanUpEvents: Function;
	
	// @mixin by Shared.GlobalFunc
	public var Lock: Function;

	// Apparently it's not safe to use stage elements in the constructor (as it doesn't work).
	// That's why they are initialized in onLoad.
	public function onLoad(): Void
	{
		categoryList.listEnumeration = new BasicEnumeration(categoryList.entryList);
		categoryList.entryFormatter = new CategoryEntryFormatter(categoryList);

		var listEnumeration = new FilteredEnumeration(itemList.entryList);
		listEnumeration.addFilter(_typeFilter);
		listEnumeration.addFilter(_nameFilter);
		listEnumeration.addFilter(_sortFilter);
		itemList.listEnumeration = listEnumeration;
		// entry formatter and data fetcher are initialized by the top-level menu since they differ in each case

		_typeFilter.addEventListener("filterChange", this, "onFilterChange");
		_nameFilter.addEventListener("filterChange", this, "onFilterChange");
		_sortFilter.addEventListener("filterChange", this, "onFilterChange");

		categoryList.addEventListener("itemPress", this, "onCategoriesItemPress");
		categoryList.addEventListener("listMovedUp", this, "onCategoriesListMoveUp");
		categoryList.addEventListener("listMovedDown", this, "onCategoriesListMoveDown");
		categoryList.addEventListener("selectionChange", this, "onCategoriesListMouseSelectionChange");

		itemList.disableInput = false;

		itemList.addEventListener("listMovedUp", this, "onItemsListMoveUp");
		itemList.addEventListener("listMovedDown", this, "onItemsListMoveDown");
		itemList.addEventListener("selectionChange", this, "onItemsListMouseSelectionChange");
		itemList.addEventListener("sortChange", this, "onSortChange");

		searchWidget.addEventListener("inputStart", this, "onSearchInputStart");
		searchWidget.addEventListener("inputEnd", this, "onSearchInputEnd");
		searchWidget.addEventListener("inputChange", this, "onSearchInputChange");
		
		columnSelectButton.addEventListener("press", this, "onColumnSelectButtonPress");
	}
	
	public function onFilterChange(): Void
	{
		itemList.InvalidateData();
	}
	
	public function enableTabBar(): Void
	{
		_bTabbed = true;
		panelContainer.gotoAndPlay("tabbed");
		itemList.listHeight = 480;
	}
	
	public function onTabBarLoad(): Void
	{
		tabBar = panelContainer.tabBar;
		tabBar.setIcons(_tabBarIconArt[0], _tabBarIconArt[1]);
		tabBar.addEventListener("tabPress", this, "onTabPress");
		
		if (categoryList.dividerIndex != -1) {
			tabBar.setLabelText(categoryList.entryList[0].text, categoryList.entryList[categoryList.dividerIndex + 1].text);
			categoryList.entryList[0].text = categoryList.entryList[categoryList.dividerIndex + 1].text = Translator.translate("$ALL");
		}
	}
	
	public function onColumnSelectButtonPress(event: Object): Void
	{
		if (_columnSelectDialog) {
			DialogManager.close();
			return;
		}
		
		_savedSelectionIndex = itemList.selectedIndex;
		itemList.selectedIndex = -1;
		
		categoryList.disableSelection = categoryList.disableInput = true;
		itemList.disableSelection = itemList.disableInput = true;
		searchWidget.isDisabled = true;
			
		_columnSelectDialog = DialogManager.open(panelContainer, "ColumnSelectDialog", {_x: 554, _y: 35, layout: itemList.layout});
		_columnSelectDialog.addEventListener("dialogClosed", this, "onColumnSelectDialogClosed");
	}
	
	public function onColumnSelectDialogClosed(event: Object): Void
	{
		categoryList.disableSelection = categoryList.disableInput = false;
		itemList.disableSelection = itemList.disableInput = false;
		searchWidget.isDisabled = false;
		
		itemList.selectedIndex = _savedSelectionIndex;
	}

	public function onConfigLoad(event: Object): Void
	{
		_config = event.config;
		_searchKey = _config.Input.hotkey.search;
		_tabToggleKey = _config.Input.hotkey.tabToggle;
	}

	public function setPlatform(a_platform: Number, a_bPS3Switch: Boolean)
	{
		_platform = a_platform;

		categoryList.platform = a_platform;
		itemList.platform = a_platform;
	}

	// @GFx
	public function handleInput(details, pathToFocus): Boolean
	{
		var bCaught = false;

		if (_currentState == SHOW_PANEL) {
			
			if (GlobalFunc.IsKeyPressed(details)) {

				// Search hotkey (default space)
				if (details.code == _searchKey) {
					bCaught = true;
					searchWidget.startInput();
					
				// Toggle tab (default ALT)
				} else if (tabBar != undefined && (details.code == _tabToggleKey || (details.navEquivalent == NavigationCode.GAMEPAD_BACK && details.code != 8))) {
					
					bCaught = true;
					tabBar.tabToggle();
				}
			}
			
			if (!bCaught)
				bCaught = categoryList.handleInput(details, pathToFocus);
			
			if (!bCaught)
				bCaught = pathToFocus[0].handleInput(details, pathToFocus.slice(1));
		}
		return bCaught;
	}

	public function getContentBounds():Array
	{
		var lb = panelContainer.ListBackground;
		return [lb._x, lb._y, lb._width, lb._height];
	}

	public function restoreCategoryIndex(): Void
	{
		categoryList.selectedIndex = _currCategoryIndex;
	}

	public function showCategoriesList(a_bPlayBladeSound: Boolean): Void
	{
		_currentState = TRANSITIONING_TO_SHOW_PANEL;
		gotoAndPlay("PanelShow");

		dispatchEvent({type:"categoryChange", index:categoryList.selectedIndex});

		if (a_bPlayBladeSound != false)
			GameDelegate.call("PlaySound",["UIMenuBladeOpenSD"]);
	}

	public function hideCategoriesList(): Void
	{
		_currentState = TRANSITIONING_TO_HIDE_PANEL;
		gotoAndPlay("PanelHide");
		GameDelegate.call("PlaySound",["UIMenuBladeCloseSD"]);
	}
	
	public function showItemsList(): Void
	{
		_currCategoryIndex = categoryList.selectedIndex;
		
		categoryLabel.textField.SetText(categoryList.selectedEntry.text);

		// Start with no selection
		itemList.selectedIndex = -1;
		itemList.scrollPosition = 0;

		if (categoryList.selectedEntry != undefined) {
			// Set filter type
			_typeFilter.changeFilterFlag(categoryList.selectedEntry.flag);
			itemList.layout.changeFilterFlag(categoryList.selectedEntry.flag);
		} else {
			itemList.UpdateList();
		}
		
		dispatchEvent({type:"itemHighlightChange", index:itemList.selectedIndex});

		itemList.disableInput = false;
	}

	public function onCategoriesItemPress(): Void
	{
		showItemsList();
	}
	
	public function onTabPress(event: Object): Void
	{
		if (categoryList.disableSelection || categoryList.disableInput || itemList.disableSelection || itemList.disableInput)
			return;
		
		if (event.index == TabBar.LEFT_TAB) {
			tabBar.activeTab = TabBar.LEFT_TAB;
			categoryList.activeSegment = CategoryList.LEFT_SEGMENT;
		} else if (event.index == TabBar.RIGHT_TAB) {
			tabBar.activeTab = TabBar.RIGHT_TAB;
			categoryList.activeSegment = CategoryList.RIGHT_SEGMENT;
		}
		
		GameDelegate.call("PlaySound",["UIMenuBladeOpenSD"]);
		showItemsList();
	}

	public function onCategoriesListMoveUp(event: Object): Void
	{
		doCategorySelectionChange(event);
	}

	public function onCategoriesListMoveDown(event: Object): Void
	{
		doCategorySelectionChange(event);
	}

	public function onCategoriesListMouseSelectionChange(event: Object): Void
	{
		if (event.keyboardOrMouse == 0)
			doCategorySelectionChange(event);
	}

	public function onItemsListMoveUp(event: Object): Void
	{
		doItemsSelectionChange(event);
	}

	public function onItemsListMoveDown(event: Object): Void
	{
		doItemsSelectionChange(event);
	}

	public function onItemsListMouseSelectionChange(event: Object): Void
	{
		if (event.keyboardOrMouse == 0)
			doItemsSelectionChange(event);
	}

	public function doCategorySelectionChange(event: Object): Void
	{
		dispatchEvent({type:"categoryChange", index:event.index});
		
		if (event.index != -1)
			GameDelegate.call("PlaySound",["UIMenuFocus"]);
	}

	public function doItemsSelectionChange(event: Object): Void
	{
		dispatchEvent({type:"itemHighlightChange", index:event.index});

		if (event.index != -1)
			GameDelegate.call("PlaySound",["UIMenuFocus"]);
	}

	public function onSortChange(event: Object): Void
	{
		_sortFilter.setSortBy(event.attributes, event.options);
	}

	public function onSearchInputStart(event: Object): Void
	{
		categoryList.disableSelection = categoryList.disableInput = true;
		itemList.disableSelection = itemList.disableInput = true
		_nameFilter.filterText = "";
	}

	public function onSearchInputChange(event: Object)
	{
		_nameFilter.filterText = event.data;
	}

	public function onSearchInputEnd(event: Object)
	{
		categoryList.disableSelection = categoryList.disableInput = false;
		itemList.disableSelection = itemList.disableInput = false;
		_nameFilter.filterText = event.data;
	}

	// Called to initially set the category list.
	// @API 
	function SetCategoriesList()
	{
		var textOffset = 0;
		var flagOffset = 1;
		var bDontHideOffset = 2;
		var len = 3;

		categoryList.clearList();

		for (var i = 0, index = 0; i < arguments.length; i = i + len, index++) {
			var entry = {text:arguments[i + textOffset], flag:arguments[i + flagOffset], bDontHide:arguments[i + bDontHideOffset], savedItemIndex:0, filterFlag:arguments[i + bDontHideOffset] == true ? (1) : (0)};
			categoryList.entryList.push(entry);

			if (entry.flag == 0)
				categoryList.dividerIndex = index;
		}
		
		// Initialize tabbar labels and replace text of segment heads (name -> ALL)
		if (_bTabbed)
			// Restore 0 as default index for tabbed lists
			categoryList.selectedIndex = 0;

		categoryList.InvalidateData();
	}

	// Called whenever the underlying entryList data is updated (using an item, equipping etc.)
	// @API
	function InvalidateListData()
	{
		var flag = categoryList.selectedEntry.flag;

		for (var i = 0; i < categoryList.entryList.length; i++)
			categoryList.entryList[i].filterFlag = categoryList.entryList[i].bDontHide ? 1 : 0;

		// Set filter flag = 1 for non-empty categories with bDontHideOffset=false
		itemList.InvalidateData();
		for (var i = 0; i < itemList.entryList.length; i++) {
			for (var j = 0; j < categoryList.entryList.length; ++j) {
				if (categoryList.entryList[j].filterFlag != 0)
					continue;

				if (itemList.entryList[i].filterFlag & categoryList.entryList[j].flag)
					categoryList.entryList[j].filterFlag = 1;
			}
		}

		categoryList.UpdateList();

		if (flag != categoryList.selectedEntry.flag) {
			// Triggers an update if filter flag changed
			_typeFilter.itemFilter = categoryList.selectedEntry.flag;
			dispatchEvent({type:"categoryChange", index:categoryList.selectedIndex});
		}
		
		// This is called when an ItemCard list closes(ex. ShowSoulGemList) to refresh ItemCard data    
		if (itemList.selectedIndex == -1)
			dispatchEvent({type:"showItemsList", index: -1});
		else
			dispatchEvent({type:"itemHighlightChange", index:itemList.selectedIndex});
	}
}