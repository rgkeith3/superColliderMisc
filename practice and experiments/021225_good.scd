
s.reboot

~env = Buffer.loadCollection(s, Env.perc.discretize);

(x.free; x = {
	// xfade between two chords
	// var harm1 = Scale.major.tuning_(\just).degreeToFreq([0,2,4,6], 440, -2).collect(_ * [1,2,3,4,5]).flatten.scramble;
	// var harm2 = Scale.major.tuning_(\just).degreeToFreq([1,3,5,7], 440, -2).collect(_ * [1,2,3,4,5]).flatten.scramble;
	// var freqs = SelectX.ar(MouseY.kr(0, 2).poll, DC.ar([harm1, harm2]));

	// pick a random chord
	// var freqs = DC.ar(Scale.major.tuning_(\just).degreeToFreq((0..8).scramble[0..3].postln, 440, -2).collect(_ * (1..5)).flatten.scramble);

	// every 8 seconds, slide to random new chord
	var freqs = Array.fill(4, {
		Lag.ar(
			Duty.ar(8,0,Drand(Scale.major.tuning_(\just).degreeToFreq((0..8), 440, -2),inf)),
			0.5
		)
	}).collect(_*(1..5)).flatten.postln;

	var gfreq = Select.ar(WhiteNoise.ar.range(0, freqs.size), freqs);
/*	var sig = Splay.ar(
	 	Ringz.ar(
	 		GrainIn.ar(
	 			20,
	 			Dust.ar(50),
	 			0.001,
	 			DC.ar(1),
	 			WhiteNoise.ar
	 		),
	 		freqs,
	 		Array.exprand(20, 0.1, 10),
	 		1/20
	 	)
	);*/
	var sig = GrainFM.ar(
		8,
		Dust.ar(MouseX.kr(1, 100, 1)),
		WhiteNoise.ar.exprange(0.01, 10),
		gfreq,
		gfreq * Select.ar(WhiteNoise.ar.range(0, 3), DC.ar([1.5, 2, 3, 4])),
		WhiteNoise.ar.exprange(0.1, LFNoise2.ar(0.1).exprange(2, 100)),
		// LFNoise2.ar(1).exprange(0.1, 10),
		WhiteNoise.ar,
		~env,
		mul: 1/20
	);
	sig = CombC.ar(sig, 0.5, LFNoise0.ar(0.1!8).exprange(0.125, 0.5), LFNoise2.ar(0.2!8).exprange(1, 10), 0.5) + sig;
	sig = XFade2.ar(BPF.ar(sig, LFNoise2.ar(10!8).exprange(20, 10000), LFNoise2.ar(1!8).range(0.1, 1)), sig, LFNoise2.ar(0.1));
	sig = CombC.ar(sig, 0.5, LFNoise0.ar(0.1!8).exprange(0.125, 0.5), LFNoise2.ar(0.2!8).exprange(1, 10), 0.5) + sig;
	sig = Splay.ar(sig, center: LFNoise2.ar(0.1));

	sig = FreeVerb2.ar(sig[0], sig[1], LFNoise2.ar(1).bi2uni, LFNoise2.ar(1).bi2uni, LFNoise2.ar(1).bi2uni);
	sig;
}.play)

0.125 / 2 / 2


(x.free; x = {
	var sig = Saw.ar(LFPulse.ar(Rand(1, 16), width: Rand()).range(150, 300)) * Env.perc.ar(2);
	AllpassC.ar(sig, 0.2, Array.exprand(20, 50, 10000).reciprocal, 0.0001).sum - sig;
}.play)

(x.free; x = {
	var env = Env.perc(0.0, 0.25);
	RLPF.ar(Saw.ar(150), env.ar(0, 1, 1, 20000, 20), 1) * env.ar(2, 1)
}.play)

Env([3,6, 3], 8, \step).plot

(
Pbind(\dur, Pseq(Bjorklund2(5, 8) ++ [8], inf, 2) / 8, \degree, Pseq(Array.rand(6, 0, 8), inf), \mtranspose, Pstep([0, 1, 2, 3], 8, inf),  \scale, Scale.major).play;
Pbind(\dur, 1, \degree, Pseq(Array.rand(2, 0, 3), inf), \mtranspose, Pstep([0, 3, 4, 1], [8, 8, 9, 7], inf), \octave, 3, \scale, Scale.major).play
)
[Bjorklund2(2, 5), Bjorklund2(2, 8), Bjorklund2(1, 3), Bjorklund2(3, 16)].flatten.scramble / 2





(~synth = {
	var freq = Select.ar(WhiteNoise.ar.range(0, 19), DC.ar(\freq.kr(Array.rand(20, 150, 1000), 1)));
	var sig = GrainFM.ar(
		2,
		Impulse.ar(50),
		WhiteNoise.ar.exprange(0.01, 10),
		freq,
		freq * Select.ar(WhiteNoise.ar.range(0, 3), DC.ar([1.5, 2, 3, 4])),
		WhiteNoise.ar.exprange(0.1, 1),
		WhiteNoise.ar,
		~env,
		mul: 1/20
	);

	FreeVerb.ar(sig);
}.play)

(Routine({
	loop {
		var chord = [[0,2,4,6],[3,5,7,9]].choose;
		var freqs = Scale.minor.tuning_(\just).degreeToFreq(chord, 440, -2).collect(_ * [1,2,3,4,5]).flatten.postln;

		~synth.set(\freq, freqs);
		6.wait;
	}
}).play)

// alienbugs
(x.free; x = {
	var env = Env([0, 1, 0], [Rand(), Rand()], [Rand(-4, 4), Rand(-4, 4)]);
	var rate = Rand(hi: 50);
	var sig;
	env = env.ar(0, Impulse.ar(rate), rate.reciprocal);
	sig = SinOscFB.ar(env.linexp(0, 1, Rand(5000, 10000), Rand(10000, 20000)), Rand(hi: 1.5)) * env;
	sig = BPF.ar(sig, LFNoise1.ar(ExpRand(1, 1000)).exprange(5000, 20000), Rand());
	sig = sig * Env([0,1,1,0], [0.1, Rand(), 0.1]).ar(0, 1);
	sig = Pan2.ar(sig, Rand(-1));
	// sig = FreeVerb.ar(sig, Rand(), Rand(), Rand());
	DetectSilence.ar(sig, doneAction: 2);
	sig
}.play)