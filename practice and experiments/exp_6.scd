s.reboot
s.options.sampleRate_(96000)
s.options.numInputBusChannels_(0)
s.options.numWireBufs_(1024);
s.options.memSize_(2.pow(16))

// fm grain going into a n-dimension fb network
(x.free; x = {
	var in, fb, n, out;
	n = 8;
	// in = GrainIn.ar(1, Dust.ar(1), 0.1, SinOscFB.ar(MouseY.kr(50, 5000, 1), MouseX.kr(0, 100)), WhiteNoise.ar, mul: 0.1);
	in = GrainFM.ar(1, Dust.ar(100), 0.001, WhiteNoise.ar.linexp(-1, 1, 50, 10000), WhiteNoise.ar.linexp(-1, 1, 50, 10000), WhiteNoise.ar.range(0, 10), WhiteNoise.ar);
	// in = SinOscFB.ar(Env.perc(0, 0.01).ar(0, Impulse.ar(1), levelScale: 15000, levelBias: 50), 2)  * Env.perc(0, 0.1).ar(0, Impulse.ar(1));
	fb = LocalIn.ar(n);
	out = fb;
	fb = fb + in;
	fb = LPF.ar(fb, 20000);
	fb = HPF.ar(fb, 20);
	fb = DelayN.ar(fb, delaytime: (ExpRand(50, 10000) * Array.rand(n, 0.95, 1.05)).reciprocal);
	fb = (fb * Array.fill(n, {
		K2A.ar(Array.rand(n, 0.0, 1.0).normalizeSum);
	})).sum;
	LocalOut.ar(fb);
	out = Mix(out);
	out = Limiter.ar(out);
	out = out + CombC.ar(out, delaytime: 250 * [1.01, 1/2.01, 3/4.01, 2/3.01], decaytime: 10, mul: 0).sum;
	out = out + Resonz.ar(out, Array.exprand(15, 50, 5000), 0.1);
	Out.ar(0, Normalizer.ar(Splay.ar(out)));
}.play)

a = [1,2,3,4]
[a[3], a[0..2]].flatten



(x.free; x = {
	var sig = ClipNoise.ar + SinOsc.ar(Env.perc(0, 0.01).ar(levelScale: 10000)) * Env.perc(0, 0.1).ar;
	sig = sig + DelayN.ar(sig, delaytime: Array.rand(5, 0.001, 0.03)).sum.tanh;
	sig = sig + Ringz.ar(sig, Array.exprand(5, 125, 1000), Array.exprand(5, 0.01, 1), 0.01).sum.tanh;
	sig = sig + Ringz.ar(sig, 250, 0.5, 0.01).tanh;
}.play)

(x.free; x = {
	var sig = [SinOsc.ar, WhiteNoise.ar];
	// matrix mixer
	// here we have a 2-d array (matrix) of mix values
	// the size of the inner arrays, aka, the # cols corresponds to the output size
	// the number of inner arrays, aka the # rows corresponsds to the input size
	/*
	the values in the cols mean how much of that rows sig to send to that cols output
	so [
	[0, 1],
	[1,0]
	]
	will send all of the second input to the first output
	and all the first input to the second output
	[[1,0],[0,1]] is identity
	[[0,1],[0,1]] will mix all both signals into second output
	*/
	sig = sig * [
		K2A.ar([0, 1]),
		K2A.ar([1, 0])
	];
	sig.sum;
}.play)

