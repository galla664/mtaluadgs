--[[
Item List Struct:
table = {
index:	-2			-1					0					1
		TextColor	BackGround Image	BackGround Color	Text	
	{	color,		{def,hov,sel},		{def,hov,sel},		text	},
	{	color,		{def,hov,sel},		{def,hov,sel},		text	},
	{	color,		{def,hov,sel},		{def,hov,sel},		text	},
	{	color,		{def,hov,sel},		{def,hov,sel},		text	},
	{	color,		{def,hov,sel},		{def,hov,sel},		text	},
	{	color,		{def,hov,sel},		{def,hov,sel},		text	},
	{	color,		{def,hov,sel},		{def,hov,sel},		text	},
	{	...														},
}
]]

function dgsCreateComboBox(x,y,sx,sy,relative,parent,itemheight,textcolor,scalex,scaley,defimg,hovimg,cliimg,defcolor,hovcolor,clicolor)
	assert(tonumber(x),"Bad argument @dgsCreateComboBox at argument 1, expect number got "..type(x))
	assert(tonumber(y),"Bad argument @dgsCreateComboBox at argument 2, expect number got "..type(y))
	assert(tonumber(sx),"Bad argument @dgsCreateComboBox at argument 3, expect number got "..type(sx))
	assert(tonumber(sy),"Bad argument @dgsCreateComboBox at argument 4, expect number got "..type(sy))
	if isElement(parent) then
		assert(dgsIsDxElement(parent),"Bad argument @dgsCreateComboBox at argument 6, expect dgs-dxgui got "..dgsGetType(parent))
	end
	local combobox = createElement("dgs-dxcombobox")
	dgsSetType(combobox,"dgs-dxcombobox")
	local _x = dgsIsDxElement(parent) and dgsSetParent(combobox,parent,true) or table.insert(MaxFatherTable,1,combobox)
	defcolor,hovcolor,clicolor = defcolor or schemeColor.combobox.color[1],hovcolor or schemeColor.combobox.color[2],clicolor or schemeColor.combobox.color[3]
	dgsSetData(combobox,"image",{defimg,hovimg,cliimg})
	dgsSetData(combobox,"color",{defcolor,hovcolor,clicolor})
	dgsSetData(combobox,"textcolor",textcolor or schemeColor.combobox.textcolor)
	dgsSetData(combobox,"textsize",{tonumber(scalex) or 1,tonumber(scaley) or 1})
	dgsSetData(combobox,"listtextcolor",textcolor or schemeColor.combobox.listtextcolor)
	dgsSetData(combobox,"listtextsize",{tonumber(scalex) or 1,tonumber(scaley) or 1})
	dgsSetData(combobox,"shadow",false)
	dgsSetData(combobox,"font",systemFont)
	dgsSetData(combobox,"combobgColor",schemeColor.combobox.combobgColor)
	dgsSetData(combobox,"combobgImage",nil)
	dgsSetData(combobox,"buttonLen",{1,true}) --height
	dgsSetData(combobox,"textbox",true) --enable textbox
	dgsSetData(combobox,"select",-1)
	dgsSetData(combobox,"clip",false)
	dgsSetData(combobox,"wordbreak",false)
	dgsSetData(combobox,"itemHeight",itemheight or 20)
	dgsSetData(combobox,"colorcoded",false)
	dgsSetData(combobox,"itemColor",{idefcolor or schemeColor.combobox.itemColor[1],ihovcolor or schemeColor.combobox.itemColor[2],iselcolor or schemeColor.combobox.itemColor[3]})
	dgsSetData(combobox,"itemImage",{idefimg,ihovimg,iselimg})
	dgsSetData(combobox,"listState",-1,true)
	dgsSetData(combobox,"listStateAnim",-1)
	dgsSetData(combobox,"combo_BoxTextSide",{5,5})
	dgsSetData(combobox,"comboTextSide",{5,5})
	dgsSetData(combobox,"arrowColor",schemeColor.combobox.arrowColor)
	dgsSetData(combobox,"arrowSettings",{"height",0.15})
	dgsSetData(combobox,"arrowWidth",10)
	dgsSetData(combobox,"arrowDistance",0.6)
	dgsSetData(combobox,"arrowHeight",0.6)
	dgsSetData(combobox,"arrowOutSideColor",schemeColor.combobox.arrowOutSideColor)
	dgsSetData(combobox,"scrollBarThick",20,true)
	dgsSetData(combobox,"itemData",{})
	dgsSetData(combobox,"rightbottom",{"left","center"})
	dgsSetData(combobox,"rightbottomList",{"left","center"})
	dgsSetData(combobox,"FromTo",{0,0})
	dgsSetData(combobox,"itemMoveOffset",0)
	dgsSetData(combobox,"scrollFloor",true)
	local shader = dxCreateShader("image/combobox/arrow.fx")
	dgsSetData(combobox,"arrow",shader)
	insertResourceDxGUI(sourceResource,combobox)
	triggerEvent("onDgsPreCreate",combobox)
	calculateGuiPositionSize(combobox,x,y,relative or false,sx,sy,relative or false,true)
	local box = dgsComboBoxCreateBox(0,1,1,5,true,combobox)
	dgsSetData(combobox,"myBox",box)
	dgsSetData(box,"myCombo",combobox)
	local boxsiz = dgsElementData[box].absSize
	local rendertarget = dxCreateRenderTarget(boxsiz[1],boxsiz[2],true)
	dgsSetData(combobox,"renderTarget",rendertarget)
	local scrollbar = dgsCreateScrollBar(boxsiz[1]-20,0,20,boxsiz[2],false,false,box)
	dgsSetData(scrollbar,"length",{0,true})
	dgsSetVisible(scrollbar,false)
	dgsSetVisible(box,false)
	dgsSetData(combobox,"scrollbar",scrollbar)
	triggerEvent("onDgsCreate",combobox)
	dgsSetData(combobox,"hitoutofparent",true)
	return combobox
