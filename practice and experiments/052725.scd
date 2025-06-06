// Microsound chapter and inspirations
s.reboot
s.options.memSize_(2.pow(14))
(
x.free; x = {
	var freqs = Scale.phrygian.degreeToFreq((0..8).scramble[0..3], 440, -1).collect(_ * Array.geom(9, 1, 4/3)).flatten.sort;
	var mod = PanAz.ar(freqs.size, LFNoise2.ar(1).exprange(0.1, 5), LFNoise2.ar(0.1), width: LFNoise2.ar(0.1).range(2, freqs.size / 2));
	var all = freqs.collect({|f, i|
		var rate = MouseY.kr(0.01, 4, 1);
		var trig = DelayC.ar(Impulse.ar(rate.reciprocal), 1, Rand() * MouseX.kr);
		var sig = SinOscFB.ar(f, mod[i], mul: 1/freqs.size) * Env.perc(Rand(0, 0.5) * MouseX.kr, ExpRand(1, 4) * MouseY.kr).ar(0, trig);
		Pan2.ar(sig, Env([-1, -1, 1], [0, rate]).ar(0, trig));
	}).sum;

	// all = FreeVerb.ar(all, room: 1, damp: 0);

	OffsetOut.ar(0, all);
	// Out.ar(0, all);
}.play
)


			// Microsound - code figures //


		// perception at the micro time scale //

	//  pulses, transition from rhythm to pitch
{ Impulse.ar (XLine.kr(12, 48, 6, doneAction: 2)) * 0.1 ! 2 }.play; // up

{ Impulse.ar (XLine.kr(48, 12, 6, doneAction: 2)) * 0.1 ! 2 }.play; // down

{ Impulse.ar (MouseX.kr(12, 48, 1)) * 0.1 ! 2 }.play; // mouse-controlled





	// figure 16.1 short grain durations - pitch to colored click
(	// a gabor grain, gaussian-shaped envelope
SynthDef(\gabor, { |out, freq = 440, sustain = 1, pan, amp = 0.1, width = 0.25 |
	var env = LFGauss.ar(sustain, width, loop: 0, doneAction: 2);
	var son = FSinOsc.ar(freq, 0.5pi, env);
	OffsetOut.ar(out, Pan2.ar(son, pan, amp));

}).add;

	// or an approximation with a sine-shaped envelope
SynthDef(\gabor1, { |out, amp=0.1, freq=440, sustain=0.01, pan|
	var snd = FSinOsc.ar(freq);
	var env = EnvGen.ar(Env.sine(sustain, amp), doneAction: 2);
	OffsetOut.ar(out, Pan2.ar(snd * env, pan));
}).add;
)

(
Pbindef(\grain,
	\instrument, \gabor, \freq, 1000,
	\dur, 0.5, \sustain, 20/1000, \amp, 0.2
).play;
)
Pbindef(\grain, \sustain, 10/Pkey(\freq));
Pbindef(\grain, \sustain, 5/Pkey(\freq));
Pbindef(\grain, \sustain, 3/Pkey(\freq));
Pbindef(\grain, \sustain, 2/Pkey(\freq));
Pbindef(\grain, \sustain, 1/Pkey(\freq));

	// successively shorter, end
Pbindef(\grain, \sustain, Pseq((10..1)) / Pkey(\freq)).play;

	// random drift of grain duration
Pbindef(\grain, \sustain, Pbrown(1, 10, 3) / Pkey(\freq), \dur, 0.1).play




	// short grains seem softer
(
Pbindef(\grain,
	\instrument, \gabor, \freq, 1000, \dur, 1,
	[\sustain, \amp], Pseq([[0.001, 0.1], [0.1, 0.1]], inf)
).play;
)
		// short grain 2x louder
Pbindef(\grain, [\sustain, \amp], Pseq([[0.001, 0.2], [0.1, 0.1]], inf));

		// short grain 4x louder
Pbindef(\grain, [\sustain, \amp], Pseq([[0.001, 0.4], [0.1, 0.1]], inf));



	// a grain with quasi-rectangular envelope, short grain 6x louder.
(
SynthDef(\pip, { |out, freq=440, sustain=0.02, amp=0.2, pan=0|
	OffsetOut.ar(out,
		Pan2.ar(SinOsc.ar(freq)
		* EnvGen.ar(Env.linen(0.0005, sustain - 0.001, 0.0005, amp), doneAction: 2), pan)
	);
}).add;

	// is this equal loudness?
Pbindef(\grain).clear;
Pbindef(\grain,
	\instrument, \pip,
	\freq, 1000, \dur, 1,
	\sustain, Pseq([0.001, 0.1], inf),
	\amp, Pseq([0.6, 0.1], inf)
).play;
)




	// figure 16.2 - Perception of short silences.
