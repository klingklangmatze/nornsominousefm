engine.name = "ominousefm2"
local UI = require "ui"

local enc_row = 1
local pit = 48
local cs = require 'controlspec'
local wave_shapes = {"sine", "saw", "chaos"}
local ratio1 = 0.2
local fm1 = 0.1
local detune = 0.25
local ratio2 = 0.2
local fm2 = 0.1
local fbx = 0.0




function init()

  --MIDI
  local mo = midi.connect(1) 
    mo.event = function(data) 
      d = midi.to_msg(data)
      if d.type == "note_on" then
        engine.gate(1)
        engine.pit(d.note)
      
       elseif d.type == "note_off" then
      
        engine.gate(0)
      end 
    redraw()
end

  
 params:add_separator ("2x2 Operator FM Synth")

params:add_control("pit", "Pitch", controlspec.new(0, 120, 'lin', 1, 48))
params:set_action("pit", function(x) engine.pit(x) end)

params:add_control("contour", "EG (AD <> ADSR <> AR)", controlspec.new(0.00, 1.00, 'lin', 0.01, 0.4))
params:set_action("contour", function(x) engine.contour(x) end)
  
params:add_control("detune", "Detune Osc 2", controlspec.new(0.00, 1.00, 'lin', 0.01, 0.25))
params:set_action("detune", function(x) engine.detune(x)  end)  
    
params:add_control("level1", "Level Osc 1", controlspec.new(0.00, 1.00, 'lin', 0.01, 0.5))
params:set_action("level1", function(x) engine.level1(x) end)     
  
params:add_control("level2", "Level Osc 2", controlspec.new(0.00, 1.00, 'lin', 0.01, 0.5))
params:set_action("level2", function(x) engine.level2(x) end)  

params:add_control("ratio1", "C:M Freq 1", controlspec.new(0.00, 1.00, 'lin', 0, 0.5))
params:set_action("ratio1", function(x) engine.ratio1(x) end)

params:add_control("ratio2", "C:M Freq 2", controlspec.new(0.00, 1.00, 'lin', 0.01, 0.5))
params:set_action("ratio2", function(x) engine.ratio2(x) end) 

params:add_control("fm1", "FM Osc 1", controlspec.new(0.00, 1.00, 'lin', 0.01, 0.1))
params:set_action("fm1", function(x) engine.fm1(x) end)

params:add_control("fm2", "FM Osc 2", controlspec.new(0.00, 1.00, 'lin', 0.01, 0.1))
params:set_action("fm2", function(x) engine.fm2(x) end) 

params:add_control("fb", "Feedback modulation", controlspec.new(0.00, 1.00, 'lin', 0.01, 0.0))
params:set_action("fb", function(x) engine.fb(x) end)

params:add_control("fbx", "Cross feedback", controlspec.new(0.00, 1.00, 'lin', 0.01, 0.0))
params:set_action("fbx", function(x) engine.fbx(x) end) 

params:add_control("filter_mode", "Filter (LP <> BP <> HP)", controlspec.new(0.00, 1.00, 'lin', 0.01, 0))
params:set_action("filter_mode", function(x) engine.filter_mode(x) end) 

params:add_control("cutoff", "Filter cutoff", controlspec.new(0.00, 1.00, 'lin', 0.01, 0.5))
params:set_action("cutoff", function(x) engine.cutoff(x) end) 

params:add_control("reson", "Filter resonance", controlspec.new(0.00, 1.00, 'lin', 0.01, 0.0))
params:set_action("reson", function(x) engine.reson(x) end) 

--params:add_control("strenght", "Strength", controlspec.new(0.00, 1.00, 'lin', 0.01, 0.0))
--params:set_action("strenght", function(x) engine.strenght(x) end) 

params:add_control("env", "Filter envelope", controlspec.new(0.00, 1.00, 'lin', 0.01, 0.5))
params:set_action("env", function(x) engine.env(x)  end)

params:add_control("rotate", "Speed of stereo rotation", controlspec.new(0.00, 1.00, 'lin', 0.01, 0.25))
params:set_action("rotate", function(x) engine.rotate(x) end)

params:add_control("space", "Width of stereo image", controlspec.new(0.00, 1.00, 'lin', 0.01, 0.25))
params:set_action("space", function(x) engine.space(x) end)