end

function dgsComboBoxSetBoxHeight(combobox,height,relative)
	assert(dgsGetType(combobox) == "dgs-dxcombobox","Bad argument @dgsComboBoxSetBoxHeight at argument 1, expect dgs-dxcombobox got "..dgsGetType(combobox))
	assert(type(height) == "number","Bad argument @dgsComboBoxSetBoxHeight at argument 2, expect number got "..type(height))
	relative = relative and true or false
	local box = dgsElementData[combobox].myBox
	if isElement(box) then
		local size = relative and dgsElementData[box].rltSize or dgsElementData[box].absSize
		return dgsSetSize(box,size[1],height,relative)
	end
	return false
end

function dgsComboBoxGetBoxHeight(combobox,relative)
	assert(dgsGetType(combobox) == "dgs-dxcombobox","Bad argument @dgsComboBoxGetBoxHeight at argument 1, expect dgs-dxcombobox got "..dgsGetType(combobox))
	relative = relative and true or false
	local box = dgsElementData[combobox].myBox
	if isElement(box) then
		local size = relative and dgsElementData[box].rltSize or dgsElementData[box].absSize
		return size[2]
	end
	return false
end

function dgsComboBoxAddItem(combobox,text)
	assert(dgsGetType(combobox) == "dgs-dxcombobox","Bad argument @dgsComboBoxAddItem at argument 1, expect dgs-dxcombobox got "..dgsGetType(combobox))
	assert(type(text) == "string" or type(text) == "number","Bad argument @dgsComboBoxAddItem at argument 2, expect number/string got "..type(text))
	local data = dgsElementData[combobox].itemData
	local itemHeight = dgsElementData[combobox].itemHeight
	local box = dgsElementData[combobox].myBox
	local size = dgsElementData[box].absSize
	local id = #data+1
	local tab = {}
	tab[-2] = dgsElementData[combobox].listtextcolor
	tab[-1] = dgsElementData[combobox].itemImage
	tab[0] = dgsElementData[combobox].itemColor
	tab[1] = text
	table.insert(data,id,tab)
	if id*itemHeight > size[2] then
		local scrollBar = dgsElementData[combobox].scrollbar
		dgsSetVisible(scrollBar,true)
	end
	return id
end

function dgsComboBoxSetItemText(combobox,item,text)
	assert(dgsGetType(combobox) == "dgs-dxcombobox","Bad argument @dgsComboBoxSetItemText at argument 1, expect dgs-dxcombobox got "..dgsGetType(combobox))
	assert(type(item) == "number","Bad argument @dgsComboBoxSetItemText at argument 2, expect number got "..type(item))
	assert(type(text) == "string" or type(text) == "number","Bad argument @dgsComboBoxSetItemText at argument 3, expect number/string got "..type(text))
	local data = dgsElementData[combobox].itemData
	item = math.floor(item)
	if item >= 1 and item <= #data then
		data[item][1] = text
		return true
	end
	return false
end

