Engine_ominousefm2 : CroneEngine {

	var <synth;
    var responder;
    var freq;
    var freq2;
	var freq3;
	*new {arg context, doneCallback;
		^super.new(context, doneCallback); }

	alloc {
  
		SynthDef(\ominousefm, {
			
			arg out, out_x, audio_in, gate=0, pit=48, contour=0.4, detune=0.25, level1=0.5,  level2=0.5, ratio1=0.5, ratio2=0.5, fm1=0.1, fm2=0.1, fb=0, fbx=0, filter_mode=0, cutoff=0.5, reson=0, strength=0.0, 
						env=0.5, rotate=0.2, space=0.5, mul=0.5, add=0, revtime=0.5, drywet=0.1, damping=0.3, hp=0.0, freeze=0, diffusion=0.625, fm1_mod_sel=0, fm1_mod_freq=0.5, fm1_mod_amt=0.0, 
			detune_mod_sel=0, detune_mod_freq=0.5, detune_mod_amt=0.0, ratio1_mod_sel=0, ratio1_mod_freq=0.5, ratio1_mod_amt=0.0;
			
			var sound, fm1_mod, detune_mod, ratio1_mod, xxx, yyy, zzz;
			fm1_mod = Select.ar(fm1_mod_sel, [SinOsc.ar(fm1_mod_freq, 0, 0.5, 0.5), Saw.ar(fm1_mod_freq, 0.5, 0.5), LFDNoise1.ar(fm1_mod_freq, 0.5, 0.5)]);
			detune_mod = Select.ar(detune_mod_sel, [SinOsc.ar(detune_mod_freq, 0, 0.5, 0.5), Saw.ar(detune_mod_freq, 0.5, 0.5), LFDNoise1.ar(detune_mod_freq, 0.5, 0.5)]);
			ratio1_mod = Select.ar(ratio1_mod_sel, [LFDNoise0.ar(ratio1_mod_freq, 0.5, 0.5), LFTri.ar(ratio1_mod_freq, 0.0, 0.5, 0.5).abs, LFDNoise1.ar(ratio1_mod_freq, 0.5, 0.5)]);
			
			xxx = Clip.kr(ratio1 + (ratio1_mod * ratio1_mod_amt), 0.0, 1.0);
			yyy = Clip.kr(detune + (detune_mod * detune_mod_amt), 0.0, 1.0);
			zzz = Clip.kr(fm1 + (fm1_mod * fm1_mod_amt), 0.0, 1.0);
			
			sound = MiOmi.ar(SoundIn.ar(0), gate, pit, contour, yyy, level1, level2, xxx, ratio2, zzz, fm2, fb, fbx, filter_mode, cutoff, reson, strength, env, rotate, space, mul, add);
			sound = MiVerb.ar(sound, revtime, drywet, damping, hp, freeze, diffusion);
			SendReply.kr(Impulse.kr(15),"/tr", [xxx, yyy, zzz]);
			Out.ar(out, Pan2.ar(sound));
		}).add;
		
		context.server.sync;
      
		synth = Synth.new(\ominousefm, [
			\out, context.out_b.index,
			\audio_in, context.in_b[0].index,
			\gate, 0,
			\pit, 48,
			\contour, 0.4,
			\detune, 0.25,
			\level1, 0.5,
			\level2, 0.5,
			\ratio1, 0.5,
			\ratio2, 0.5,
			\fm1, 0.1,
			\fm2, 0.1,
			\fb, 0.0,
			\fbx, 0.0,
			\filter_mode, 0.0,
			\cutoff, 0.5,
			\reson, 0.0,
			\strength, 0.0,
			\env, 0.5,
			\rotate, 0.25,
			\space, 0.25,
			\mul, 0.5,
			\add, 0.0,
			\revtime, 0.5,
			\drywet, 0.1,
			\damping, 0.3,
			\hp, 0.0,
			\freeze, 0.0,
			\diffusion, 0.625
		],
		context.xg);

		responder = OSCFunc({arg msg; freq = msg[3]; freq2 = msg[4]; freq3 = msg[5]; }, '/tr', context.server.addr);
   
  
		this.addPoll("sendlfo", {var val = freq; val});
  
		this.addPoll("sendlfo2", {var val = freq2; val});
  
		this.addPoll("sendlfo3", {var val = freq3; val});

		
		this.addCommand("noteOn", "i", {|msg| synth.set(\pit, msg[1]); synth.set(\gate, 1);  }); 
 
		this.addCommand("noteOff", "i", {|msg| synth.set(\gate, 0);}); 
    
		this.addCommand("gate", "f", {|msg| synth.set(\gate, msg[1]);});

		this.addCommand("pit", "i", {|msg| synth.set(\pit, msg[1]);});
    
		this.addCommand("contour", "f", {|msg| synth.set(\contour, msg[1]);});
    
		this.addCommand("detune", "f", {|msg| synth.set(\detune, msg[1]);});
    
		this.addCommand("detune_mod_sel", "f", {|msg| synth.set(\detune_mod_sel, msg[1]-1);});
   
		this.addCommand("detune_mod_freq", "f", {|msg| synth.set(\detune_mod_freq, msg[1]);});
    
		this.addCommand("detune_mod_amt", "f", {|msg|synth.set(\detune_mod_amt, msg[1]);});
  
		this.addCommand("level1", "f", {|msg| synth.set(\level1, msg[1]); });
    
		this.addCommand("level2", "f", {|msg| synth.set(\level2, msg[1]); });
    
		this.addCommand("ratio1", "f", {|msg| synth.set(\ratio1, msg[1]); });
    
		this.addCommand("ratio1_mod_sel", "f", {|msg| synth.set(\ratio1_mod_sel, msg[1]-1);});
   
		this.addCommand("ratio1_mod_freq", "f", {|msg| synth.set(\ratio1_mod_freq, msg[1]);});
   
		this.addCommand("ratio1_mod_amt", "f", {|msg| synth.set(\ratio1_mod_amt, msg[1]);});
  
		this.addCommand("ratio2", "f", {|msg| synth.set(\ratio2, msg[1]);});
      
		this.addCommand("fm1", "f", {|msg| synth.set(\fm1, msg[1]);});
    
		this.addCommand("fm1_mod_sel", "f", {|msg| synth.set(\fm1_mod_sel, msg[1]-1);});
   
		this.addCommand("fm1_mod_freq", "f", {|msg| synth.set(\fm1_mod_freq, msg[1]);});
    
		this.addCommand("fm1_mod_amt", "f", {|msg| synth.set(\fm1_mod_amt, msg[1]);});
      
		this.addCommand("fm2", "f", {|msg| synth.set(\fm2, msg[1]);});
    
		this.addCommand("fb", "f", {|msg| synth.set(\fb, msg[1]);});
    
		this.addCommand("fbx", "f", {|msg| synth.set(\fbx, msg[1]); });
    
		this.addCommand("filter_mode", "f", {|msg|synth.set(\filter_mode, msg[1]);});
    
		this.addCommand("cutoff", "f", {|msg| synth.set(\cutoff, msg[1]);});
		
		this.addCommand("reson", "f", {|msg| synth.set(\reson, msg[1]);});
   
		this.addCommand("strenght", "f", {|msg| synth.set(\strength, msg[1]);});
    
		this.addCommand("env", "f", {|msg| synth.set(\env, msg[1]);});
    
		this.addCommand("rotate", "f", {|msg| synth.set(\rotate, msg[1]);});
    
		this.addCommand("space", "f", {|msg| synth.set(\space, msg[1]);});
    
		this.addCommand("mul", "f", {|msg| synth.set(\mul, msg[1]);});
    
		this.addCommand("add", "f", {|msg| synth.set(\add, msg[1]);});
    
		this.addCommand("revtime", "f", {|msg| synth.set(\revtime, msg[1]);});
   
		this.addCommand("drywet", "f", {|msg| synth.set(\drywet, msg[1]); });
    
		this.addCommand("damping", "f", {|msg| synth.set(\damping, msg[1]);});
    
		this.addCommand("hp", "f", {|msg| synth.set(\hp, msg[1]);});
    
		this.addCommand("freeze", "f", {|msg| synth.set(\freeze, msg[1]);});
    
		this.addCommand("diffusion", "f", {|msg| synth.set(\diffusion, msg[1]);});
    
		this.addCommand("ffreq", "f", {|msg| synth.set(\ffreq, msg[1]);});
    
		this.addCommand("fq", "f", {|msg| synth.set(\fq, msg[1]);});

		this.addCommand("mode", "f", {|msg| synth.set(\mode, msg[1]);});
    
		this.addCommand("inputgain", "f", {|msg| synth.set(\inputgain, msg[1]);});
    
		this.addCommand("noiselev", "f", {|msg| synth.set(\noiselev, msg[1]);});
    
  }

  free {
    synth.free;
  }
}

