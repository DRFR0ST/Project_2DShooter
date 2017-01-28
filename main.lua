--[[
	Script by
		 ________  ________  ________ ________  ________  ________  _________   
		|\   ___ \|\   __  \|\  _____\\   __  \|\   __  \|\   ____\|\___   ___\ 
		\ \  \_|\ \ \  \|\  \ \  \__/\ \  \|\  \ \  \|\  \ \  \___|\|___ \  \_| 
		 \ \  \ \\ \ \   _  _\ \   __\\ \   _  _\ \  \\\  \ \_____  \   \ \  \  
		  \ \  \_\\ \ \  \\  \\ \  \_| \ \  \\  \\ \  \\\  \|____|\  \   \ \  \ 
		   \ \_______\ \__\\ _\\ \__\   \ \__\\ _\\ \_______\____\_\  \   \ \__\
		    \|_______|\|__|\|__|\|__|    \|__|\|__|\|_______|\_________\   \|__|
		                                                    \|_________|        
	Copyright © 2017, Mike Eling (#DRFR0ST)
]]

--[[
  __  __       _       
 |  \/  |     (_)      
 | \  / | __ _ _ _ __  
 | |\/| |/ _` | | '_ \ 
 | |  | | (_| | | | | |
 |_|  |_|\__,_|_|_| |_|

]]
                              
function love.load()
	--[[ Window & Mouse ]]--
		Window = {
			width = love.window.getWidth(),
			height = love.window.getHeight(),
			focus = love.window.hasFocus(),
		}
		
		Mouse = {
			x = love.mouse.getX(),
			y = love.mouse.getY(),
		}

		love.mouse.setVisible(false);
	--[[ ----- - ----- ]]--

	--[[ Environment ]]--
		Environment = {
			gun = {
				x = love.mouse.getX() * 2,
				y = love.mouse.getY() * 2,
				r = 0;
				img = love.graphics.newImage("gfx/gun.png"),
				bullets = 6,
				sfx = {
					shot = love.audio.newSource( "/sfx/shot.wav", "stream" ),
					empty = love.audio.newSource( "/sfx/emptygun.mp3", "stream" ),
					reload = love.audio.newSource( "/sfx/gunreload.mp3", "stream" ),
				},
				aim = {
					x = Mouse.x + (178/2),
					y = Mouse.y + (178/2),
					img = love.graphics.newImage("gfx/celownik.png"),
					recoil = 0.0,
				},
				fire = {},
			},
			background = {
				img = love.graphics.newImage("gfx/background1.png"),
			},
			holes = {},
		}

		Environment.background.img = love.graphics.newImage("gfx/background"..love.math.random(1,2)..".png");
	--[[ ----------- ]]--

	--[[ Settings ]]--
		fpsGraph = require "FPSGraph"
		fps = fpsGraph.createGraph()

		Sound = {
			on = true,
		}
	--[[ -------- ]]--
 end

 function love.update( dt )
	 	Window.width = love.window.getWidth()
		Window.height = love.window.getHeight()
		Mouse.x = love.mouse.getX()
		Mouse.y = love.mouse.getY()
	--[[ ----- - ----- ]]--


		Environment.gun.x = Mouse.x * 1.1 + (Environment.gun.img:getWidth() / 2) + (Environment.gun.img:getWidth() / 3.5);
		Environment.gun.y = Mouse.y * 1.1 + (Environment.gun.img:getHeight() / 2) + (Environment.gun.img:getHeight() / 20);

		Environment.gun.aim.x = Mouse.x;
		Environment.gun.aim.y = Mouse.y - Environment.gun.aim.recoil;

		local i, o
		for i, o in ipairs(Environment.holes) do
			o.expiretime = o.expiretime - (1.5 * dt);
			if(o.expiretime <= 0) then
				table.remove(Environment.holes, i);
			end
		end

		local g, f
		for g, f in ipairs(Environment.gun.fire) do
			f.expiretime = f.expiretime - (1.5 * dt);
			if(f.expiretime <= 0) then
				table.remove(Environment.gun.fire, g);
			end
		end

		if(Environment.gun.r > 0) then
			Environment.gun.r = Environment.gun.r - 0.09;
		end

		if(Environment.gun.aim.recoil > 0) then
			Environment.gun.aim.recoil = Environment.gun.aim.recoil - 1;
		end

		fpsGraph.updateFPS(fps, dt)
	--[[ -------- ]]--
 end


 function love.draw()
 		fpsGraph.drawGraphs({fps})
 	--[[ -------- ]]--

 	love.graphics.push()
	love.graphics.scale(1.65, 1.65)
	love.graphics.draw(Environment.background.img, Window.width / 2, Window.height / 2, 0, 1, 1, Window.width / 2, Window.height / 2)
	love.graphics.pop()

	local i, o
	for i, o in ipairs(Environment.holes) do
		love.graphics.push()
		love.graphics.scale(0.8, 0.8)
		love.graphics.draw(o.img, o.x, o.y, o.r, 1, 1, o.img:getWidth()/5.8, o.img:getHeight()/3.8);
		love.graphics.pop()
	end

	local g, f
	for g, f in ipairs(Environment.gun.fire) do
		love.graphics.push()
		love.graphics.scale(0.8, 0.8)
		love.graphics.draw(f.img, f.x, f.y, f.r, 1, 1, f.img:getWidth()/2, f.img:getHeight()/2);
		love.graphics.pop()
	end

	love.graphics.push()
	love.graphics.scale(0.85, 0.85)
 	love.graphics.draw(Environment.gun.img, Environment.gun.x, Environment.gun.y, Environment.gun.r, 1, 1, Environment.gun.img:getWidth()/2, Environment.gun.img:getHeight()/2 );
 	love.graphics.pop()

 	love.graphics.draw(Environment.gun.aim.img, Environment.gun.aim.x, Environment.gun.aim.y, 0, 1, 1, Environment.gun.aim.img:getWidth()/2, Environment.gun.aim.img:getHeight()/2 );
 	
 	if(Environment.gun.bullets <= 0) then
 		love.graphics.print("- Press R to reload! -", 1024/2 - 20, 768 - 20);
 	end

  	love.graphics.print("Copyright © 2017, Mike '#DRFR0ST' Eling", 10, 10)
 end

--[[
  _____                   _       
 |_   _|                 | |      
   | |  _ __  _ __  _   _| |_ ___ 
   | | | '_ \| '_ \| | | | __/ __|
  _| |_| | | | |_) | |_| | |_\__ \
 |_____|_| |_| .__/ \__,_|\__|___/
             | |                  
             |_|                  
]]

function love.keypressed( key, isrepeat )
	if(key == "r")then
		if(Environment.gun.bullets <= 0) then
			Environment.gun.bullets = 6;
			playMusic(Environment.gun.sfx.reload);
		end
	end
end

function love.keyreleased( key )

end

function love.textinput( text )

end

function love.mousefocus( f )

end

function love.mousepressed( x, y, button )
	if(button == "l") then
		if(Environment.gun.bullets > 0)then
			Environment.gun.bullets = Environment.gun.bullets - 1;
			Environment.gun.r = 1.0;
			Environment.gun.aim.recoil = 10.0;
			playMusic(Environment.gun.sfx.shot);
			CreateFire(Environment.gun.x - Environment.gun.img:getWidth() / 2.8, Environment.gun.y - Environment.gun.img:getHeight()/2.3);
			CreateHole(x, y + Environment.gun.aim.recoil);
		else
			playMusic(Environment.gun.sfx.empty);
		end
	end
end

function love.mousereleased( x, y, button )
	if (key == "m") then
		if Sound.on == true then
			Sound.on = false;
		else
			Sound.on = true;
		end
	end
end

--[[
 __          ___           _               
 \ \        / (_)         | |              
  \ \  /\  / / _ _ __   __| | _____      __
   \ \/  \/ / | | '_ \ / _` |/ _ \ \ /\ / /
    \  /\  /  | | | | | (_| | (_) \ V  V / 
     \/  \/   |_|_| |_|\__,_|\___/ \_/\_/                                             
]]

function love.focus( f )

end

function love.visible( v )

end

function love.resize( w, h )

end

function love.threaderror( thread, errorstr )

end

function love.quit()

end

 --[[
  ______                _   _                 
 |  ____|              | | (_)                
 | |__ _   _ _ __   ___| |_ _  ___  _ __  ___ 
 |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
 | |  | |_| | | | | (__| |_| | (_) | | | \__ \
 |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/                                            
 ]]

function CreateHole(x, y)
		rand = love.math.random(1, 4);
		randomimg = love.graphics.newImage("gfx/holes/hole0"..rand..".png");

		table.insert(Environment.holes, {
			x = x,
			y = y,
			r = 0,
			img = randomimg,
			expiretime = 7.0,
		})
end

function CreateFire(x, y)
	table.insert(Environment.gun.fire, {
		x = x,
		y = y,
		r = 1.0,
		img = love.graphics.newImage("gfx/gunfire.png"),
		expiretime = 0.07,
	})
end

function playMusic( source )
	if Sound.on == true then
		love.audio.stop(source);
		love.audio.play(source);
	end
end
 --[[
 ____________________________________
/                                    \

	$$$$$$$$\  $$$$$$\   $$$$$$\  
	$$  _____|$$  __$$\ $$  __$$\ 
	$$ |      $$ /  $$ |$$ /  \__|
	$$$$$\    $$ |  $$ |\$$$$$$\  
	$$  __|   $$ |  $$ | \____$$\ 
	$$ |      $$ |  $$ |$$\   $$ |
	$$$$$$$$\  $$$$$$  |\$$$$$$  |
	\________| \______/  \______/ 
                              
\____________________________________/
]]