s.boot

({
	#f,a,q = SelectX.kr(LFNoise1.kr(0.1).range(0, 3), [FormantTable.rand, FormantTable.rand, FormantTable.rand]);
	Ringz.ar(GrainIn.ar(1, GaussTrig.ar(50, 1), 0.0001, PinkNoise.ar), f, q/4, a).sum
}.play)


// grain dust into a network of feedback wave guides is kind of an interesting idea, but all the best sounds come out of the resonz here
({
	var freq, f, a, q, sig, fb, n = 8;
	freq = LFNoise2.ar(0.1).exprange(50, 1500).reciprocal;
	sig = GrainIn.ar(n, GaussTrig.ar(500, 1), WhiteNoise.ar.linexp(-1, 1, 0.00001, 0.01), PinkNoise.ar, WhiteNoise.ar);
	fb = LocalIn.ar(n);
	fb = HPF.ar(LPF.ar(fb, 20000), 20);
	// for whatever reason, the splay width can only ever be n/2, otherwise it'll blow up
	fb = SplayAz.ar(n, fb, 0.01, width: n/2) + sig;
	fb = fb.collect({|chan|
		// swap delay, comb, allpass
		// comb sounds cool when the loop is limited, otherwise, it blows up
		DelayC.ar(chan, delaytime: freq);
	});
	// because limiters have a built in delay, using one here will destroy pitch info
	// but it doessound cool
	// fb = Limiter.ar(fb);
	LocalOut.ar(fb);
	fb = Splay.ar(fb);
	fb = fb.collect({|chan|
		Resonz.ar(chan, Array.exprand(15, 50, 10000), 0.001, 10).sum;
	});
	Limiter.ar(fb);
}.play)

FormantTable.rand
