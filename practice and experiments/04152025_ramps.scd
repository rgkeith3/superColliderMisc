s.boot
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");


(x.free; x = {
	var ramp = Line.ar(dur: 8, doneAction: 2);
	GrainBuf.ar(2, Impulse.ar(ramp.linexp(0,1,64, 2)), ramp.linexp(0,1,1, 8)/16, b, ramp.linexp(0,1,1, 4), ramp.linlin(0,1,0.5,0.8), pan: WhiteNoise.ar);
}.play)