params:add_control("mul", "Volume", controlspec.new(0.00, 1.00, 'lin', 0.01, 0.5))
params:set_action("mul", function(x) engine.mul(x) end)

params:add_separator("modulation")

params:add_group("*fm1", 3)
  params:add_option("fm1_mod_sel", "waveshape", wave_shapes, 1)
  params:set_action("fm1_mod_sel", function(x) engine.fm1_mod_sel(x) end)
  params:add{type = "control", id = "fm1_mod_freq", name = "fm1 mod speed",
    controlspec = cs.new(0.01, 1000.00, "exp", 0.01, 0.5, ""), action = engine.fm1_mod_freq}
  params:add{type = "control", id = "fm1_mod_amt", name = "fm1 mod amount",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.00, ""), action = engine.fm1_mod_amt}

  params:add_group("*fm2", 3)
  params:add_option("fm2_mod_sel", "waveshape", wave_shapes, 1)
  params:set_action("fm2_mod_sel", function(x) engine.fm2_mod_sel(x) end)
  params:add{type = "control", id = "fm2_mod_freq", name = "fm2 mod speed",
    controlspec = cs.new(0.01, 1000.00, "exp", 0.01, 0.5, ""), action = engine.fm2_mod_freq}
  params:add{type = "control", id = "fm2_mod_amt", name = "fm2 mod amount",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.00, ""), action = engine.fm2_mod_amt}

  params:add_group("*C:M FM1", 3)
  params:add_option("ratio1_mod_sel", "waveshape", wave_shapes, 1)
  params:set_action("ratio1_mod_sel", function(x) engine.ratio1_mod_sel(x) end)
  params:add{type = "control", id = "ratio1_mod_freq", name = "ratio1 fm1 mod speed",
    controlspec = cs.new(0.01, 20.00, "lin", 0.01, 0.5, ""), action = engine.ratio1_mod_freq}
  params:add{type = "control", id = "ratio1_mod_amt", name = "ratio1 fm1 mod amount",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.00, ""), action = engine.ratio1_mod_amt}
  
  params:add_group("*C:M FM2", 3)
  params:add_option("ratio2_mod_sel", "waveshape", wave_shapes, 1)
  params:set_action("ratio2_mod_sel", function(x) engine.ratio2_mod_sel(x) end)
  params:add{type = "control", id = "ratio2_mod_freq", name = "ratio2 fm2 mod speed",
    controlspec = cs.new(0.01, 20.00, "lin", 0.01, 0.5, ""), action = engine.ratio2_mod_freq}
  params:add{type = "control", id = "ratio2_mod_amt", name = "ratio2 fm2 mod amount",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.00, ""), action = engine.ratio2_mod_amt}

  params:add_group("*fbx", 3)
  params:add_option("fbx_mod_sel", "waveshape", wave_shapes, 1)
  params:set_action("fbx_mod_sel", function(x) engine.fbx_mod_sel(x) end)
  params:add{type = "control", id = "fbx_mod_freq", name = "fbx fm2 mod speed",
    controlspec = cs.new(0.01, 1000.00, "exp", 0.01, 0.5, ""), action = engine.fbx_mod_freq}
  params:add{type = "control", id = "fbx_mod_amt", name = "fbx fm2 mod amount",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.00, ""), action = engine.fbx_mod_amt}
  
params:add_group("*detune fm2", 3)
  params:add_option("detune_mod_sel", "waveshape", wave_shapes, 1)
  params:set_action("detune_mod_sel", function(x) engine.detune_mod_sel(x) end)
  params:add{type = "control", id = "detune_mod_freq", name = "detune fm2 mod speed",
    controlspec = cs.new(0.01, 1000.00, "exp", 0.01, 0.5, ""), action = engine.detune_mod_freq}
  params:add{type = "control", id = "detune_mod_amt", name = "detune fm2 mod amount",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.00, ""), action = engine.detune_mod_amt}


  
  
  


params:add_separator ("Reverb")

params:add_control("drywet", "Dry <> Wet", controlspec.new(0.0, 1.0, 'lin', 0.01, 0.1))
params:set_action("drywet", function(x) engine.drywet(x) end)

params:add_control("revtime", "Time", controlspec.new(0.0, 1.25, 'lin', 0.01, 0.25))
params:set_action("revtime", function(x) engine.revtime(x) end)