function dgsComboBoxGetItemText(combobox,item)
	assert(dgsGetType(combobox) == "dgs-dxcombobox","Bad argument @dgsComboBoxGetItemText at argument 1, expect dgs-dxcombobox got "..dgsGetType(combobox))
	assert(tonumber(item),"Bad argument @dgsComboBoxGetItemText at argument 2, expect number got "..type(item))
	local data = dgsElementData[combobox].itemData
	local item = tonumber(item)
	local item = math.floor(item)
	if item >= 1 and item <= #data then
		return data[item][1]
	end
	return false
end

function dgsComboBoxSetItemColor(combobox,item,color)
	assert(dgsGetType(combobox) == "dgs-dxcombobox","Bad argument @dgsComboBoxSetItemColor at argument 1, expect dgs-dxcombobox got "..dgsGetType(combobox))
	assert(type(item) == "number","Bad argument @dgsComboBoxSetItemColor at argument 2, expect number got "..type(item))
	assert(type(color) == "number" or type(color) == "number","Bad argument @dgsComboBoxSetItemColor at argument 3, expect number/string got "..type(color))
	local data = dgsElementData[combobox].itemData
	item = math.floor(item)
	if item >= 1 and item <= #data then
		data[item][-2] = color
		return true
	end
	return false
end

function dgsComboBoxSetState(combobox,state)
	assert(dgsGetType(combobox) == "dgs-dxcombobox","Bad argument @dgsComboBoxSetState at argument 1, expect dgs-dxcombobox got "..dgsGetType(combobox))
	return dgsSetData(combobox,"listState",state and 1 or -1)
end

function dgsComboBoxGetState(combobox)
	assert(dgsGetType(combobox) == "dgs-dxcombobox","Bad argument @dgsComboBoxGetState at argument 1, expect dgs-dxcombobox got "..dgsGetType(combobox))
	return dgsElementData[combobox].listState == 1 and true or false
end

function dgsComboBoxGetItemColor(combobox,item)
	assert(dgsGetType(combobox) == "dgs-dxcombobox","Bad argument @dgsComboBoxGetItemColor at argument 1, expect dgs-dxcombobox got "..dgsGetType(combobox))
	assert(type(item) == "number","@dgsComboBoxGetItemColor argument 2,expect number got "..type(item))
	local data = dgsElementData[combobox].itemData
	item = math.floor(item)
	if item >= 1 and item <= #data then
		return data[item][-2]
	end
	return false
end

function dgsComboBoxRemoveItem(combobox,item)
	assert(dgsGetType(combobox) == "dgs-dxcombobox","Bad argument @dgsComboBoxRemoveItem at argument 1, expect dgs-dxcombobox got "..dgsGetType(combobox))
	assert(tonumber(item),"Bad argument @dgsComboBoxRemoveItem at argument 2, expect number got "..type(item))
	local data = dgsElementData[combobox].itemData
	local item = tonumber(item)
	local item = math.floor(item)
	if item >= 1 and item <= #data then
		table.remove(data,item)
		local itemHeight = dgsElementData[combobox].itemHeight
		local box = dgsElementData[combobox].myBox
		local size = dgsElementData[box].absSize
		if #data*itemHeight < size[2] then
			local scrollBar = dgsElementData[combobox].scrollbar
			dgsSetVisible(scrollBar,false)
		end
		return true
	end
	return false
end

function dgsComboBoxClear(combobox)
	assert(dgsGetType(combobox) == "dgs-dxcombobox","Bad argument @dgsComboBoxClear at argument 1, expect dgs-dxcombobox got "..dgsGetType(combobox))
	local data = dgsElementData[combobox].itemData
	table.remove(data)
	dgsElementData[combobox].itemData = {}
	local scrollBar = dgsElementData[combobox].scrollbar
	dgsSetVisible(scrollBar,false)
	return true
end

function dgsComboBoxCreateBox(x,y,sx,sy,relative,parent)
	assert(tonumber(x),"Bad argument @dgsComboBoxCreateBox at argument 1, expect number got "..type(x))
	assert(tonumber(y),"Bad argument @dgsComboBoxCreateBox at argument 2, expect number got "..type(y))
	assert(tonumber(sx),"Bad argument @dgsComboBoxCreateBox at argument 3, expect number got "..type(sx))
	assert(tonumber(sy),"Bad argument @dgsComboBoxCreateBox at argument 4, expect number got "..type(sy))
	assert(dgsGetType(parent) == "dgs-dxcombobox","Bad argument @dgsComboBoxCreateBox at argument 6, expect dgs-dxcombobox got "..dgsGetType(parent))
	local box = createElement("dgs-dxcombobox-Box")
	local _x = dgsIsDxElement(parent) and dgsSetParent(box,parent,true) or table.insert(MaxFatherTable,1,box)
	dgsSetType(box,"dgs-dxcombobox-Box")	
	insertResourceDxGUI(sourceResource,box)
	triggerEvent("onDgsPreCreate",box)
	calculateGuiPositionSize(box,x,y,relative or false,sx,sy,relative or false,true)
	triggerEvent("onDgsCreate",box)
	return box
