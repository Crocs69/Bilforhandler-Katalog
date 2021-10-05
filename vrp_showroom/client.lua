vRP = Proxy.getInterface("vRP")
vRPg = Proxy.getInterface("vRP_garages")

function deleteVehiclePedIsIn()
	local v = GetVehiclePedIsIn(GetPlayerPed(-1),false)
	SetVehicleHasBeenOwnedByPlayer(v,false)
	SetEntityAsMissionEntity(v, false, true) -- set not as mission entity
	SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(v))
	DeleteEntity(v)
end

local vehshop = {
	opened = false,
	title = "Bilforhandler",
	currentmenu = "Main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 },
	menu = {
		x = 0.13,
		y = 0.08,
		width = 0.26,
		height = 0.04,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.4,
		font = 0,
		["Main"] = {
			title = "Bilforhandler",
			name = "Main",
			buttons = {
				{name = "Biler", description = ''},
				{name = "Motorcykler", description = ''},
			}
		},
		["Biler"] = {
			title = "Biler",
			name = "Biler",
			buttons = {
				{name = "Mercedes", description = ''},
				{name = "Ferrai", description = ''}, -- Ferrai
				{name = "Porsche", description = ''},
				{name = "BMW", description = ''},
				{name = "Audi", description = ''},
				{name = "Bugatti", description = ''},
				{name = "Bentley", description = ''},
				{name = "Alt Muligt", description = ''},
				{name = "Chevrolet", description = ''},
				{name = "Lamborghini", description = ''},
				{name = "Custom Motorcykler", description = ''},
				--{name = "cycles", description = ''},
			}				
		},
		["Mercedes"] = {
			title = "Mercedes",
			name = "Mercedes",
			buttons = {
				{name = "Mercedes GT 63", costs = 3510000, description = {}, model = "rmodgt63"},
				{name = "Mercedes-Benz A45", costs = 1200000, description = {}, model = "a45amg"},
				{name = "Mercedes-Benz S500", costs = 1200000, description = {}, model = "s500w222"},
				{name = "Mercedes-Benz G65 AMG", costs = 5700000, description = {}, model = "g65amg"},
				{name = "Mercedes-Benz SL63", costs = 2700000, description = {}, model = "benzsl63"},
				{name = "Mercedes-Benz SLS", costs = 2700000, description = {}, model = "slsamg"},
				{name = "Mercedes-Benz GTRC", costs = 5950000, description = {}, model = "gtrc"},
				{name = "Mercedes-Benz C63S", costs = 7200000, description = {}, model = "c63s"},
			}
		},
		["Ferrai"] = {
			title = "Ferrai",
			name = "Ferrai",
			buttons = {
				{name = "Ferrari California", costs = 11400000, description = {}, model = "fc15"},
				{name = "Ferrari 599XX", costs = 8200000, description = {}, model = "599gtox"},
				{name = "Ferrari Fxx", costs = 12700000, description = {}, model = "fxxk"},
				{name = "Ferrari LaFerrai", costs = 22000111, description = {}, model = "aperta"},
			}
		},
		["Porsche"] = {
			title = "Porsche",
			name = "Porsche",
			buttons = {
				{name = "Porsche 718 Boxster", costs = 4200000, description = {}, model = "718boxster"},
				{name = "Porsche Panamera", costs = 5700000, description = {}, model = "panamera17turbo"},
				{name = "Porsche 911", costs = 5700000, description = {}, model = "911turboS"},
				{name = "Porsche GT3RS", costs = 8700000, description = {}, model = "pgt3"},
			}
		},
		["BMW"] = {
			title = "BMW",
			name = "BMW",
			buttons = {
				{name = "BMW I8", costs = 23200000, description = {}, model = "i8"},
				{name = "BMW X6M", costs = 2500000, description = {}, model = "x6m"},
				{name = "BMW M6 F13", costs = 2100000, description = {}, model = "m6f13"},
				{name = "BMW M5", costs = 5600000, description = {}, model = "bmci"},
				{name = "BMW M4 GTS", costs = 4300000, description = {}, model = "rmodm4gts"},
 
			}
		},
		["Audi"] = {
			title = "Audi",
			name = "Audi",
			buttons = {
				{name = "Audi S8", costs = 800000, description = {}, model = "audis8om"},
				{name = "Audi R8", costs = 13700000, description = {}, model = "r820"},
				{name = "Audi R8 Rally", costs = 14200000, description = {}, model = "r8lms"},
				{name = "Audi SQ7", costs = 8700000, description = {}, model = "sq72016"},
				{name = "Audi RS6", costs = 10200000, description = {}, model = "rs615"},
			}
		},
		["Bugatti"] = {
			title = "Bugatti",
			name = "Bugatti",
			buttons = {
				{name = "Bugatti Chiron", costs = 14900000, description = {}, model = "2019chiron"},
				{name = "Bugatti Veyron", costs = 22200000, description = {}, model = "bugatti"},
				{name = "Bugatti Divo", costs = 23600000, description = {}, model = "bdivo"},
			}
		},
		["Bentley"] = {
			title = "Bentley",
			name = "Bentley",
			buttons = {
				{name = "Bentley Gast", costs = 15800000, description = {}, model = "bentaygast"},
				{name = "Bentley Continental Range", costs = 12400000, description = {}, model = "contgt2011"},
			}
		},
		["Alt Muligt"] = {
			title = "Alt Muligt",
			name = "Alt Muligt",
			buttons = {
				{name = "Citroen 2CV", costs = 150000, description = {}, model = "gardenshed"},
				{name = "Dodge Viper", costs = 13900000, description = {}, model = "viper"},
				{name = "Hummer", costs = 2200002, description = {}, model = "h2m"},
				{name = "Zenyo", costs = 10500000, description = {}, model = "zn20"},
				{name = "Nissan GTR", costs = 6200000, description = {}, model = "gtrgt3"},
				{name = "Jeep SRT", costs = 2700000, description = {}, model = "srt8"},
				{name = "Jeep Demonhawk", costs = 4700000, description = {}, model = "demonhawk"},
				{name = "Koenigsegg Jes", costs = 10900000, description = {}, model = "jes"},
				{name = "Koenigsegg Agera", costs = 14000000, description = {}, model = "acsr"},
				{name = "Rolls Royce Wraith", costs = 10200000, description = {}, model = "wraith"},
				{name = "Mclaren Senna", costs = 8000000, description = {}, model = "senna"},
				{name = "Mclaren 720s", costs = 15700000, description = {}, model = "720s"},
				{name = "Toyota Supra", costs = 15200069, description = {}, model = "supra2"},
				{name = "Tesla Model X", costs = 6700000, description = {}, model = "telsax"},
			}
		},
		["Chevrolet"] = {
			title = "Chevrolet",
			name = "Chevrolet",
			buttons = {
				{name = "Chevrolet Corvette C7", costs = 2200000, description = {}, model = "c7"},
				{name = "Chevrolet Camaro", costs = 4700000, description = {}, model = "zl12017"},
				{name = "Chevrolet Corvette C8", costs = 15450000, description = {}, model = "c8"},
			}
		},
		["Lamborghini"] = {
			title = "Lamborghini",
			name = "Lamborghini",
			buttons = {
				{name = "Lamborghini Urus", costs = 10200000, description = {}, model = "urus2018"},
				{name = "Lamborghini Huracan", costs = 21200000, description = {}, model = "18performante"},
				{name = "Lamborghini Veneno", costs = 17500000, description = {}, model = "rmodveneno"},
				{name = "Lamborghini Aventador", costs = 19200001, description = {}, model = "lp700"},
				{name = "Lamborghini Sc18", costs = 18100000, description = {}, model = "sc18"},
			}
		},
		["Custom Motorcykler"] = {
			title = "Custom Motorcykler",
			name = "Custom Motorcykler",
			buttons = {
				{name = "Yamaha R1", costs = 700000, description = {}, model = "r1"},
				{name = "Yamaha R6", costs = 9700000, description = {}, model = "r6"},
				{name = "Ninja H2R", costs = 9200000, description = {}, model = "nh2r"},
				{name = "Agusta F4rr", costs = 8700000, description = {}, model = "f4rr"},
				{name = "BMW RR S1000", costs = 1100000, description = {}, model = "bmws"},
			}
		},
		["Motorcykler"] = {
			title = "Custom Motorcykler",
			name = "Custom Motorcykler",
			buttons = {
				{name = "Yamaha R1", costs = 700000, description = {}, model = "r1"},
				{name = "Yamaha R6", costs = 9700000, description = {}, model = "r6"},
				{name = "Ninja H2R", costs = 9200000, description = {}, model = "nh2r"},
				{name = "Agusta F4rr", costs = 8700000, description = {}, model = "f4rr"},
				{name = "BMW RR S1000", costs = 1100000, description = {}, model = "bmws"},
			}
		},
	}
}