(x.free; x = {
	var sig = [SinOsc.ar, WhiteNoise.ar, Saw.ar(660)];
	// this will send sin to L, noise to R, and saw to both
	sig = sig * [
		K2A.ar([1, 0]),
		K2A.ar([0, 0.5]),
		K2A.ar([1, 1])
	];
	sig.sum.scope;
}.play)
ProxySpace.push
// using a matrix mixer for complex karplus feedback
(~a.free; ~a = {
	var in, fb, n, out, freq;
	freq = 150;
	n = 8;
	// in = GrainIn.ar(1, Dust.ar(5), 0.001, K2A.ar(1), WhiteNoise.ar);
	in = PinkNoise.ar;
	fb = LocalIn.ar(n);
	out = fb;
	fb = fb + in;
	fb = DelayC.ar(fb, delaytime: LFNoise2.kr(1.dup(n), 10, freq).reciprocal, mul: 0.99);
	fb = LPF.ar(fb, 22000);
	fb = HPF.ar(fb, 20);
	fb = fb * Array.fill(n, {K2A.ar(Array.exprand(n, 1, 10).normalizeSum)});
	fb = fb.sum;
	LocalOut.ar(fb);
	out = out + CombC.ar(out, delaytime: Scale.majorPentatonic.degreeToFreq(Array.rand(4, 0, 6), 440, 1).reciprocal, mul: 0.1);
	// out = out + Resonz.ar(out, Array.exprand(5, 50, 5000), 0.1, 5);
	Limiter.ar(LeakDC.ar(Splay.ar(out)));
}.play)
~a.play
~a.clear

