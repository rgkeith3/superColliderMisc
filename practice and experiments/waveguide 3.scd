s.boot

(x.free; x = {
	var sig, in, freqs, n=5, trig = \t_trig.kr(1);
	sig = PinkNoise.ar * Env.perc(0, 0.01).ar(gate: trig);
	// freqs = Array.exprand(n, 5, 500).reciprocal;
	freqs = TExpRand.kr(5000.reciprocal, 50.reciprocal.dup(n), trig);
	in = LocalIn.ar(n);
	in = in.collect({|chan| Resonz.ar(chan, TExpRand.kr(50.dup(15), 5000, trig), TExpRand.kr(0.01.dup(15), 0.1, trig)).sum}).scramble;
	sig = in + sig;
	sig = SplayAz.ar(n, sig,0.1, width: n);
	sig = DelayC.ar(sig, delaytime: freqs);
	LocalOut.ar(sig);
	sig = Limiter.ar(sig);
	Splay.ar(sig);
}.play)
x.set(\t_trig, 1)


s.scope