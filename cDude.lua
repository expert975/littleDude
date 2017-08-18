--[[
	LittleDude:
		This script shows how to draw a relative distance indicator in MTA


	Copyright 2017 Rodrigo Martins

	This program is free software: you can redistribute it and/or modify
		it under the terms of the GNU General Public License as published by
		the Free Software Foundation, either version 3 of the License, or
		(at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program. If not, see <http://www.gnu.org/licenses/>.
]]

local safeZoneRadius = 10 --radius of our safe zone
local maxDistance = 100 --max distance represented by littleDude
local littleDudeDistance = maxDistance --relative distance from littleDude to safe area
local distanceToSafeArea --distance from player to safe area
local screenx, screeny = guiGetScreenSize() --screen size
local safeAreaCol = createColSphere(0, 0, 3, safeZoneRadius) --our safe area

-- Create graphs
guiCreateStaticImage (.7, .89, .07, .07, "img/dangerArea.png", true) --starting position
guiCreateStaticImage (.9, .89, .07, .07, "img/safeArea.png", true) --finishing position
local littleDude = guiCreateStaticImage (.7, .89, .07, .07, "img/running.png", true) --our littledude


local function mapValues(x, in_min, in_max, out_min, out_max) --rescales values
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

local getDistanceBetweenPoints2D = getDistanceBetweenPoints2D
local localPlayer = localPlayer
local math = math
local function calculateLittleDudeDistance()
	local px, py = localPlayer.position.x, localPlayer.position.y --player coordinates
	local sx, sy = safeAreaCol.position.x, safeAreaCol.position.y --safe area coords
	distanceToSafeArea = (getDistanceBetweenPoints2D(px, py, sx, sy) - safeZoneRadius > 0) and
	getDistanceBetweenPoints2D(px, py, sx, sy) - safeZoneRadius or 0 --show positive or 0
	if distanceToSafeArea > maxDistance then --if too far
		return .7 --stay at max
	else
		return mapValues(distanceToSafeArea, 0, maxDistance, .9, .7) --calculate relative distance
	end
end

local guiSetPosition = guiSetPosition
local dxDrawText = dxDrawText
local function moveLittleDude() --moves littleDude
	littleDudeDistance = calculateLittleDudeDistance()
	guiSetPosition(littleDude, littleDudeDistance, .89, true) --set littleDudes position
	dxDrawText(math.floor(distanceToSafeArea), screenx*(littleDudeDistance + .027) , screeny*.96) --draw distance
end
addEventHandler("onClientRender", root, moveLittleDude)
