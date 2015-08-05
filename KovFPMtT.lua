require "base/internal/ui/reflexcore"

-- This Widget is "Frags Per Minute to Tie"
-- It displays a small graphic to indicate how close the game is in terms of the difference of frags and the remaining time.  If you need 10 frags per minute to win, the graph is going to let you know that you've probably already lost.

KovFPMtT =
{
};
registerWidget("KovFPMtT");

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function KovFPMtT:draw()
 
    -- Early out if HUD shouldn't be shown.
    if not shouldShowHUD() then return end;
	
	-- Early out if not in 1v1 mode
	if world.gameModeIndex ~= 2 then return end;

    -- Find player 
    local player = getPlayer()

    local fontSize = 40
    local gaugeMaxFPM = 5
	local rectHeight = 160
	local rectWidth = 70

    -- Colors
	local transparency = 120
    local textColor = Color(255,255,255,255);

    local BackgroundColor = Color(0,0,0,transparency);
    local FarAhead = Color(60,80,255,255);
    local CloseAhead = Color(0,170,0,255);
    local CloseBehind = Color(255,255,0,255);
    local FarBehind = Color(255,0,0,255);
   
    local gaugeTickColor = Color(255,255,255,80);

    -- Draw gauge background
    nvgBeginPath();
	nvgRect(-rectWidth/2,-rectHeight/2,rectWidth,rectHeight)
    nvgFillColor(BackgroundColor);
    nvgFill();

	local myFrags = 0
	local enemyFrags = 0
	for p,player in pairs(players) do
		if player.connected and player.state == PLAYER_STATE_INGAME then
			if player == getPlayer() then
				myFrags = player.score
			else
				enemyFrags = player.score
			end
		end
	end

	local timeLeft = (world.gameTimeLimit - world.gameTime)/1000/60

	local FPM = (myFrags-enemyFrags)/(timeLeft)

	FPM = math.min(FPM, gaugeMaxFPM)
	FPM = math.max(FPM, -gaugeMaxFPM)
	
	local graphColor
	if FPM > gaugeMaxFPM/2 then
		graphColor = FarAhead
	elseif FPM > 0 then
		graphColor = CloseAhead
	elseif FPM > -gaugeMaxFPM/2 then
		graphColor = CloseBehind
	else
		graphColor = FarBehind
	end
	
	if world.gameState ~= 1 then -- only display when a real game is going on
		FPM = 0
	end
	
	-- Draw the first color
    nvgBeginPath();
	nvgRect(-rectWidth/2,0,rectWidth,-FPM/gaugeMaxFPM*rectHeight/2)
    nvgFillColor(graphColor);
    nvgFill();
	
	--local tickMarkRange = 
    -- Draw gauge tick line at the edge
	--[[
    for i=-rectHeight/2, rectHeight/2, rectHeight/10 do
        nvgBeginPath();
		nvgRect(-rectWidth/2+2,i,rectWidth-4,2)
        nvgFillColor(gaugeTickColor);
        nvgFill();
    end
	--]]
	
	--[[
	nvgFontSize(fontSize);
    nvgFontFace("TitilliumWeb-Bold");
    nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_MIDDLE);
    nvgFontBlur(0);
    nvgFillColor(textColor);
    nvgText(0, 0, world.gameState);
	--]]



end