local fakecar = {model = '', car = nil}
local vehshop_locations = {
	{entering = {-34.106288909912,-1102.6079101563,25.422351837158}, inside = {-75.298377990723,-819.39538574219,326.17517089844}, outside = {401.45742797852,-1633.4311523438,29.291929244995}},
}

local vehshop_blips ={}
local inrangeofvehshop = false
local currentlocation = nil
local boughtcar = false
local Rotation = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if vehshop.opened == true then
            DisableControlAction(1, 71, true)
            DisableControlAction(1, 72, true)
            DisableControlAction(1, 142, true)
            DisableControlAction(0, 21, true)
            DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
            DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
        end
    end
end)

function vehSR_drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

function DrawText3D(x,y,z, text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	if onScreen then
		SetTextScale(0.40, 0.40)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
		local factor = (string.len(text)) / 370
		DrawRect(_x,_y+0.0150, 0.035+ factor, 0.04, 0, 0, 0, 80)
	end
end

function vehSR_IsPlayerInRangeOfVehshop()
	return inrangeofvehshop
end

Citizen.CreateThread(function()
	vehSR_ShowVehshopBlips(true)
end)

function vehSR_ShowVehshopBlips(bool)
	if bool and #vehshop_blips == 0 then
		for station,pos in pairs(vehshop_locations) do
			local loc = pos
			pos = pos.entering
			local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
			-- 60 58 137
			SetBlipSprite(blip,326)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Bilforhandler")
			EndTextCommandSetBlipName(blip)
			SetBlipAsShortRange(blip,true)
			SetBlipScale(blip,0.6)
			SetBlipAsMissionCreatorBlip(blip,true)
			table.insert(vehshop_blips, {blip = blip, pos = loc})
		end
		Citizen.CreateThread(function()
			while #vehshop_blips > 0 do
				Citizen.Wait(0)
				local inrange = false
				for i,b in ipairs(vehshop_blips) do
					if IsPlayerWantedLevelGreater(GetPlayerIndex(),0) == false and vehshop.opened == false and IsPedInAnyVehicle(vehSR_LocalPed(), true) == false and  GetDistanceBetweenCoords(b.pos.entering[1],b.pos.entering[2],b.pos.entering[3],GetEntityCoords(vehSR_LocalPed())) < 2 then
						Rotation = Rotation - 0.2
						if Rotation <= 0 then
							Rotation = 360
						end
						DrawText3D(b.pos.entering[1],b.pos.entering[2],b.pos.entering[3]+1, "Tryk ~g~E ~w~for at tilgå kataloget")
						currentlocation = b
						inrange = true
					end
				end
				inrangeofvehshop = inrange
			end
		end)
	elseif bool == false and #vehshop_blips > 0 then
		for i,b in ipairs(vehshop_blips) do
			if DoesBlipExist(b.blip) then
				SetBlipAsMissionCreatorBlip(b.blip,false)
				Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
			end
		end
		vehshop_blips = {}
	end
end

function vehSR_f(n)
	return n + 0.0001
end

function vehSR_LocalPed()
	return GetPlayerPed(-1)
end

function vehSR_try(f, catch_f)
	local status, exception = pcall(f)
	if not status then
		catch_f(exception)
	end
end
function vehSR_firstToUpper(str)
	return (str:gsub("^%l", string.upper))
end
--local veh = nil
function vehSR_OpenCreator()
	boughtcar = false
	local ped = vehSR_LocalPed()
	local pos = currentlocation.pos.inside
	FreezeEntityPosition(ped,true)
	SetEntityVisible(ped,false)
	local g = Citizen.InvokeNative(0xC906A7DAB05C8D2B,pos[1],pos[2],pos[3],Citizen.PointerValueFloat(),0)
	SetEntityCoords(ped,pos[1],pos[2],g)
	SetEntityHeading(ped,pos[4])
	vehshop.currentmenu = "Main"
	vehshop.opened = true
	vehshop.selectedbutton = 0
end
local vehicle_price = 0
function vehSR_CloseCreator(vehicle,veh_type)
	Citizen.CreateThread(function()
		local ped = vehSR_LocalPed()
		if not boughtcar then
			local pos = currentlocation.pos.entering
			SetEntityCoords(ped,pos[1],pos[2],pos[3])
			FreezeEntityPosition(ped,false)
			SetEntityVisible(ped,true)
		else
			deleteVehiclePedIsIn()
			vRP.teleport({-17.242038726807,-1109.6545410156,26.672069549561,161.03179931641})
			vRPg.spawnBoughtVehicle({veh_type, vehicle})
			SetEntityVisible(ped,true)
			FreezeEntityPosition(ped,false)
		end
		vehshop.opened = false
		vehshop.menu.from = 1
		vehshop.menu.to = 10
	end)
end

function vehSR_drawMenuButton(button,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function vehSR_drawMenuTitle(txt,x,y)
	local menu = vehshop.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end
function vehSR_tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end
function vehSR_Notify(text)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function vehSR_drawMenuRight(txt,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 - 0.09, y - menu.height/2 + 0.0028)
end
local backlock = false
Citizen.CreateThread(function()
	local last_dir
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(0,38) and vehSR_IsPlayerInRangeOfVehshop() then
			if vehshop.opened then
				vehSR_CloseCreator("","")
			else
				vehSR_OpenCreator()
			end
		end
		if vehshop.opened then
			local ped = vehSR_LocalPed()
			local menu = vehshop.menu[vehshop.currentmenu]
			vehSR_drawTxt(vehshop.title,1,1,vehshop.menu.x,vehshop.menu.y,1.0, 255,255,255,255)
			vehSR_drawMenuTitle(menu.title, vehshop.menu.x,vehshop.menu.y + 0.08)
			vehSR_drawTxt(vehshop.selectedbutton.."/"..vehSR_tablelength(menu.buttons),0,0,vehshop.menu.x + vehshop.menu.width/2 - 0.0385,vehshop.menu.y + 0.067,0.4, 255,255,255,255)
			local y = vehshop.menu.y + 0.12
			buttoncount = vehSR_tablelength(menu.buttons)
			local selected = false

			for i,button in pairs(menu.buttons) do
				if i >= vehshop.menu.from and i <= vehshop.menu.to then

					if i == vehshop.selectedbutton then
						selected = true
					else
						selected = false
					end
					vehSR_drawMenuButton(button,vehshop.menu.x,y,selected)
					if button.costs ~= nil then
						if vehshop.currentmenu == "Ferrai" or vehshop.currentmenu == "Eksklusiv" or vehshop.currentmenu == "Porsche" or vehshop.currentmenu == "Custom Motorcykler" or vehshop.currentmenu == "BMW" or vehshop.currentmenu == "Audi" or vehshop.currentmenu == "Bugatti" or vehshop.currentmenu == "Bentley" or vehshop.currentmenu == "Alt Muligt" or vehshop.currentmenu == "Chevrolet" or vehshop.currentmenu == "Lamborghini" or vehshop.currentmenu == "Custom Biler" or vehshop.currentmenu == "Mercedes" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "Motorcykler" then
							if button.costs == 0 then
								vehSR_drawMenuRight("Find forhandler",vehshop.menu.x-0.01,y,selected)
							else
								vehSR_drawMenuRight(button.costs.." DKK",vehshop.menu.x,y,selected)
							end
						else
							vehSR_drawMenuButton(button,vehshop.menu.x,y,selected)
						end
					end
					y = y + 0.04
					if vehshop.currentmenu == "Ferrai" or vehshop.currentmenu == "Eksklusiv" or vehshop.currentmenu == "Porsche" or vehshop.currentmenu == "Custom Motorcykler" or vehshop.currentmenu == "BMW" or vehshop.currentmenu == "Audi" or vehshop.currentmenu == "Bugatti" or vehshop.currentmenu == "Bentley" or vehshop.currentmenu == "Alt Muligt" or vehshop.currentmenu == "Chevrolet" or vehshop.currentmenu == "Lamborghini" or vehshop.currentmenu == "Custom Biler" or vehshop.currentmenu == "Mercedes" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "Motorcykler" then
						if selected then
							if fakecar.model ~= button.model then
								if DoesEntityExist(fakecar.car) then
									DeleteEntity(fakecar.car)
								end
								local pos = currentlocation.pos.inside
								local hash = GetHashKey(button.model)
								RequestModel(hash)
								local timer = 0
								while not HasModelLoaded(hash) and timer < 255 do
									Citizen.Wait(1)
									vehSR_drawTxt("Indlæser...",0,1,0.5,0.5,1.5,255,255-timer,255-timer,255)
									RequestModel(hash)
									timer = timer + 1
								end
								if timer < 255 then
									local veh = CreateVehicle(hash,pos[1],pos[2],pos[3],pos[4],false,false)
									while not DoesEntityExist(veh) do
										Citizen.Wait(1)
										vehSR_drawTxt("Indlæser...",0,1,0.5,0.5,1.5,255,255-timer,255-timer,255)
									end
									FreezeEntityPosition(veh,true)
									SetEntityInvincible(veh,true)
									SetVehicleDoorsLocked(veh,4)
									--SetEntityCollision(veh,false,false)
									TaskWarpPedIntoVehicle(vehSR_LocalPed(),veh,-1)
									for i = 0,24 do
										SetVehicleModKit(veh,0)
										RemoveVehicleMod(veh,i)
									end
									fakecar = { model = button.model, car = veh}
								else
									timer = 0
									while timer < 50 do
										Citizen.Wait(1)
										vehSR_drawTxt("Vent venligst!",0,1,0.5,0.5,1.5,255,0,0,255)
										timer = timer + 1
									end
									if last_dir then
										if vehshop.selectedbutton < buttoncount then
											vehshop.selectedbutton = vehshop.selectedbutton +1
											if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
												vehshop.menu.to = vehshop.menu.to + 1
												vehshop.menu.from = vehshop.menu.from + 1
											end
										else
											last_dir = false
											vehshop.selectedbutton = vehshop.selectedbutton -1
											if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
												vehshop.menu.from = vehshop.menu.from -1
												vehshop.menu.to = vehshop.menu.to - 1
											end
										end
									else
										if vehshop.selectedbutton > 1 then
											vehshop.selectedbutton = vehshop.selectedbutton -1
											if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
												vehshop.menu.from = vehshop.menu.from -1
												vehshop.menu.to = vehshop.menu.to - 1
											end
										else
											last_dir = true
											vehshop.selectedbutton = vehshop.selectedbutton +1
											if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
												vehshop.menu.to = vehshop.menu.to + 1
												vehshop.menu.from = vehshop.menu.from + 1
											end
										end
									end
								end
							end
						end
					end
					if selected and IsControlJustPressed(1,201) then
						vehSR_ButtonSelected(button)
					end
				end
			end
			if IsControlJustPressed(1,202) then
				vehSR_Back()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				last_dir = false
				if vehshop.selectedbutton > 1 then
					vehshop.selectedbutton = vehshop.selectedbutton -1
					if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
						vehshop.menu.from = vehshop.menu.from -1
						vehshop.menu.to = vehshop.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				last_dir = true
				if vehshop.selectedbutton < buttoncount then
					vehshop.selectedbutton = vehshop.selectedbutton +1
					if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
						vehshop.menu.to = vehshop.menu.to + 1
						vehshop.menu.from = vehshop.menu.from + 1
					end
				end
			end
		end

	end
end)


function vehSR_round(num, idp)
	if idp and idp>0 then
		local mult = 10^idp
		return math.floor(num * mult + 0.5) / mult
	end
	return math.floor(num + 0.5)
end
function vehSR_ButtonSelected(button)
	local ped = GetPlayerPed(-1)
	local this = vehshop.currentmenu
	local btn = button.name
	if this == "Main" then
		if btn == "Biler" then
			vehSR_OpenMenu('Biler')
		elseif btn == "Motorcykler" then
			vehSR_OpenMenu('Motorcykler')
		end
	elseif this == "Biler" then
		if btn == "BMW" then
			vehSR_OpenMenu('BMW')
		elseif btn == "Custom Motorcykler" then
			vehSR_OpenMenu('Custom Motorcykler')
		elseif btn == "Ferrai" then
			vehSR_OpenMenu('Ferrai')
		elseif btn == "Eksklusiv" then
			vehSR_OpenMenu('Eksklusiv')
		elseif btn == "Porsche" then
			vehSR_OpenMenu('Porsche')
		elseif btn == "Audi" then
			vehSR_OpenMenu("Audi")
		elseif btn == "Bugatti" then
			vehSR_OpenMenu('Bugatti')
		elseif btn == "Bentley" then
			vehSR_OpenMenu('Bentley')
		elseif btn == "Alt Muligt" then
			vehSR_OpenMenu('Alt Muligt')
		elseif btn == "Chevrolet" then
			vehSR_OpenMenu('Chevrolet')
		elseif btn == "Lamborghini" then
			vehSR_OpenMenu('Lamborghini')
		elseif btn == "Custom Biler" then
			vehSR_OpenMenu('Custom Biler')
		elseif btn == "Mercedes" then
			vehSR_OpenMenu('Mercedes')			
		end
	elseif this == "Ferrai" or this == "Eksklusiv" or this == "Porsche" or this == "Custom Motorcykler" or this == "BMW" or this == "Audi" or this == "Bugatti" or this == "Bentley" or this == "Alt Muligt" or this == "Chevrolet" or this == "Lamborghini" or this == "Custom Biler" or this == "Mercedes" or this == "industrial" then
		TriggerServerEvent('veh_SR:CheckMoneyForVeh',button.model,button.costs, "car")
	elseif this == "cycles" or this == "Motorcykler" then
		TriggerServerEvent('veh_SR:CheckMoneyForVeh',button.model,button.costs, "bike")
	end
end

RegisterNetEvent('veh_SR:CloseMenu')
AddEventHandler('veh_SR:CloseMenu', function(vehicle, veh_type)
	boughtcar = true
	vehSR_CloseCreator(vehicle,veh_type)
end)

function vehSR_OpenMenu(menu)
	fakecar = {model = '', car = nil}
	vehshop.lastmenu = vehshop.currentmenu
	if menu == "Biler" then
		vehshop.lastmenu = "Main"
	elseif menu == "bikes"  then
		vehshop.lastmenu = "Main"
	elseif menu == 'race_create_objects' then
		vehshop.lastmenu = "Main"
	elseif menu == "race_create_objects_spawn" then
		vehshop.lastmenu = "race_create_objects"
	end
	vehshop.menu.from = 1
	vehshop.menu.to = 10
	vehshop.selectedbutton = 0
	vehshop.currentmenu = menu
end


function vehSR_Back()
	if backlock then
		return
	end
	backlock = true
	if vehshop.currentmenu == "Main" then
		vehSR_CloseCreator("","")
	elseif vehshop.currentmenu == "Ferrai" or vehshop.currentmenu == "Eksklusiv" or vehshop.currentmenu == "Porsche" or vehshop.currentmenu == "Custom Motorcykler" or vehshop.currentmenu == "BMW" or vehshop.currentmenu == "Audi" or vehshop.currentmenu == "Bugatti" or vehshop.currentmenu == "Bentley" or vehshop.currentmenu == "Alt Muligt" or vehshop.currentmenu == "Chevrolet" or vehshop.currentmenu == "Lamborghini" or vehshop.currentmenu == "Custom Biler" or vehshop.currentmenu == "Mercedes" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "Motorcykler" then
		if DoesEntityExist(fakecar.car) then
			DeleteEntity(fakecar.car)
		end
		fakecar = {model = '', car = nil}
		vehSR_OpenMenu(vehshop.lastmenu)
	else
		vehSR_OpenMenu(vehshop.lastmenu)
	end

end

function vehSR_stringstarts(String,Start)
	return string.sub(String,1,string.len(Start))==Start
end