// fb fm with a matrix mixer
// this mega patch is good!
(~b = {
	var n, fb, out, sig, recHead, playHead, bufs;
	n = 8;
	sig = SinOscFB.ar(
		/*LocalIn.ar(n).pow(1).linexp(-1, 1,
			LFDNoise3.kr(
				LFNoise1.kr(1).linexp(-1, 1, 0.01, 10)
			).linexp(-1, 1, 0.001, 50),
			LFDNoise3.kr(
				LFNoise1.kr(1).linexp(-1, 1, 0.01, 10)
			).linexp(-1, 1, 50, 10000)
		),*/
		n.collect({|i|
			SelectX.ar(LFNoise1.kr(1).bi2uni > 0, [
				Lag.ar(Demand.ar(Dust.ar(10), 0, Dseq(Scale.minor.degreeToFreq(Array.series(6, 0, 2), 440, 1).scramble, inf)), 0.1),
				LocalIn.ar(n)[i].linexp(-1, 1,
					LFDNoise3.kr(
						LFNoise1.kr(1).linexp(-1, 1, 0.1, 100)
					).linexp(-1, 1, 0.001, 50),
					LFDNoise3.kr(
						LFNoise1.kr(1).linexp(-1, 1, 0.1, 100)
					).linexp(-1, 1, 50, 10000)
				)
			]);
		}),
		LocalIn.ar(n).reverse.linexp(-1, 1,
			LFDNoise3.ar(
				LFNoise1.kr(1).linexp(-1, 1, 0.01, 10)
			).range(0.01, 1),
			LFDNoise3.ar(
				LFNoise1.kr(1).linexp(-1, 1, 0.01, 10)
		).linexp(-1, 1, 1, 100))
	);
	out = sig;
	fb = sig * Array.fill(n, {
		LocalIn.ar(n).scramble.linexp(-1, 1, 0.01, 10) * LFNoise1.kr(1.dup(n)).pow(1/4).bi2uni
	});
	fb = fb.sum;
	fb = DelayC.ar(fb, delaytime: PanAz.ar(n, K2A.ar(1), LFNoise1.kr(1), width: LFNoise1.kr(1).range(1, 3)).linexp(0, 1, 50, 1000).reciprocal);
	// matrix mix fb
	fb = fb * Array.fill(n, {
		// LFDNoise3.ar(LocalIn.ar(n).scramble.linexp(-1, 1, 0.01, 10)).range(0, 1)
		LocalIn.ar(n).reverse.linexp(-1, 1, 0.1, 1);
		// K2A.ar(Array.exprand(n, 1, 10).normalizeSum);
		// Array.fill(n, {LFNoise1.kr(1).bi2uni})
	});
	fb = fb.sum;
	// mBandComp fb
	/*fb = 10.collect({|i|
		var sig, hpf, lpf;
		switch(i,
		0, {sig = LPF.ar(fb, 60)},
		9, {sig = HPF.ar(fb, 60 * 2.pow(8))},
			{sig = HPF.ar(LPF.ar(fb, i.linexp(1, 8, 60 * 2, 60 * 2.pow(8))), i.linexp(1, 8, 60, 60 * 2.pow(7)))});
		// CompanderD.ar(sig, 0.5, 0.5, 0.5, 0.3, 0.3);
		// CompanderD.ar(sig, Rand(), ExpRand(), ExpRand(), ExpRand(), ExpRand(), 1/(i + 1));
		// gated compander with modulation
		CompanderD.ar(sig, LFNoise1.kr(1, 0.5, 0.5), LFNoise1.kr(1, 0.5, 1), LFNoise1.kr(1, 0.5, 1), ExpRand(), ExpRand(), 1/(i + 1)) * (Amplitude.ar(sig) > LFNoise2.kr(1).pow(1/4).bi2uni);
	}).sum;*/
	LocalOut.ar(fb);
	// resonsance
	out = out.collect({|ch|
		Ringz.ar(out, LFNoise1.kr(0.01.dup(n)).linexp(-1, 1, 50, 10000), Array.exprand(n, 0.001, 1)).sum;
	}) + out;
	// resonant body
	out = out.collect({|ch|
		Resonz.ar(ch, LFDNoise3.kr(0.01.dup(n)).linexp(-1, 1, 500, 10000), 1).sum
	});
	// allpass
	out = out.collect({|ch, i|
		var rq, freq, sig = ch;
		freq = LFDNoise3.kr(LocalIn.ar(n)[i].linexp(-1, 1, 0.1, 10)).linexp(-1, 1, 50, 5000);
		rq = LFDNoise3.kr(LocalIn.ar(n)[i].linexp(-1, 1, 0.1, 10)).bi2uni;
		20.do({sig = BAllPass.ar(sig, freq,rq)});
		sig;
	});

/*	out = out.collect({|ch, i|
		var chain = FFT(LocalBuf(1024), ch);
		chain = PV_RandComb(chain, LocalIn.ar(n)[i].range(0,1));
		chain = PV_BinScramble(chain, LocalIn.ar(n)[i].range(0,1));
		chain = PV_Freeze(chain, LFNoise1.kr(1) > 0);
		chain = PV_SpectralEnhance(chain, strength: 0.1);
		IFFT(chain);
	});*/
	// sympathetic strings
	/*out = out + CombC.ar(
		RHPF.ar(out, PanAz.ar(n, K2A.ar(1), LFNoise1.kr(1)).linexp(-1, 1, 5, 20000), 0.5),
		delaytime: Array.fill(n, {
			Lag.ar(
				Demand.ar(
					Dust.ar(1),
					0,
					Drand(
						Scale.minorPentatonic.degreeToFreq(
							Array.series(12, 0, 1),
							440,
							-2
						).scramble,
						inf
					)
				),
				0.1
			).reciprocal;
	}), decaytime: LFNoise1.kr(1.dup(n)).linexp(-1, 1, 1, 10), mul: 0.0);*/
	// reverb
	out = FreeVerb.ar(out, PanAz.ar(n, K2A.ar(0.5), LFNoise1.kr(1)), 0.1, 0);

	out = Limiter.ar(LeakDC.ar(Splay.ar(out)));
	//multiband compander
	out = 10.collect({|i|
		var sig, hpf, lpf;
		switch(i,
		0, {sig = LPF.ar(out, 60)},
		9, {sig = HPF.ar(out, 60 * 2.pow(8))},
			{sig = HPF.ar(LPF.ar(out, i.linexp(1, 8, 60 * 2, 60 * 2.pow(8))), i.linexp(1, 8, 60, 60 * 2.pow(7)))});
		// CompanderD.ar(sig, 0.5, 0.5, 0.5, 0.3, 0.3);
		// CompanderD.ar(sig, Rand(), ExpRand(), ExpRand(), ExpRand(), ExpRand(), 1/(i + 1));
		CompanderD.ar(sig, LFNoise1.kr(1, 0.5, 0.5), LFNoise1.kr(1, 0.5, 1), LFNoise1.kr(1, 0.5, 1), ExpRand(), ExpRand(), 1/(i + 1));
	}).sum;
	out;
})

