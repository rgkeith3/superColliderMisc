(x.free;x = {
	var sig, in, freq = \freq.kr(440);
	sig = BrownNoise.ar * Env.perc(0, 0.01).ar(gate: Changed.ar(K2A.ar(freq)));
	in = LocalIn.ar(3);
	in = LPF.ar(in, 5000);
	in = HPF.ar(in, 50);
	// in = FreqShift.ar(in, TRand.ar(-1, trig: Changed.ar(K2A.ar(freq))));
	in = SplayAz.ar(3, in, 0.002);
	in = in + sig.dup(3);
	in = DelayC.ar(in, delaytime: [1, 1.0001, 0.9999] * freq.reciprocal);
	// I was using a Limiter between the delay and the local out, but a limiter has a built in delay, so it screws up the pitch info
	LocalOut.ar(in);
	in = Limiter.ar(in);
	in;
}.play)

x.set(\freq, rrand(22, 880))


(x.free; x={
	var sig, trig = GaussTrig.ar(10, SinOsc.kr(0.1).bi2uni);
	sig = Ringz.ar(trig, Array.exprand(50, 50, 5000), Array.exprand(50, 0.001, 1), 1/50).sum;
	Splay.ar(Resonz.ar(sig, LFNoise1.kr(0.1!50).linexp(-1, 1, 50, 5000), LFNoise1.kr(0.1!50).linexp(-1, 1, 0.001, 1)));
}.play)