params:add_control("damping", "Damping", controlspec.new(0.0, 1.0, 'lin', 0.01, 0.3))
params:set_action("damping", function(x) engine.damping(x) end)

params:add_control("hp", "HP filter", controlspec.new(0.0, 1.0, 'lin', 0.01, 0.0))
params:set_action("hp", function(x) engine.hp(x) end)

params:add_control("diffusion", "Diffusion", controlspec.new(0.0, 1.0, 'lin', 0.01, 0.625))
params:set_action("diffusion", function(x) engine.diffusion(x) end)

params:add_control("freeze", "Freeze", controlspec.new(0.0, 1.0, 'lin', 1, 0.0))
params:set_action("freeze", function(x) engine.freeze(x) end)


local ratio1_poll = poll.set("sendlfo", function(val)   ratio1 = val end)
ratio1_poll:start()
ratio1_poll.time = 0.025

local detune_poll = poll.set("sendlfo2", function(val)   detune = val end)
detune_poll:start()
detune_poll.time = 0.025

local fm1_poll = poll.set("sendlfo3", function(val)   fm1 = val end)
fm1_poll:start()
fm1_poll.time = 0.025
  
local ratio2_poll = poll.set("sendlfo4", function(val)   ratio1 = val end)
ratio2_poll:start()
ratio2_poll.time = 0.025

local fxb_poll = poll.set("sendlfo5", function(val)   detune = val end)
fxb_poll:start()
fxb_poll.time = 0.025

local fm2_poll = poll.set("sendlfo6", function(val)   fm1 = val end)
fm2_poll:start()
fm2_poll.time = 0.025




local column = 26
local row = 20


contour_enc    = UI.Dial.new(column*3-10 , row*2, 9, 0.4, 0.0 , 1, 0.01, 0,  {}, "", "EG:A")
env_enc    = UI.Dial.new(column*5-20 , 1, 9, 0.4, 0.0 , 1, 0.01, 0,  {}, "", "EG:F")
revdrywet_enc    = UI.Dial.new(column*3-10 , row, 9, 0.4, 0.0 , 1, 0.01, 0,  {}, "", "REV")


level1_enc    = UI.Dial.new(5, 1, 9, 0.4, 0.0 , 1, 0.01, 0,  {}, "", "LVL1")
fm1_enc    = UI.Dial.new(5, row, 9, 0.4, 0.0 , 1, 0.01, 0,  {}, "", "FM1")
ratio1_enc    = UI.Dial.new(5, row*2, 9, 0.4, 0.0 , 1, 0.01, 0,  {}, "", "C:M1")

level2_enc    = UI.Dial.new(column, 1, 9, 0.4, 0.0 , 1, 0.01, 0,  {}, "", "LVL2")
fm2_enc    = UI.Dial.new(column, row, 9, 0.4, 0.0 , 1, 0.01, 0,  {}, "", "FM2")
ratio2_enc    = UI.Dial.new(column, row*2, 9, 0.4, 0.0 , 1, 0.01, 0,  {}, "", "C:M2")


fb_enc    = UI.Dial.new(column*2-5, 1, 9, 0.4, 0.0 , 1, 0.01, 0,  {}, "", "FB")
fbx_enc    = UI.Dial.new(column*2-5, row, 9, 0.4, 0.0 , 1, 0.01, 0,  {}, "", "FBX")
detune_enc    = UI.Dial.new(column*2-5, row*2, 9, 0.4, 0.0 , 1, 0.01, 0,  {}, "", "2DTN")


filter_mode_enc    = UI.Dial.new(column*4-15, 1, 9, 0.0, 0.0 , 1, 0.01, 0,  {}, "", "FLT")
cutoff_enc    = UI.Dial.new(column*4-15, row, 9, 0.5, 0.0 , 1, 0.01, 0,  {}, "", "CUT")
reson_enc    = UI.Dial.new(column*4-15, row*2, 9, 0.0, 0.0 , 1, 0.01, 0,  {}, "", "RES")

filter_mode_enc    = UI.Dial.new(column*4-15, 1, 9, 0.0, 0.0 , 1, 0.01, 0,  {}, "", "FLT")
cutoff_enc    = UI.Dial.new(column*4-15, row, 9, 0.5, 0.0 , 1, 0.01, 0,  {}, "", "CUT")
reson_enc    = UI.Dial.new(column*4-15, row*2, 9, 0.0, 0.0 , 1, 0.01, 0,  {}, "", "RES")