(
p = ProxySpace.push;

~source = { SinOsc.ar * 0.1 };
~silence = { |silDur=0.01|
	EnvGen.ar(
		Env([0, 1, 1, 0, 0, 1, 1, 0], [0.01, 2, 0.001, silDur, 0.001, 2, 0.01]),
		doneAction: 2) ! 2
};
~listen = ~source * ~silence;
~listen.play;
)

~silence.spawn([\silDur, 0.001]); // sounds like an added pulse
~silence.spawn([\silDur, 0.003]);
~silence.spawn([\silDur, 0.01]);
~silence.spawn([\silDur, 0.03]);	  // a pause in the sound

	// try the same examples with noise:
~source = { WhiteNoise.ar * 0.1 };

p.clear.pop;




	// figure 16.3 - order confusion with sounds in fast succession.
	// as grains move closer and closer together, their order becomes ambiguous.

/// Grain Synths should use OffsetOut for sample accurate timing, LOOK IT UP
(
			// a simple percussive envelope
SynthDef(\percSin, { |out, amp=0.1, freq=440, sustain=0.01, pan|
	var snd = FSinOsc.ar(freq);
	var env = EnvGen.ar(
		Env.perc(0.1, 0.9, amp), timeScale: sustain, doneAction: 2);
	OffsetOut.ar(out, Pan2.ar(snd * env, pan));
}, \ir ! 5).add;
)
(
Pbindef(\lo,
	\instrument, \percSin, \sustain, 0.05,
	\freq, 250, \amp, 0.2, \dur, 0.5, \lag, 0
).play;
Pbindef(\hi,
	\instrument, \percSin, \sustain, 0.05,
	\freq, 875, \amp, 0.1, \dur, 0.5, \lag, 0
).play;
)
	// try different lag times between them
Pbindef(\hi, \lag, 0.1);
Pbindef(\hi, \lag, 0.03);
Pbindef(\hi, \lag, 0.01);
Pbindef(\hi, \lag, 0.003);

	// hi too early or too late by a fixed time - which one is first?
Pbindef(\hi, \lag, ([-1, 1].choose * 0.01).postln).play;
Pbindef(\hi, \lag, ([-1, 1].choose * 0.02).postln);

	// is it easier to hear when the sounds are panned apart?
Pbindef(\hi, \pan, 0.5); Pbindef(\lo, \pan, -0.5);
Pbindef(\hi, \pan, 0);   Pbindef(\lo, \pan, 0);





	// figure 16.4: multiple grains fuse into one composite.
	// when their order changes, the sound is subtly different.
(
Pbindef(\grain4,
	\instrument, \percSin, \sustain, 0.03, \amp, 0.2,
	\freq, Pshuf([1000, 600, 350, 250]), // random every each time
	\dur, 0.005
).play;
				// repeat grain cluster
Tdef(\grain, { loop { Pbindef(\grain4).play; 1.wait } }).play;
)
	// fixed order
Pbindef(\grain4, \freq, Pseq([1000, 600, 350, 250].scramble));

	// different order every time
Pbindef(\grain4, \freq, Pshuf([1000, 600, 350, 250]));

Env.sine.test
Env([0,1,1,0], [0.25, 0.5, 0.25] * 0.1, \sin).test.plot
Env([0,1,1,0], [0.25, 0.5, 0.25] * 0.1, \lin).test.plot
Env([0,1,1,0], [0.25, 0.5, 0.25] * 0.1, \welch).test.plot
Env([1, 0.00001], 0.1, \exp).test
Env([0.00001, 1], 0.1, \exp).test
Env.perc(0.01, 0.09).test


(
q = q? ();
q.makeSinc = {|q, num=1, size=400|
	{|x| x = x.linlin(0, size-1, -pi, pi) * num; sin(x) / x} ! size
};

a = q.makeSinc(6);
a.plot(bounds: Rect(0, 0, 409, 200), minval: -1, maxval: 1);
)

~decoder = FoaDecoderKernel.newListen;

~env1 = Buffer.loadCollection(s, Env([0.0001, 1, 0.0001], [0.01, 1], \exp).discretize);
~env2 = Buffer.loadCollection(s, Env([0.0001, 1, 0.0001], [0.01, 1].reverse, \exp).discretize);
~env2 = Buffer.loadCollection(s, Env.sine.discretize);
(x.free; x = {
	// var grate = 2.pow(MouseX.kr(-5, 10));
	var grate = LFDNoise3.ar(LFNoise1.ar(1).exprange(0.1, 10)).exprange(2.pow(-5), 2.pow(10));
	var scale = 5;
	var gtrig = Impulse.ar(grate);
	// var prate = 2.pow(MouseY.kr(-5, 10));
	var prate = LFDNoise3.ar(LFNoise1.ar(1).exprange(0.1, 10)).exprange(2.pow(-5), 2.pow(10));
	var ptrig = Impulse.ar(prate);
	var params = Lag.ar(Demand.ar(ptrig, 0, [
		Dseq(Array.rand(16, -1.0, 1.0) * scale, inf), // x
		Dseq(Array.rand(16, -1.0, 1.0) * scale, inf), // y
		Dseq(Array.rand(16, -1.0, 1.0) * scale, inf), // z
		Dseq(Array.fill(16, {Scale.phrygian.degreeToFreq(12.rand2, 440, 0)}), inf), //freq
		Dseq(Array.rand(16, 0, 10), inf), // fmindex
		Dseq(Array.rand(16, 0, 1), inf) // env interp
	]), grate.reciprocal / 4);
	var coord = Cartesian(params[0], params[1], params[2]);

	var sig = FMGrainIBF.ar(
		gtrig,
		grate.reciprocal * LFNoise1.ar(0.1).exprange(1/10, 10),
		params[3],
		params[3] * 1.5,
		~env1,
		~env2,
		params[5],
		params[4],
		coord.theta,
		coord.phi,
		coord.rho
	);
	sig = AmbiVerbSC.ar(sig, 0.3, dispersion: 0.5);
	sig = FoaDecode.ar(sig, ~decoder);
	OffsetOut.ar(0, sig);
}.play
)


