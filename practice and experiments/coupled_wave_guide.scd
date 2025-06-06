s.boot

(x.free; x = {
	var in, sig, trig, freq, n=8;
	// trig = Dust.ar(XLine.ar(1, 500, 10));
	// sig = Env.perc(0.01, 0.1).ar() * PinkNoise.ar(50);
	// sig = Dust.ar(500!2);
	// sig = GrainIn.ar(2, Dust.ar(MouseY.kr(1, 1000, 1)), 0.00001, PinkNoise.ar, WhiteNoise.ar);
	sig = GrainIn.ar(n, Dust.ar(SinOscFB.kr(Rand(0.0, 10), Rand()).linexp(-1, 1, 1, 1000)), 0.01, PinkNoise.ar, pan: WhiteNoise.ar);
	// freq = LFDNoise3.ar(LFNoise1.kr(1).linexp(-1, 1, 0.1, 10)).linexp(-1, 1, 150 / 8, 150 * 8);
	freq = 150;
	in = LocalIn.ar(n);
	in = HPF.ar(in, 20);
	in = LPF.ar(in, 20000);
	// in = Splay.ar(in, LFNoise1.kr(1).range(0, 0.2));
	in = SplayAz.ar(n, in, 0.01, width: n);
	sig = in + sig;
	sig = DelayN.ar(sig, delaytime: (freq * Array.fill(n, {|i| LFNoise1.kr(1).range(0.95, 1.05)})).reciprocal);
	LocalOut.ar(Limiter.ar(sig));
	sig = (sig * 5).distort;
	sig = Resonz.ar(sig, Array.exprand(15, 20, 20000), 0.05).sum;
	Limiter.ar(sig!2) * Env.adsr.ar(2, \gate.kr(1));
}.play)

x.set(\gate, 0)

150/8

Scale.minorPentatonic.degreeToFreq((0..8), 150, 0)


[1,2,3,4][0..1]
s.scope