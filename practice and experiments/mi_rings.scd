s.options.numWireBufs_(1024)

s.boot

({
	var sig = GrainIn.ar(60, Dust.ar(MouseX.kr(5, 1000, 1)), 0.001, WhiteNoise.ar, WhiteNoise.ar);
	sig = CombC.ar(sig, delaytime: LFNoise1.kr(0.01!60).linexp(-1, 1, 50, 5000).reciprocal, decaytime: MouseY.kr(0.1, 5, 1));
	Splay.ar(sig);
}.play)

({
	var sym, sig, freq = LFNoise0.kr(4).linexp(-1, 1, 50, 50 * 2.pow(6));
	sig = Saw.ar(freq) * Env.perc.ar(gate: Changed.kr(freq)) * MouseY.kr;
	sym = Limiter.ar(CombC.ar(sig * 0.5, delaytime: Scale.major.degreeToFreq([0,2,4,6], 150, 2).reciprocal, decaytime: 3));
	sym = Resonz.ar(sym.sum, Array.exprand(10, 50, 5000), 0.5);
	sym = Splay.ar(sym);
	sig!2 + sym;
}.play)

({
	// sympathetic strings model
	var in, sig, freq;
	freq = LFNoise0.kr(4).linexp(-1, 1, 50, 50 * 2.pow(6));
	// input can be anything
	sig = Saw.ar(freq) * Env.perc.ar(gate: Changed.kr(freq));
	in = LocalIn.ar(4);
	// brightness and damping section
	in = HPF.ar(LPF.ar(in, 10000), 500, 0.999);
	// filter on sig controls 'position' of string
	in = in + HPF.ar(LPF.ar(sig, 5000), 500).dup(4);
	in = DelayN.ar(in, delaytime: Scale.major.degreeToFreq([0,2,4,6], 150, 2).reciprocal);
	LocalOut.ar(in);
	// modeling some kind of resonant body like a violin
	in = Resonz.ar(in.sum, Array.rand(8, 20, 500), 0.1);
	Limiter.ar(Splay.ar(in));
}.play)