~b[1] = nil
~b.play
s.record

({var sig = WhiteNoise.ar; sig + GrainIn.ar(2, Dust.ar(15), 0.1, DelayN.ar(sig, delaytime: 0.0001), WhiteNoise.ar)}.play)


Scale.major.degreeToFreq(0, 440, -3)
~c = {SinOscFB.ar(55, LFDNoise3.kr(LFNoise1.kr(1).linexp(-1, 1, 0.1, 10)).linexp(-1, 1, 1, 10))!2}
~c.play

~d = {var index, sig = [~a.ar, ~b.ar, ~c.ar]; index = ArrayMax.ar(Amplitude.ar(sig))[1]; Select.ar(index, sig).}
~d.play

// multiband compression freq splitter algorithm
20.collect({|i| [i.linexp(0, 19, 20, 11000), i.linexp(0, 9, 40, 22000)]}).postln;

60 * 2.pow(7)

({
	var sig = DWGBowed.ar(SinOsc.ar(5).pow(1/8).range(0, 1).midiratio * 2000, SinOsc.ar(50).fold(0, 1).pow(1/4) * 0.5);
	sig = DWGSoundBoard.ar(sig);
	sig = FreeVerb.ar(sig);
	sig
}.play)

// selects loudest
({var n = 4, sig, index;
	sig = Saw.ar(LFNoise1.kr(Rand(1, 10.dup(n))).linexp(-1, 1, 50, 5000), LFNoise1.kr(Rand(1, 10.dup(n))).linexp(-1, 1, 0.01, 1));
	index = ArrayMax.ar(Amplitude.ar(sig))[1];
	Select.ar(index, sig);
}.play)





(x.free; x = {
	var in, out, fb, n=8, trig = TDuty.ar(Dwrand([1/4,Dseq((1/16)!4)],[0.9, 0.1], inf));
	in = GrainIn.ar(n, trig, LFNoise1.kr(1).linexp(-1,1, 0.0001, 0.1), PinkNoise.ar, WhiteNoise.ar);
	// in = WhiteNoise.ar * Env.perc(0, 0.01).ar(gate: Impulse.ar(1));
	// in = PanAz.ar(n, in, LFNoise1.kr(1), width: LFNoise1.kr(1).range(1, n));
	fb = LocalIn.ar(n);
	out = fb;
	fb = LPF.ar(fb, LFNoise1.kr(1).linexp(-1, 1, 10000, 20000));
	fb = HPF.ar(fb, LFNoise1.kr(1).linexp(-1, 1, 20, 160));
	fb = DelayN.ar(fb, 0.2, (Demand.ar(trig, 0, Dseq(Scale.majorPentatonic.degreeToFreq((0..12)[0..4].scramble, 440, -1), inf)) * Array.fill(n, {LFNoise1.kr(1).midiratio})).reciprocal);
	fb = fb * Array.fill(n, {
		K2A.ar(Array.rand(n, 0.0, 10).normalizeSum);
	});
	fb = fb.sum;
	fb = fb + in;
	LocalOut.ar(fb);
	FreeVerb.ar(Limiter.ar(LeakDC.ar(Splay.ar(out))), room: 0.1, damp: 0);
}.play)

0.5.rand2

// some pseudo-ugens
// MultibandCompander.ar(numBands, in, control, threshold, slopeAbove, slopeBelow, atk, rel)
// every arg after 'in' can be an array or a single number applied to all bands

// MatrixMixer.ar(numOut, in, values)
// values is a 2d array that is numOut x in, can be numbers, or ugens

// SeqentialAllPass.ar(in, numPasses, freq, res)
// numPasses.do{
//   in = BAllPass.ar(in, freq, res);
// };
// in;