(x.free; x = {
	// var noiseLevel = LFNoise1.ar(1).bi2uni;
	var posNoise = MouseY.kr;
	var freqNoise = MouseX.kr(0, 1);
	var paramTrig = Impulse.ar(4);
	var freqIndex = (Stepper.ar(paramTrig, max: 15) + WhiteNoise.ar(freqNoise * 16).floor);
	var freq = Select.ar(freqIndex, DC.ar(Scale.phrygian.degreeToFreq(Array.rand(16, -6, 12), 440, 0)));

	var grate = LFNoise1.ar(0.1).exprange(1, 1000);
	// var grate = 50;

	var pos = Demand.ar(paramTrig, 0, [
		Dseq(Array.rand(16, -10.0, 10), inf),
		Dseq(Array.rand(16, -10.0, 10), inf),
		Dseq(Array.rand(16, -10.0, 10), inf)
	]);

	var coord = Cartesian(
		pos[0] + WhiteNoise.ar(posNoise * 10),
		pos[1] + WhiteNoise.ar(posNoise * 10),
		pos[2] + WhiteNoise.ar(posNoise * 10)
	);
	var sig = FMGrainIBF.ar(Impulse.ar(grate), grate.reciprocal * LFNoise1.ar(0.1).exprange(1/2, 8), freq, freq * 1.5, 1, ~env1, ~env2, 1, coord.theta, coord.phi, coord.rho);

	// sig = AmbiVerbSC.ar(sig, 0.3, dispersion: 0);
	sig = FoaDecode.ar(sig, ~decoder);
	OffsetOut.ar(0, sig);
}.play)


(x.free; x = {
	var res = GrainIn.ar(10, Impulse.ar(MouseY.kr(1, 1000, 1)), 0.00001, DC.ar(1), LFNoise2.ar(MouseX.kr(1, 100, 1)));

	var sig = res.collect({|ch|
		PanB.ar(
			Ringz.ar(ch,
				Scale.phrygian.degreeToFreq((0..12).scramble[0..3], 440, 0),
				Array.exprand(4, 0.001, 1),
				1/4
			).sum,
			LFNoise2.ar(1, pi),
			LFNoise2.ar(1, pi/2)
		);
	}).sum;

	sig = FoaDecode.ar(sig, ~decoder);
	OffsetOut.ar(0, sig);
}.play)

(x.free; x = {
	var res = PanAz.ar(10, Env.sine(0.00001).ar(0, Impulse.ar(LFNoise2.ar(0.2).exprange(8, 32))), MouseX.kr(-1,1), width: MouseY.kr(1, 9));

	var sig = res.collect({|ch|
		PanB.ar(
			Ringz.ar(ch,
				Scale.phrygian.degreeToFreq((0..12).scramble[0..3], 440, 0).sort,
				Array.exprand(4, 0.001, 1).sort.reverse,
				1/4
			).sum,
			LFNoise2.ar(1, pi),
			LFNoise2.ar(1, pi/2)
		);
	}).sum;


	sig = FoaDecode.ar(sig, ~decoder);
	OffsetOut.ar(0, sig);
}.play)


(x.free; x = {
	var cycle = MouseY.kr(1/4, 64, 1);
	var harms = (1..32);
	var freq = 50;

	var sig = Mix(FSinOsc.ar(freq * harms, 0, harms.size.reciprocal) * Env([1,0, 1], 1/2).ar(0, Impulse.ar(cycle), cycle.reciprocal).pow(harms - 1));
	OffsetOut.ar(0, sig);
}.play)

(x.free; x = {
	var sig = Blip.ar(40, LFSaw.ar(-10).exprange(1, 20));
	Out.ar(0, sig);
}.play)

(x.free; x = {
	var freqs = Scale.phrygian.degreeToFreq([0,2,4,6], 440, -1);
	// SinOsc.ar(freqs,mul: 10).distort.sum;
	SinOsc.ar(freqs, mul: 10).sum.distort;
}.play)

s.scope

