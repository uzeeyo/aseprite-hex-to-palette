function extractClipboardColor()
	local dlg = Dialog()
	dlg:entry{ id="palette_name", label="Palette name:", text="Name" }
	dlg:entry{ id="user_value", label="Hex values:", text="Colors" }
	dlg:button{ id="confirm", text="Confirm"}
	dlg:button{ id="cancel", text="Cancel" }
	dlg:show()

	if dlg.data.confirm then
		local colors = parse(dlg.data.user_value)
		if #colors == 0 then
			notifyColorsNotFound()
			return nil
		end

		addToPalette(dlg.data.palette_name, colors)
		
	end
	
	
end

function parse(input)
	local colorsArray = {}
    for color in input:gmatch("#?(%x%x%x%x%x%x),?") do
    
        if color:sub(1, 1) ~= "#" then
            color = "#" .. color
        end

        table.insert(colorsArray, color)
    end
    
    return colorsArray
end

function notifyColorsNotFound()
	app.alert("No colors found in input")
end

function addToPalette(name, colors)
	local numberOfColors = #colors
	local palette = Palette(numberOfColors)
	for index, color in ipairs(colors) do
		local rgbColor = hexToColor(color) 
		palette:setColor(index-1, rgbColor)
	end

	name = "data/palettes/" .. name .. ".gpl"
	palette:saveAs(name)
end

function hexToColor(hex)
	hex = hex:gsub("#", "")
	local rc = tonumber("0x" .. hex:sub(1, 2))
	local gc = tonumber("0x" .. hex:sub(3, 4))
	local bc = tonumber("0x" .. hex:sub(5, 6))
	
	local c = Color{ r=rc, g=gc, b=bc }
	return c
end

app.transaction(
	extractClipboardColor()
)