end

function dgsComboBoxSetSelectedItem(combobox,id)
	assert(dgsGetType(combobox) == "dgs-dxcombobox","Bad argument @dgsComboBoxSetSelectedItem at argument 1, expect dgs-dxcombobox got "..dgsGetType(combobox))
	local itemData = dgsElementData[combobox].itemData
	local old = dgsElementData[combobox].select
	if not id or id == -1 then
		dgsSetData(combobox,"select",-1)
		triggerEvent("onDgsComboBoxSelect",combobox,old,-1)
		return true
	elseif id >= 1 and id <= #itemData then
		dgsSetData(combobox,"select",id)
		triggerEvent("onDgsComboBoxSelect",combobox,old,id)
		return true
	end
	return false
end

function dgsComboBoxGetSelectedItem(combobox)
	assert(dgsGetType(combobox) == "dgs-dxcombobox","Bad argument @dgsComboBoxGetSelectedItem at argument 1, expect dgs-dxcombobox got "..dgsGetType(combobox))
	local itemData = dgsElementData[combobox].itemData
	local selected = dgsElementData[combobox].select
	if selected < 1 and selected > #itemData then
		return -1
	else
		return selected
	end
end

function configComboBox_Box(box)
	local combobox = dgsElementData[box].myCombo
	local boxsiz = dgsElementData[box].absSize
	local rendertarget = dgsElementData[combobox].renderTarget
	if isElement(rendertarget) then
		destroyElement(rendertarget)
	end
	local sbt = dgsElementData[combobox].scrollBarThick
	local rendertarget = dxCreateRenderTarget(boxsiz[1],boxsiz[2],true)
	dgsSetData(combobox,"renderTarget",rendertarget)
	local sb = dgsElementData[combobox].scrollbar
	dgsSetPosition(sb,boxsiz[1]-sbt,0,false)
	dgsSetSize(sb,sbt,boxsiz[2],false)
end

addEventHandler("onDgsScrollBarScrollPositionChange",root,function(new,old)
	local parent = dgsGetParent(source)
	if dgsGetType(parent) == "dgs-dxcombobox-Box" then
		local combobox = dgsElementData[parent].myCombo
		local scrollBar = dgsElementData[combobox].scrollbar
		local sx,sy = unpack(dgsElementData[parent].absSize)
		if source == scrollBar then
			local itemLength = #dgsElementData[combobox].itemData*dgsElementData[combobox].itemHeight
			local temp = -new*(itemLength-sy)/100
			local temp = dgsElementData[combobox].scrollFloor and math.floor(temp) or temp 
			dgsSetData(combobox,"itemMoveOffset",temp)
		end
	end
end)

addEventHandler("onDgsComboBoxStateChange",root,function(state)
	if not wasEventCancelled() then
		local box = dgsElementData[source].myBox
		if state then
			dgsSetVisible(box,true)
		else
			dgsSetVisible(box,false)
		end
	end
end)

function dgsComboBoxSetScrollPosition(combobox,vertical)
	assert(dgsGetType(combobox) == "dgs-dxcombobox","Bad argument @dgsComboBoxSetScrollPosition at at argument 1, expect dgs-dxcombobox got "..dgsGetType(combobox))
	assert(not vertical or (type(vertical) == "number" and vertical>= 0 and vertical <= 100),"Bad argument @dgsComboBoxSetScrollPosition at at argument 2, expect nil, none or number∈[0,100] got "..dgsGetType(vertical).."("..tostring(vertical)..")")
	local scb = dgsElementData[combobox].scrollbar
	if dgsElementData[scb].visible then
		return dgsScrollBarSetScrollBarPosition(scb,vertical)
	end
	return true
end

function dgsComboBoxGetScrollPosition(combobox)
	assert(dgsGetType(combobox) == "dgs-dxcombobox","Bad argument @dgsComboBoxGetScrollPosition at at argument 1, expect dgs-dxcombobox got "..dgsGetType(combobox))
	local scb = dgsElementData[combobox].scrollbar
	return dgsScrollBarGetScrollBarPosition(scb)
end