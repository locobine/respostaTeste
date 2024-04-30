buttonJumpButton = nil
buttonJumpWindow = nil


function init()
  buttonJumpButton = modules.client_topmenu.addRightToggleButton('buttonJumpButton', tr('Button Jump'), '/images/topbuttons/buttonjump', closing) -- Sets the button with the rest of the top-right buttons of the UI.
  buttonJumpButton:setOn(false)

  buttonJumpWindow = g_ui.displayUI('buttonjump')
  buttonJumpWindow:setVisible(false)

  --get help values
  allTabs = buttonJumpWindow:recursiveGetChildById('allTabs')
  allTabs:setContentWidget(buttonJumpWindow:getChildById('optionsTabContent'))
  
  onlybutton = buttonJumpWindow:recursiveGetChildById('Jump') -- Initially the button sets it's margins by it's father class, so I manually get it by calling by it's ID and set it to a different margin.
  onlybutton:setMarginRight(buttonJumpWindow:getMarginRight() + 20) -- It's +20 because since it's the right margin, and the button width is 40, I had to ajust so he was inside the window.
  onlybutton:setMarginTop(buttonJumpWindow:getMarginTop() + math.random(20, 200))
  
  connect(g_app, { onTeste = moveButton })  -- Binds it to the luacallback on the code, where i implemented a calculation to when 100ms has elapsed.
end

function terminate()
  buttonJumpButton:destroy()
  buttonJumpWindow:destroy()
  disconnect(g_app, { onTeste = moveButton })
end

function closing()
  if buttonJumpButton:isOn() then
    buttonJumpWindow:setVisible(false)
    buttonJumpButton:setOn(false)
  else
    buttonJumpWindow:setVisible(true)
    buttonJumpButton:setOn(true)
  end
end

function moveButton()
	if buttonJumpWindow:isVisible() then
		onlybutton:setMarginRight(onlybutton:getMarginRight() + 2)  -- Move the margin, moving the button 2 units to the left.
		if onlybutton:getMarginRight() > (buttonJumpWindow:getMarginRight() + 170) then  -- If he gets more than 170 units away from the initial position, I reset it and set the Y randomly between 20 and 200
			onlybutton:setMarginRight(buttonJumpWindow:getMarginLeft() + 20) -- It's +20 because since it's the right margin, and the button width is 40, I had to ajust so he was inside the window.
			onlybutton:setMarginTop(buttonJumpWindow:getMarginTop() + math.random(20, 200)) -- Set the top margin randomly between 20 and 200
		end
	end
end

function action()
local protocolGame = g_game.getProtocolGame()
  if buttonJumpButton:isOn() then
  if protocolGame then
  
    end
  else
    buttonJumpWindow:setVisible(true)
    buttonJumpButton:setOn(true)
  end
	onlybutton:setMarginRight(buttonJumpWindow:getMarginLeft() + 20) -- Do the same thing of the moveButton when it reaches the other end of the window, but when you click it.
	onlybutton:setMarginTop(buttonJumpWindow:getMarginTop() + math.random(20, 200))
end

function onMiniWindowClose()
  buttonJumpButton:setOn(false)

end