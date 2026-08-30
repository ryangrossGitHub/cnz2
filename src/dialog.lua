end_dialog_delay = 120
end_dialog_cnt = 0
end_dt_cnt = 1
end_dt = {
  {"chad", "HEY! PUT'EM UP"},
  {"e", "I'M SORRY, MY WIFE AND DAUGHTER WERE TAKEN"},	
  {"e", "I HAD NO WAY TO PAY THEIR RANSOM"},
  {"e", "I.. I HAVE TO DO THIS TO BUY THEIR FREEDOM"},
  {"chad", "I HAVE A WIFE AND DAUGHTER TOO"},
  {"chad", "I WOULD DO ANYTHING FOR THEM"},
  {"jenn", "AND I HAVE A SON"},
  {"jenn", "HE SLEEPS UNDER HIS BED BECAUSE OF THE ZOMBIES"},
  {"e", "AGAIN I'M SORRY.. AND I'M NOT THE ONLY ONE.."},
  {"e", "THERE ARE OTHERS ACROSS THE COUNTRY"},
  {"chad", "WHAT IF THERE WAS ANOTHER WAY"},
  {"chad", "WHAT IF WE COULD BRING YOUR WIFE AND DAUGHTER HERE"},
  {"chad", "HERE THEY WOULD BE SAFE, WE COULD PROTECT THEM"},
  {"jenn", "YOU WON'T BE FORGIVEN AND YOU WILL DO TIME"},
  {"jenn", "BUT YOUR FAMILY WILL BE SAFE AND THEY CAN VISIT YOU"},
  {"chad", "IN RETURN YOU HELP US STOP THE OTHERS"},
  {"e", "DEAL, BUT I WANT TO SEE MY WIFE AND DAUGHTER"},
  {"jenn", "OKAY, COME WITH US, LET'S TAKE THESE GUYS DOWN"},
  {"f", "TO BE CONTINUED"},
  {"f", "TO BE CONTINUED"},
  {"f", "TO BE CONTINUED"},
  {"f", "TO BE CONTINUED"},
  {"f", "TO BE CONTINUED"},
}

function say(x,y,msg,border,wide,bounded)    
  local max_w = 42 
  if wide then
   max_w = 86
  end

	 -- 1. split text into words using pico-8's native split  
  local words = split(msg, " ")
  local lines = {}
  local curr = ""
  
  for w in all(words) do
    -- puny font characters are ~4 pixels wide
    if #curr * 4 + #w * 4 + 6 
     > max_w then
      add(lines, curr)
      curr = w
    else
      curr = (curr == "") and w or curr.." "..w
    end
  end
  add(lines, curr)

  -- 2. calculate dimensions (puny is 5px tall)
  local line_h = 6 
  local b_w = max_w
  local b_h = #lines * line_h + 3
  local bx = x - b_w/2 + 8
  local by = y - b_h - 2

	 -- 3. keep dialog in screen
  if bounded then
	  if bx - b_w/2 < camera_x then
	   bx = camera_x
	  elseif bx + b_w > camera_x + screen_size then
	   bx = camera_x + screen_size - b_w
	  end
	 end

  -- 4. draw bubble body and tail
  rectfill(bx, by, bx + b_w, by + b_h, 7)
  
  if border==1 then
   rect(bx, by, bx+b_w, by+b_h, 0)
  
	  -- simple triangle tail
	  line(x+6, by+b_h, x+7, by+b_h+2, 0)
	  line(x+8, by+b_h, x+7, by+b_h+2, 0)
	  pset(x+7, by+b_h, 7)
  end

  -- 5. print each line with \v (puny font)
  for i=1,#lines do
    print(lines[i], bx+2, by+2 + (i-1)*line_h, 0)
  end
end

function ending_dialog()
  if end_dt_cnt < 16 then
    draw_boss(true)
  else
    draw_boss(false)
  end
	
	end_dialog_cnt += 1
	
	if end_dt_cnt >= #end_dt then
	  load_stage(0)
	end
	
	if end_dialog_cnt <  end_dialog_delay then
    if end_dt[end_dt_cnt][1] == "jenn" then
	 	  say(j.x, j.y, end_dt[end_dt_cnt][2], 1, false, true)
	  elseif end_dt[end_dt_cnt][1] == "chad" then
	    say(c.x, c.y, end_dt[end_dt_cnt][2], 1, false, true)
	  elseif end_dt[end_dt_cnt][1] == "e" then
	    say(boss.x, boss.y, end_dt[end_dt_cnt][2], 1, false, true)
	  elseif end_dt[end_dt_cnt][1] == "f" then
	    say(950, 150, end_dt[end_dt_cnt][2], 0, false, true)
	  end
	else
	  end_dialog_cnt = 0
	  end_dt_cnt += 1
	end
end

function draw_trans_dialog()
  if stage == 2 then --DONUT
    say(c.x, c.y, "DARN, OUT OF DONUTS. MUST BE THE MORNING RUSH", 1, false, true)
  elseif stage == 3 then --COFFEE
    say(j.x, j.y, "THE VIRUS SPREADS THROUGH WATER, GOOD THING I ONLY DRINK COFFEE", 1, false, true)
  elseif stage == 4 then --PARKING
    say(c.x, c.y, "I DON'T GET PAID ENOUGH FOR THIS", 1, false, true)
  elseif stage == 5 then --ICE CREAM TRUCK
    say(j.x, j.y, "IF THEY HAD MINT CHOCOLATE CHIP I WOULD HAVE BOUGHT ONE", 1, false, true)
  elseif stage == 6 then --PARK
    say(c.x, c.y, "IF WE CAN FIND THE SOURCE OF THE VIRUS HERE WE CAN STOP THIS", 1, false, true)
  elseif stage == 7 then --SIGN
    say(j.x, j.y, "IT'S ONLY BEEN A WEEK, BUT I COULD GET USED TO ZOMBIE HUNTING.", 1, false, true)
  elseif stage == 8 then --FENCE
    say(c.x, c.y, "WE MADE IT, LET'S GET INSIDE AND TURN OFF THE WATER", 1, false, true)
  elseif stage == 10 then --PLANT ENTRANCE
    say(j.x, j.y, "WORST PART ABOUT THE APOCALYPSE NO WINE, NO PIZZA, NO DONUTS", 1, false, true)
  elseif stage == 11 then --PIPE1
    say(c.x, c.y, "AFTER THIS, FIRST ROUND IS ON ME, IF WE CAN FIND AN OPEN BAR..", 1, false, true)
  elseif stage == 12 then --PIPE2
    say(j.x, j.y, "I'M DEFINITELY GETTING MY STEPS IN", 1, false, true)
  elseif stage == 13 then --VAT1
    say(c.x, c.y, "I NEED TO MOVE MY FAMILY OUT TO THE COUNTRY SIDE", 1, false, true)
  elseif stage == 14 then --VAT2
    say(j.x, j.y, "IF YOU ALL LEAVE THE CITY, JAKE AND I ARE COMING WITH YOU", 1, false, true)
  elseif stage == 15 then --VAT2
    say(c.x, c.y, "WHATEVER HAPPENS HERE, I COULDN'T ASK FOR A BETTER PARTNER", 1, false, true)
  end
end