rotate_enc    = UI.Dial.new(column*5-20, row, 9, 0.5, 0.0 , 1, 0.01, 0,  {}, "", "ROT")
space_enc    = UI.Dial.new(column*5-20, row*2, 9, 0.0, 0.0 , 1, 0.01, 0,  {}, "", "SPA")

local norns_redraw_timer = metro.init()
  norns_redraw_timer.time = 0.025
  norns_redraw_timer.event = function() redraw() end
  norns_redraw_timer:start()

end





function key(n, z)

  if n==1 and z==1 then
    engine.gate(1)
    
--  elseif n==1 and z==0 then
--    engine.gate(0)
 end
    
    
  
  if n==3 and z==1 then
    enc_row = (enc_row % 6) + 1
    print(enc_row)
    
  end
  
  if n==2 and z==1 then
    enc_row = (enc_row % 6 ) - 1
    if enc_row == 0 then
      enc_row = 6
    end
    if enc_row == -1 then
      enc_row = 5
    end
     
    print(enc_row)
    
  end

redraw()
end

--Encoder
function enc(n,d)
  


if enc_row == 1 then
  
  if n==3 then
    params:delta("ratio1", d)
  elseif n==2 then
    params:delta("fm1", d)
  elseif n==1 then
    params:delta("level1", d)
  end  
  
end
    
if enc_row == 2 then
  
  if n==2 then
    params:delta("fm2", d)
  elseif n==3 then
    params:delta("ratio2", d)
  elseif n==1 then
    params:delta("level2", d)
  end
  
  
end
  
if enc_row == 3 then
  
if n==1 then
    params:delta("fb", d)
  elseif n==2 then
    params:delta("fbx", d)
  elseif n==3 then
    params:delta("detune", d)
  end
end

if enc_row == 4 then
  
if n==3 then
    params:delta("contour", d)
  
  end
end



if enc_row == 5 then
  
if n==1 then
    params:delta("filter_mode", d)
  elseif n==2 then
    params:delta("cutoff", d)
  elseif n==3 then
    params:delta("reson", d)
  end
end

if enc_row == 6 then
  
if n==1 then
    params:delta("env", d)
  elseif n==2 then
    params:delta("rotate", d)
  elseif n==3 then
    params:delta("space", d)
  end
end



redraw()
end

function redraw()

  screen.aa(1)
  screen.clear()

  screen.level(1)
  screen.move(61,16)
  screen.font_face(64)
  screen.text("2X2")
  screen.move(64,26)
  screen.text("OP")
  screen.move(64,36)
  screen.text("FM")
  
  
  
  screen.font_face(0)
  screen.level(15)
  screen.rect((9 + (enc_row)*21-21), 62, 1, 1)
  
  screen.stroke()
  contour_enc:set_value(params:get("contour"))
  contour_enc:redraw()
  
  detune_enc:set_value(detune)
  detune_enc:redraw()
  
  level1_enc:set_value(params:get("level1"))
  level1_enc:redraw()
  
   fm1_enc:set_value(fm1)
  fm1_enc:redraw()
  
  ratio1_enc:set_value(ratio1)
  ratio1_enc:redraw()
  
  level2_enc:set_value(params:get("level2"))
  level2_enc:redraw()
  
   fm2_enc:set_value(fm2)
  fm2_enc:redraw()
  
  ratio2_enc:set_value(ratio2)
  ratio2_enc:redraw()
  
   fb_enc:set_value(params:get("fb"))
  fb_enc:redraw()
  
  fbx_enc:set_value(fbx)
  fbx_enc:redraw()
  
  filter_mode_enc:set_value(params:get("filter_mode"))
  filter_mode_enc:redraw()
  
   cutoff_enc:set_value(params:get("cutoff"))
  cutoff_enc:redraw()
  
  reson_enc:set_value(params:get("reson"))
  reson_enc:redraw()
  
  
  env_enc:set_value(params:get("env"))
  env_enc:redraw()
  
  
  rotate_enc:set_value(params:get("rotate"))
  rotate_enc:redraw()
 
  space_enc:set_value(params:get("space"))
  space_enc:redraw()
 

  screen.update()
end

