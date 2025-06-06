(x.free; x = {
	var reson, ring, sig = Saw.ar(\freq.kr(1, 2) * LFNoise2.kr(0.1!3).range(0.9, 1.1));
	20.do {
		sig = BAllPass.ar(sig, LFNoise2.kr(1).linexp(-1, 1, 50, 5000), 1);
	};
	sig = sig.sum;
	sig = sig + CombC.ar(InGrain.ar(sig > 0.99, 0.01, sig), delaytime: LFNoise2.kr(0.1!2).exprange(1, 500).reciprocal, decaytime: LFNoise2.kr(10!2).exprange(0.1, 10));
	sig = Notch.ar(sig, LFNoise2.kr(1!2).exprange(50, 5000), 1);

	sig = sig.distort;
	reson = Resonz.ar(sig, Array.exprand(20, 20, 20000), Array.exprand(20, 1, 2), 1/20).sum.distort;
	ring = Ringz.ar(sig > 0.4999, Array.exprand(20, 20, 20000), Array.exprand(20, 0.01, 0.1), 1/100).sum.distort;
	sig = sig + reson + ring;
	sig = RLPF.ar(sig, LFNoise2.kr(1!2).exprange(50, 20000), LFNoise2.kr(1!2).range(0.01,1));
	FreeVerb2.ar(sig[0], sig[1], LFNoise2.kr(1!2).range(0,1), LFNoise2.kr(1!2).range(0,1), LFNoise2.kr(1!2).range(0,1)).distort;
}.play;

Routine({
	var freq = 500;
	loop {
		x.set(\freq, freq);
		if (freq > 5, {freq = 500.rrand(150)}, {freq = 0.0.rrand(5.0)});
		8.rrand(6.0).wait;
	}
}).play
)
8.rrand(6.0)

s.scope