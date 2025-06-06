s.boot
~env = Buffer.sendCollection(s, Env.perc(0.001, 1, curve: -10).discretize);
~env2 = Buffer.sendCollection(s, Env.perc(1, 0.01, curve: 8).discretize);
// sinOscfb is the individual partial
// and MouseY controls the phase of the impulses used to trigger the partials
// so you could trigger all partials at the same time and get a bell, or offset the triggering of specific partials
(x.free; x = {
	var sig, freq, rate, ratios1, ratios2;
	rate = SinOsc.ar(0.1).exprange(0.1, 250);
	// rate = MouseX.kr(0.1, 250, 1);
	freq = 500;
	ratios1 = Scale.minor.tuning_(\just).degreeToRatio([0, 2, 4, 6], 0).collect(_ * (1..8)).flatten.sort;
	ratios2 = Scale.minor.tuning_(\just).degreeToRatio([1, 3, 5, 7], 0).collect(_ * (1..8)).flatten.sort;
	sig = Splay.ar(
		SinOscFB.ar(
			freq * SelectX.ar(LFNoise2.ar(0.1).range(0,1), DC.ar([Array.rand(32, 1.0, 32).sort, (1..32);])),
			// freq * ratios1,
			// freq * SelectX.ar(SinOsc.ar(0.051).range(0, 1), [DC.ar(ratios1), DC.ar(ratios2)]),
			PanAz.ar(
				32,
				DC.ar(2),
				LFNoise2.ar(0.1),
				width: LFNoise2.ar(0.1).range(0, 32)
				// width: MouseX.kr(0, 32)
			),
			// env shape per partial
			mul: Env.perc(
				PanAz.ar(
					32,
					DC.ar(rate.reciprocal / 2),
					LFNoise2.ar(0.1),
					width: LFNoise2.ar(0.1).range(0, 32)
				),
				rate.reciprocal / 2,
				1,
				0
			).ar(
				gate: Impulse.ar(
					rate,
					Array.interpolation(32, 1, 0) * MouseY.kr(-1, 1).pow(4)
				)
			)
		)
	);
	// sig;
	sig + NHHall.ar(sig);
}.play)

// reverb pop
(x.free; x = {
	FreeVerb.ar(GrainSin.ar(2, Impulse.ar(0), 0.001, ExpRand(1000, 5000), Rand(-1.0)),Rand(), Rand(), Rand())
}.play)

-0.5.pow(2)

(x.free; x = {
	RLPF.ar(Blip.ar(50, 10000), MouseY.kr(20, 22000, 1), 0.01).distort
}.play)

(x.free; x = {
	var freq, res, amp;
	# freq, res, amp = SelectX.ar(LFNoise2.kr(1).range(0, 2),  DC.ar([FormantTable.rand, FormantTable.rand, FormantTable.rand]));
	BPF.ar(Saw.ar(LFNoise2.kr(0.1).exprange(20, 100)), freq, res * 0.2, amp * 2).sum;
}.play)

(x.free; x = {
	SinOsc.ar(450 * Array.interpolation(32, 1, 8), mul: Env.perc(0, 2, 1, -8).ar(0, Impulse.ar(Array.interpolation(32, 1, 0.9) * 0.5))).sum
}.play)

Array.interpolation(32, 0.1, 0.01)

// the reverse grain env is cool here!
(
SynthDef(\res, {
	var freq = \freq.kr(440, 2);
	var sig = Resonz.ar(WhiteNoise.ar, freq, 0.01, 5);
	sig = Pan2.ar(sig, \pan.kr(0, 2));
	sig = sig + GrainFM.ar(
		2,
		Dust.ar(10),
		1,
		freq,
		Select.ar(WhiteNoise.ar.range(0, 3), DC.ar(freq * [1, 1.5, 2, 2.5])),
		WhiteNoise.ar.range(0, 10),
		WhiteNoise.ar,
		~env2,
		mul: 0.5);
	Out.ar(\out.kr(0), sig);
}).load;
)

(x.free; x = {
	var sig, trig = Dust2.ar(10);
	// glide trig through 1st dimension (comb time)
	trig = PanAz.ar(4, trig, WhiteNoise.ar, width: 1);

	// then the different dimensions of grain gens, spawn the grains in the second dimension (pan)
	sig = trig.collect({|chan|
		var g = GrainFM.ar(2, chan, 0.001, 400.rrand(800), 800.rrand(1600), 2, WhiteNoise.ar);
		g + NHHall.ar(g, 2.0.rand, 1.0.rand, earlyDiffusion: 1.0.rand, lateDiffusion: 1.0.rand, modRate: 1.0.rand, modDepth: 1.0.rand);
	});
	sig.sum;
}.play)

(
Routine({
	var freqs = Scale.minor.tuning_(\just).degreeToFreq((-12..12).scramble[0..8], 440, 0);
	var synths = freqs.collect {|freq|
		Synth(\res, [\freq, freq, \pan, 1.0.rand2]);
	};
	loop {
		freqs = Scale.minor.tuning_(\just).degreeToFreq((-12..12).scramble[0..8], 440, 0);
		synths.do {|synth, i|
			synth.set(\freq, freqs[i]);
			synth.set(\pan, 1.0.rand2);
		};
		8.wait;
	}
}).play

)