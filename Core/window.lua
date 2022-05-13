function dgsCreateWindow(x,y,sx,sy,title,relative,titnamecolor,titsize,titimg,titcolor,bgimg,bgcolor,sidesize,nooffbutton)
	assert(tonumber(x),"Bad argument @dgsCreateWindow at argument 1, expect number got "..type(x))
	assert(tonumber(y),"Bad argument @dgsCreateWindow at argument 2, expect number got "..type(y))
	assert(tonumber(sx),"Bad argument @dgsCreateWindow at argument 3, expect number got "..type(sx))
	assert(tonumber(sy),"Bad argument @dgsCreateWindow at argument 4, expect number got "..type(sy))
	local window = createElement("dgs-dxwindow")
	dgsSetType(window,"dgs-dxwindow")
	table.insert(MaxFatherTable,window)
	dgsSetData(window,"titimage",titimg)
	dgsSetData(window,"titnamecolor",tonumber(titnamecolor) or schemeColor.window.titnamecolor)
	dgsSetData(window,"titcolor",tonumber(titcolor) or schemeColor.window.titcolor)
	dgsSetData(window,"titalign",{"center","center"})
	dgsSetData(window,"image",bgimg)
	dgsSetData(window,"color",tonumber(bgcolor) or schemeColor.window.color)
	dgsSetData(window,"text",tostring(title) or "")
	dgsSetData(window,"textsize",{1,1})
	dgsSetData(window,"titlesize",tonumber(titsize) or 25)
	dgsSetData(window,"sidesize",tonumber(sidesize) or 5)
	dgsSetData(window,"sizable",true)
	dgsSetData(window,"ignoreTitleSize",false)
	dgsSetData(window,"colorcoded",false)
	dgsSetData(window,"movable",true)
	dgsSetData(window,"movetyp",false) --false only title;true are all
	dgsSetData(window,"font",systemFont)
	dgsSetData(window,"minSize",{60,60})
	dgsSetData(window,"maxSize",{20000,20000})
	insertResourceDxGUI(sourceResource,window)
	triggerEvent("onDgsPreCreate",window)
	calculateGuiPositionSize(window,x,y,relative,sx,sy,relative,true)
	triggerEvent("onDgsCreate",window)
	if not nooffbutton then
		local buttonOff = dgsCreateButton(30,0,25,20,"×",false,window,_,_,_,_,_,_,tocolor(200,50,50,255),tocolor(250,20,20,255),tocolor(150,50,50,255),true)
		dgsSetData(window,"closeButton",buttonOff)
		dgsSetSide(buttonOff,"right",false)
		dgsSetData(buttonOff,"ignoreParentTitle",true)
		dgsSetPosition(buttonOff,30,0,false)
	end
	return window
end

function dgsWindowSetCloseButtonEnabled(window,bool)
	assert(dgsGetType(window) == "dgs-dxwindow","Bad argument @dgsWindowSetCloseButtonEnabled at at argument 1, expect dgs-dxwindow got "..dgsGetType(window))
	local closeButton = dgsElementData[window].closeButton
	if bool then
		if not isElement(closeButton) then
			local buttonOff = dgsCreateButton(30,0,25,20,"×",false,window,_,_,_,_,_,_,tocolor(200,50,50,255),tocolor(250,20,20,255),tocolor(150,50,50,255),true)
			dgsSetData(window,"closeButton",buttonOff)
			dgsSetSide(buttonOff,"right",false)
			dgsSetData(buttonOff,"ignoreParentTitle",true)
			dgsSetPosition(buttonOff,30,0,false)
			return true
		end
	else
		if isElement(closeButton) then
			destroyElement(closeButton)
			dgsSetData(window,"closeButton",nil)
			return true
		end
	end
	return false
end

function dgsWindowGetCloseButtonEnabled(window)
	assert(dgsGetType(window) == "dgs-dxwindow","Bad argument @dgsWindowGetCloseButtonEnabled at at argument 1, expect dgs-dxwindow got "..dgsGetType(window))
	return isElement(dgsElementData[window].closeButton)
end

function dgsWindowSetSizable(window,bool)
	assert(dgsGetType(window) == "dgs-dxwindow","Bad argument @dgsWindowSetSizable at at argument 1, expect dgs-dxwindow got "..dgsGetType(window))
	if dgsGetType(window) == "dgs-dxwindow" then
		dgsSetData(window,"sizable",(bool and true) or false)
		return true
	end
	return false
end

function dgsWindowSetMovable(window,bool)
	assert(dgsGetType(window) == "dgs-dxwindow","Bad argument @dgsWindowSetMovable at at argument 1, expect dgs-dxwindow got "..dgsGetType(window))
    if dgsGetType(window) == "dgs-dxwindow" then
		dgsSetData(window,"movable",(bool and true) or false)
		return true
	end
	return false
end

function dgsCloseWindow(window)
	assert(dgsGetType(window) == "dgs-dxwindow","Bad argument @dgsCloseWindow at at argument 1, expect dgs-dxwindow got "..dgsGetType(window))
	triggerEvent("onDgsWindowClose",window)
	local canceled = wasEventCancelled()
	triggerEvent("onClientDgsDxWindowClose",window)
	local canceled2 = wasEventCancelled()
	if not canceled and not canceled2 then
		return destroyElement(window)
	end
	return false
end