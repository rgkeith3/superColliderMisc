(~a = {GrainSin.ar(4, Impulse.ar(MouseY.kr(1, 15)), MouseY.kr(1.reciprocal, 15.reciprocal), 50, WhiteNoise.ar(), e[\tri])})
~a.stop
~a.play
e

~a[0] = Pbind(\instrument, \oneShot, \buf, Prand(d[\samples][\zaps][1..3], inf), \panX, Pseq([1, -1, 1], inf), \panY, Pseq([-1, 1], inf), \amp, 1, \dur, 1/3, \rel, Pwrand([0.3, 2], [0.6, 0.4], inf))

d[\samples][\zap2]

~b = Pbind(\instrument, \oneShot, \buf, Prand(d[\samples][\drums][\ch][0..3], inf), \dur, 2/3, \amp, 1, \panX, PSinOsc(1), \panY, PSinOsc(1, 0.5))

~a.play
~a
~a.clear
~a = {PlayBuf.ar(1, d[\samples][\sexual].first, loop: 2)}
~a[5] = \filter -> {|in| in[0]!4}

(~a[7] = \filter -> {|in|
	[
		PitchShift.ar(in[0], 0.02, 0.5),
		PitchShift.ar(in[1], 0.02, 1.3333),
		PitchShift.ar(in[2], 0.02, 1.5),
		PitchShift.ar(in[3], 0.02, 2),
	]
})

~a.set(\wet7, 0.5)

(~a[10] = \filter -> {|in|
	var aSig, bSig, cSig, dSig;

	aSig = CombC.ar(in[0], 1, 0.25, 8);
	bSig = CombC.ar(in[1], 1, 0.5, 8);
	cSig = CombC.ar(in[2], 1, 0.75, 8);
	dSig = CombC.ar(in[3], 1, 1, 8);

	[aSig, bSig, cSig, dSig];
})

~a.set(\wet10, 0.5)

(
~a[15] = \filter -> {|in|
	var a, aChain, b, bChain, c, cChain, d, dChain;

	a = LocalBuf(1024);
	b = LocalBuf(1024);
	c = LocalBuf(1024);
	d = LocalBuf(1024);

	aChain = FFT(a, in[0]);
	bChain = FFT(b, in[0]);
	cChain = FFT(c, in[0]);
	dChain = FFT(d, in[0]);

	aChain = PV_RandComb(aChain, LFNoise1.kr(0.1).range(0, 1));
	bChain = PV_RandComb(bChain, LFNoise1.kr(0.1).range(0, 1));
	cChain = PV_RandComb(cChain, LFNoise1.kr(0.1).range(0, 1));
	dChain = PV_RandComb(dChain, LFNoise1.kr(0.1).range(0, 1));

	[
		IFFT(aChain),
		IFFT(bChain),
		IFFT(cChain),
		IFFT(dChain),
	]
})

~a.set(\wet15, 0.5)


(~a[20] = nil)


[1,[2]].flatten

~a.set(\wet20, 0.5)
s.sampleRate


~b[0] = Pbind(\instrument, \flutterSaw, \amt, Prand([0.01, 1], inf), \q, 0.1, \degree, Pseq([0,2,4,6], inf), \dur, 1/3, \octave, Pseq([3,4,5], inf), \rel, Pwrand([1, 4], [0.6, 0.4], inf), \cutoff, Pbrown(500, 5000, 100), \panX, Pwhite(-1), \panY, Pwhite(-1))

~b.play

(~b[10] = nil)
~b.set(\wet10, 1)


~c[0] = {var sig = PlayBuf.ar(1, d[\stereo_samples][\Miserere][0], [0.5, 1, 1.5, 1.333], loop: 1); sig * 0.1}

(~c[10] = \filter -> {|in|
	PanAz.ar(4, in[0], LFNoise1.kr(1)) +
	PanAz.ar(4, in[1], LFNoise1.kr(1)) +
	PanAz.ar(4, in[2], LFNoise1.kr(1)) +
	PanAz.ar(4, in[3], LFNoise1.kr(1));
})

(~c[10] = \filter -> {|in|
	GrainIn.ar(4, Dust.kr(LFNoise1.kr(0.1).range(0, 15)), LFNoise1.kr(0.1).range(0, 0.5), in[0], WhiteNoise.ar(), e[\saw]) +
	GrainIn.ar(4, Dust.kr(LFNoise1.kr(0.1).range(0, 15)), LFNoise1.kr(0.1).range(0, 0.5), in[1], WhiteNoise.ar(), e[\saw]) +
	GrainIn.ar(4, Dust.kr(LFNoise1.kr(0.1).range(0, 15)), LFNoise1.kr(0.1).range(0, 0.5), in[2], WhiteNoise.ar(), e[\saw]) +
	GrainIn.ar(4, Dust.kr(LFNoise1.kr(0.1).range(0, 15)), LFNoise1.kr(0.1).range(0, 0.5), in[3], WhiteNoise.ar(), e[\saw]);
})

~d[0] = {PlayBuf.ar(1, d[\samples][\breaks][5], 0.75, loop: 1) * 0.2}

(~d[5] = \filter -> {|in|
	[
		in[0], DelayL.ar(in[0], 0.1, SinOsc.ar(0.1).range(0, 0.1)), DelayN.ar(in[0], 0.2, SinOsc.ar(0.1).range(0, 0.2)), DelayN.ar(in[0], 0.3, SinOsc.ar(0.1).range(0, 0.3))
	]
})

(~d[30] = \filter -> {|in|
	PanAz.ar(4, in[0], SawDPW.ar(0.1, 0, 2)) +
	PanAz.ar(4, in[1], SawDPW.ar(0.1, 0.5, 2)) +
	PanAz.ar(4, in[2], SawDPW.ar(0.1, 1, 2)) +
	PanAz.ar(4, in[3], SawDPW.ar(0.1, -0.5, 2));
})

(~d[20] = \filter -> {|in|
	var freq, decay;
	freq = 250;
	decay = 1;
	[
		CombN.ar(in[0], delaytime: (freq * 0.5).reciprocal, decaytime: decay),
		CombN.ar(in[1], delaytime: (freq).reciprocal, decaytime: decay),
		CombN.ar(in[2], delaytime: (freq * 1.333).reciprocal, decaytime: decay),
		CombN.ar(in[3], delaytime: (freq * 1.5).reciprocal, decaytime: decay)
	];
})

~d.set(\wet20, 0.3)
~d.play

e.keys

d[\stereo_samples].keys

~a.stop;~b.stop
~a.play;~b.play
~c.play
~revSnd = ;

~revSnd

~rev = {[NHHall.ar(~revSnd.ar[0..1], 2), NHHall.ar(~revSnd.ar[2..3], 2)].flatten}
~rev.play

