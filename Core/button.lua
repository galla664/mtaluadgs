function dgsCreateButton(x,y,sx,sy,text,relative,parent,textcolor,scalex,scaley,defimg,selimg,cliimg,defcolor,selcolor,clicolor)
	assert(tonumber(x),"Bad argument @dgsCreateButton at argument 1, expect number got "..type(x))
	assert(tonumber(y),"Bad argument @dgsCreateButton at argument 2, expect number got "..type(y))
	assert(tonumber(sx),"Bad argument @dgsCreateButton at argument 3, expect number got "..type(sx))
	assert(tonumber(sy),"Bad argument @dgsCreateButton at argument 4, expect number got "..type(sy))
	if isElement(parent) then
		assert(dgsIsDxElement(parent),"Bad argument @dgsCreateButton at argument 7, expect dgs-dxgui got "..dgsGetType(parent))
	end
	local button = createElement("dgs-dxbutton")
	dgsSetType(button,"dgs-dxbutton")
	local _x = dgsIsDxElement(parent) and dgsSetParent(button,parent,true) or table.insert(MaxFatherTable,1,button)
	defcolor,selcolor,clicolor = defcolor or schemeColor.button.color[1],selcolor or schemeColor.button.color[2],clicolor or schemeColor.button.color[3]
	dgsSetData(button,"image",{defimg,selimg,cliimg})
	dgsSetData(button,"color",{defcolor,selcolor,clicolor})
	dgsSetData(button,"text",tostring(text))
	dgsSetData(button,"textcolor",textcolor or schemeColor.button.textcolor)
	dgsSetData(button,"textsize",{tonumber(scalex) or 1,tonumber(scaley) or 1})
	dgsSetData(button,"shadow",{_,_,_})
	dgsSetData(button,"font",systemFont)
	dgsSetData(button,"clickoffset",{0,0})
	dgsSetData(button,"clip",false)
	dgsSetData(button,"clickType",1)
	dgsSetData(button,"wordbreak",false)
	dgsSetData(button,"colorcoded",false)
	dgsSetData(button,"rightbottom",{"center","center"})
	dgsSetData(button,"textoffset",{0,0})

	insertResourceDxGUI(sourceResource,button)
	triggerEvent("onDgsPreCreate",button)
	calculateGuiPositionSize(button,x,y,relative or false,sx,sy,relative or false,true)
	triggerEvent("onDgsCreate",button)
	return button
end
