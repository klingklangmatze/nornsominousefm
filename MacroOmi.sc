Engine_MacroE_v1b : CroneEngine {
  
var <synth;
  *new { arg context, doneCallback;
    ^super.new(context, doneCallback);
  }

  alloc {
  
    SynthDef(\MacroOmi, {
			arg out, audio_in=0, gate=0, pit=48, contour=0.2, detune=0.25, level1=0.5,  level2=0.5, ratio1=0.5, ratio2=0.5, fm1=0, fm2=0, fb=0, xfb=0, filter_mode=0, cutoff=0.5, reson=0, strength=0.5, env=0.5, rotate=0.2, space=0.5, mul=0.5, add=0, revtime=0.5, drywet=0.1, damping=0.3, hp=0.0, freeze=0, diffusion=0.625, ffreq=22000, fq=0, mode=0, inputgain=1.0, noiselev=0.0003;
			var sound;
			sound = DFM1.ar(MiOmi.ar(audio_in, gate, pit, contour, detune,
			level1, level2, ratio1, ratio2, fm1, fm2, fb, xfb, filter_mode,
			cutoff, reson, strength, env, rotate, space, mul, add), ffreq, fq, inputgain, mode, noiselev);
			sound = MiVerb.ar(sound, revtime, drywet, damping, hp, freeze, diffusion) * mul;
			Out.ar(out, Pan2.ar(sound);
		}).add;

    context.server.sync;

    synth = Synth.new(\MacroOmi, [
			\out, context.out_b.index,
			\audio_in, context.in_b.index,
			\gate, 0,
			\pit, 48,
			\contour, 0.2,
			\detune, 0.25,
			\level1, 0.5,
			\level2, 0.5,
			\ratio1, 0.5,
			\ratio2, 0.5,
			\fm1, 0,
			\fm2, 0,
			\fb, 0,
			\fbx, 0,
			\filter_mode, 0,
			\cutoff, 0.5,
			\reson, 0,
			\strength, 0.5,
			\env, 0.5,
			\rotate, 0.2,
			\space, 0.5
			\mul, 0.5,
			\add, 0,
			\revtime, 0.5,
			\drywet, 0.1,
			\damping, 0.3,
			\hp, 0.0,
			\freeze, 0,
			\diffusion, 0.625,
			\ffreq, 22000,
			\fq, 0,
			\mode, 0,
			\inputgain, 1.0,
			\noiselev, 0.0003
      ],
    context.xg);

//noteOn(note, vel)
    this.addCommand("noteOn", "i", {|msg|
      synth.set(\pit, msg[1]);
      synth.set(\gate, 1);
      //synth.set(\level, msg[2]);
    }); 
 
     this.addCommand("noteOff", "i", {|msg|
      synth.set(\gate, 0);
      //synth.set(\level, 0);
    }); 
    
	this.addCommand("gate", "f", {|msg|
      synth.set(\gate, msg[1]);
    });

    this.addCommand("pit", "i", {|msg|
      synth.set(\pit, msg[1]);
    });
    this.addCommand("contour", "f", {|msg|
      synth.set(\contour, msg[1]-1);
    });
    this.addCommand("detune", "f", {|msg|
      synth.set(\detune, msg[1]);
    });
    this.addCommand("level1", "f", {|msg|
      synth.set(\level1, msg[1]);
    });
    this.addCommand("level2", "f", {|msg|
      synth.set(\level1, msg[1]);
    });
    this.addCommand("ratio1", "f", {|msg|
      synth.set(\ratio1, msg[1]);
    });

    this.addCommand("ratio2", "f", {|msg|
      synth.set(\ratio2, msg[1]);
    });
    this.addCommand("fm1", "f", {|msg|
      synth.set(\fm2, msg[1]);
    });
    this.addCommand("fb", "f", {|msg|
      synth.set(\fb, msg[1]);
    });
    this.addCommand("fbx", "f", {|msg|
      synth.set(\fbx, msg[1]);
    });
     this.addCommand("filter_mode", "i", {|msg|
      synth.set(\filter_mode, msg[1]);
    });
    this.addCommand("cutoff", "f", {|msg|
      synth.set(\cutoff, msg[1]);
    });
    this.addCommand("reson", "f", {|msg|
      synth.set(\reson, msg[1]);
    });
   
    this.addCommand("strenght", "f", {|msg|
      synth.set(\strength, msg[1]);
    });
    
	 this.addCommand("env", "f", {|msg|
      synth.set(\env, msg[1]);
    });
    
	 this.addCommand("rotate", "f", {|msg|
      synth.set(\rotate, msg[1]);
    });
    	
	 this.addCommand("space", "f", {|msg|
      synth.set(\space, msg[1]);
    });
    	
	 this.addCommand("mul", "f", {|msg|
      synth.set(\mul, msg[1]);
    });
    	
	 this.addCommand("add", "f", {|msg|
      synth.set(\add, msg[1]);
    });
    	
		
    this.addCommand("revtime", "f", {|msg|
      synth.set(\revtime, msg[1]);
    });
   
   this.addCommand("drywet", "f", {|msg|
      synth.set(\drywet, msg[1]);
    });
    
    this.addCommand("damping", "f", {|msg|
      synth.set(\damping, msg[1]);
    });
    
    this.addCommand("hp", "f", {|msg|
      synth.set(\hp, msg[1]);
    });
    
    this.addCommand("freeze", "f", {|msg|
      synth.set(\freeze, msg[1]);
    });
    
    this.addCommand("diffusion", "f", {|msg|
      synth.set(\diffusion, msg[1]);
    });
    
    this.addCommand("ffreq", "f", {|msg|
      synth.set(\ffreq, msg[1]);
    });
    
    this.addCommand("fq", "f", {|msg|
      synth.set(\fq, msg[1]);
    });

    this.addCommand("mode", "f", {|msg|
      synth.set(\mode, msg[1]);
    });
    
    this.addCommand("inputgain", "f", {|msg|
      synth.set(\inputgain, msg[1]);
    });
    
    this.addCommand("noiselev", "f", {|msg|
      synth.set(\noiselev, msg[1]);
    });
    
  }

  free {
    synth.free;
  }
}

