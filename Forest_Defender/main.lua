window_width=1300
window_height=750


player={}
player.width=32
player.height=72
player.x=300
player.y=600
player.speed=500
player.health=10
player.max_health=10

all_bullets={}
all_enemy={}
math.randomseed(os.time())


function createbullet()
  local bullet={}
  bullet.width=5
  bullet.height=10
  bullet.x=player.x+(player.width/2)-(bullet.width/2)
  bullet.y=player.y-bullet.height
  bullet.speed=400
  return (bullet)
end

-- function Collision(v,k)
--     return v.x<
-- end 
function collision(v,k)
  return v.x<k.x+k.width and
        v.x+v.width>k.x and
        v.y<k.y+k.height and
        v.y+v.height>k.y
        

end
function create_enemy()
  enemy={}
  enemy.width=60
  enemy.height=60
  enemy.x=math.random(0,900-enemy.width)
  enemy.y=-enemy.height
  enemy.speed=300
  return (enemy)
end

function love.load()
  love.window.setMode(window_width,window_height)
  timer=0
  score=0
  enemy_timer=0
  state="menu"
  background=love.graphics.newImage('Images/bg final.jpg')
  enemy_image=love.graphics.newImage('Images/Zombie final.png')
  player_image=love.graphics.newImage('Images/canon final.png')
  right_menu=love.graphics.newImage('Images/menu.jpg')
  main_menu=love.graphics.newImage('Images/main menu.jpg')
  exit_image=love.graphics.newImage('Images/end.jpg')

  sound=love.audio.newSource('Extra/background_sound.mp3','stream')
  sound:setLooping(true)
  sound:setVolume(0.5)
  sound:play()
end

function love.update(dt)
  if(state=="play")then
    timer=timer+dt
    enemy_timer=enemy_timer+dt
    if(love.keyboard.isDown('a'))then
      player.x=player.x-player.speed*dt
    end
    if(love.keyboard.isDown('d'))then
      player.x=player.x+player.speed*dt
    end
    if(player.x<0)then
      player.x=0
    end
    if(player.x>900-player.width)then
      player.x=900-player.width
    end
    if(timer>0.1)then
      table.insert(all_bullets,createbullet())
      timer=0
    end
    if(enemy_timer>0.4)then
      table.insert(all_enemy,create_enemy())
      enemy_timer=0
    end
    -- bullet update
    for k,v in pairs(all_bullets)do
      v.y=v.y-v.speed*dt
    end
    -- 
    -- enemy update
    for k,v in pairs(all_enemy)do
      v.y=v.y+v.speed*dt
    end
    -- 
    for k,v in pairs(all_bullets)do
      if(v.y<-v.height)then
        table.remove(all_bullets,k)
      end
    end

    for k,v in pairs(all_enemy)do
      if(v.y>player.y+50)then
        table.remove(all_enemy,k)
        player.health=player.health-1
      end
    end

    for k,v in pairs(all_bullets)do
      for keys,values in pairs(all_enemy)do
        if(collision(v,values))then
          table.remove(all_enemy,keys)
          table.remove(all_bullets,k)
          score=score+1

        end
      end
    end
    if(player.health==0)then
      state="end"
    end

  elseif(state == "end") then 
    all_bullets={}
    all_enemy={}
    player.health=player.max_health
  
  elseif(state == "menu")then
      player.health=player.max_health
      score=0
  


  

  
  end
end

function love.keypressed(key)

  if key == 'escape' then
      love.event.quit()
  end
  if state=="menu" and key=="return" then
    state="play"
  end

  if state == "end" and key == "return" then
    state="menu"
  end 

end

function love.draw()
  

  if state == "menu" then 
    love.graphics.draw(main_menu,0,0)
  elseif state == "end" then 
    love.graphics.draw(exit_image,0,0)
    love.graphics.setColor(0,0,0)
    love.graphics.setFont(love.graphics.newFont("Extra/font.ttf",30))
    love.graphics.print("Score :"..tostring(score),window_width/2-150,window_height/2-150)
    love.graphics.print("Press ESC to QUIT",window_width/2-250,window_height/2-50)
    love.graphics.print("Press Enter to Play",window_width/2-250,window_height/2+50)
  else 
    love.graphics.setLineWidth(5)
    -- love.graphics.line(game_width,0,game_width,game_height)
    love.graphics.setLineWidth(1)
    love.graphics.draw(background,0,0)
    love.graphics.setColor(122/255,104/255,39/255)
    love.graphics.setLineWidth(20)
    -- love.graphics.line(game_width,0,game_width,game_height)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(right_menu,900,0)
    
    love.graphics.setColor(1,1,1)
    love.graphics.draw(player_image,player.x,player.y)
    love.graphics.setColor(1,1,1)
     -- Bullets render
     for keys,values in pairs(all_bullets) do
        love.graphics.rectangle("fill",values.x,values.y,values.width,values.height,50)
    end
    ----------------------------------------------------------------------------G U I
    
    love.graphics.setColor(0,1,0)
    love.graphics.rectangle("fill",1001,235,player.health*20,20)
    love.graphics.setFont(love.graphics.newFont("Extra/font.ttf",15))
    love.graphics.print(score,1001+85,101+136+275)
    love.graphics.setFont(love.graphics.newFont(1))
    love.graphics.setColor(1,1,1)

    for keys,values in pairs(all_enemy) do
      --love.graphics.rectangle("fill",values.x,values.y,values.width,values.height)
      love.graphics.draw(enemy_image,values.x,values.y)
  end
  end 

  love.graphics.setColor(1,1,1)

  
end