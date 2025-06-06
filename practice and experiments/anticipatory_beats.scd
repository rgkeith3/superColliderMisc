s.reboot

(
~env = Buffer.sendCollection(s, Env.perc(0.001, 1, curve: -10).discretize);
)

(
// kick w/ gate and build up
SynthDef(\k, {
	var sig, gate = \gate.kr(1), freq = \freq.kr(50), fuzz = \fuzz.kr(0).linexp(0, 1, 0.01, 10000);
	sig = SinOscFB.ar(Env.perc(0, 0.01, curve: -4).ar(gate: gate, levelScale: freq * 10000, levelBias: freq), Env.perc(0, 0.01).ar(gate: gate, levelScale: fuzz, levelBias: fuzz));
	sig = sig * Env.perc(0, \rel.kr(1)).ar(2, gate);
	sig = Pan2.ar(sig, \pan.kr(0));
	Out.ar(\out.kr(0), sig);
}).load;

SynthDef(\crackle, {
	var env, sig;
	env = Env([0, 1], \dur.kr(2), 10).ar(2, \gate.kr(1));
	sig = Crackle.ar(2) * env;
	sig = Pan2.ar(sig, \pan.kr(0));
	sig = sig + Resonz.ar(sig, Array.exprand(4, 20, 10000), 0.1, 10).sum;
	sig = (sig * 5).distort;
	Out.ar(\out.kr(0), sig);
}).load;


SynthDef(\sprinkle, {
	var freq = \freq.kr(440);
	var dur = \dur.kr(10);
	var density = \density.kr(50);
	var car = Select.ar(WhiteNoise.ar.range(0, 3), DC.ar(freq * [1, 0.5, 2, 4]));
	var mod = Select.ar(WhiteNoise.ar.range(0, 3), DC.ar(car * [1, 0.5, 2, 4]));
	var env = Env([0, 1, 0], [1, 0].normalize * dur, 4).ar(2, 1);
	var sig = GrainFM.ar(
		2,
		Dust.ar(env * density),
		env * dur,
		car,
		mod,
		WhiteNoise.ar.exprange(1, 10),
		WhiteNoise.ar,
		~env,
		mul: 1 / density
	);
	Out.ar(\out.kr(0), sig);
}).load;

SynthDef(\tin, {
	var freq = \freq.kr(10000);
	var bps = \bps.kr(2);
	var dur = \dur.kr(1);
	var env = Env([0, 1, 0], [1, 0] * dur * 0.75, 8).ar(0, 1);
	var sig = SinOsc.ar(freq) * env;
	sig = sig + (Blip.ar(bps * [1, 2, 4, 3, 6, 8].choose, freq / 8) * Env([0, 1, 1, 0], [0, 1, 0] * dur * 0.25).ar(2, Done.kr(env)));
	Out.ar(\out.kr(0), Pan2.ar(sig, \pan.kr(0)));
}).load;


SynthDef(\tik, {
	var sig = WhiteNoise.ar * Env.perc(0, \rel.kr(0.001)).ar(2, \gate.kr(1));
	sig = Pan2.ar(sig, \pan.kr(0));
	Out.ar(\out.kr(0), sig);
}).load;

SynthDef(\arp, {
	var tickRate, tick, freq, pan, env, sig, div;
	div = \div.kr(4);
	tickRate = \bps.kr(2) * Env([1, 0.25, 1] * div, \dur.kr(2)!2 / 2, \sin).ar(2, \gate.kr(1));
	tick = Impulse.ar(tickRate);
	freq = Demand.ar(tick, 0, Dseq(\freqs.kr([2133.3333333309, 2399.9999999961, 2879.9999999932, 1600.0] / 8), inf));
	freq = Lag.ar(freq, 0);
	env = Env(times: \atkRel.kr(0.1).linlin(0, 1, [1, 0], [0, 1])).ar(0, tick);
	sig = Saw.ar(freq) * env;
	sig = RLPF.ar(sig, freq * 16, 0.1);
	sig = Pan2.ar(sig, Demand.ar(tick, 0, Dbrown(-1.0, step: 0.1)), 0.3);
	Out.ar(\out.kr(0), sig);
}).load;

SynthDef(\plinks, {
	var freqs = \freqs.kr(Array.exprand(6, 20, 20000));
	var dur = \dur.kr(10);
	// var sig = Splay.ar(Saw.ar(freqs, 1/4));
	var freq = Select.ar(WhiteNoise.ar.range(0, freqs.size -1), DC.ar(freqs));
	var sig = GrainFM.ar(2, Dust.ar(SinOscFB.ar(XLine.ar(20, 1, dur, doneAction: 0), 0).exprange(1, 500) * Env([1, 1, 0], dur * [0.8, 0.2], 0).ar(2)), 1, freq, freq * 3, BrownNoise.ar.exprange(0.1, 50), LFDNoise3.kr(XLine.ar(50, 0.01, 10)), ~env, mul: 1/5);
	// sig = LPF.ar(sig + PinkNoise.ar(0.25), SinOscFB.ar(XLine.ar(20, 1, 10, doneAction: 2), 0.5).exprange(50, 5000));
	Out.ar(\out.kr, sig * 0.25);
}).load;

SynthDef(\sawz, {
	var freqs = \freqs.kr(Array.exprand(4, 20, 20000));
	var dur = \dur.kr(10);
	var sig = Splay.ar(Saw.ar(freqs, 1/4));
	sig = LPF.ar(sig + PinkNoise.ar(0.25), SinOscFB.ar(XLine.ar(\start.ir(20), \end.ir(1), dur, doneAction: 2), 0.5).exprange(50, 5000));
	Out.ar(\out.kr, sig);
}).play;
)


(x.free; x = {
	var freqs = Scale.minor.tuning_(\just).degreeToFreq((-12..12).scramble[0..5], 400, 0);
	// var sig = Splay.ar(Saw.ar(freqs, 1/4));
	var freq = Select.ar(WhiteNoise.ar.range(0, freqs.size -1), DC.ar(freqs));
	var sig = GrainFM.ar(2, Dust.ar(SinOscFB.ar(XLine.ar(20, 1, 10, doneAction: 0), 0).exprange(1, 500) * Env([1, 1, 0], [9, 2], -4).ar(2)), 1, freq, freq * 3, BrownNoise.ar.exprange(0.1, 50), LFDNoise3.kr(XLine.ar(50, 0.01, 10)), ~env, mul: 1/5);
	// sig = LPF.ar(sig + PinkNoise.ar(0.25), SinOscFB.ar(XLine.ar(20, 1, 10, doneAction: 2), 0.5).exprange(50, 5000));
	sig;
}.play)
Scale.minor.tuning_(\just).degreeToFreq((0..6).scramble[0..3], 50, 5)

// add a snare w build
// and kick, and snare, and high hat without build

// two more synths
// ringing dust that follows a up, down, up envelope that swells at the end.
// swelling tinitus followed by some random interval of clicks at the end...
// i guess these are all kind of 'end-focused' synths

Synth(\arp, [\dur, 2, \div, 6, \freqs, Scale.minor.tuning_(\just).degreeToFreq((0..6).scramble[0..3], 50, 5)])

(
var kickLoop = {|scale, freq|
	Routine({
		var durs = Pconst(8, Prand([1, 1/2, 2, 1/4], inf)).asStream;
		durs.do{|dur|
			Synth(\k, [\pan, 1.0.rand2, \rel, 1, \freq, freq, \fuzz, 10]);
			dur.wait;
		};
	}).play;
};

x.stop; x = Routine({
	var scale = Scale.minor.tuning_(\just);
	fork {
		loop {
			Synth(\tik);
			(1/8).wait;
		};
	};
	fork {
		var freq = 40;
		loop {
			var degrees = (-12..12).scramble[0..5];
			Synth(\plinks, [\freqs, scale.degreeToFreq(degrees, freq, 5), \dur, 8]);
			Synth(\sawz, [\freqs, scale.degreeToFreq(degrees[0..3], freq, 4), \dur, 8, \start, 20, \end, 1]);

			degrees.do {|deg|
			Synth(\sprinkle, [\dur, 8, \freq, scale.degreeToFreq(deg, freq, 5)]);
			};

			Synth(\arp, [\dur, 8, \freqs, scale.degreeToFreq(degrees, freq, 3), \div, [2, 3, 4, 6, 8].choose, \atkRel, 1.0.rand]);
			kickLoop.(scale, freq);
			Synth(\crackle, [\dur, 8]);
			Synth(\k, [\freq, freq, \fuzz, 10]);
			freq = freq + 1;
			8.wait;
		}
	};
}).play
)

[{1.postln}, {2.postln}, {3.postln}].choose.()
x = Pconst(8, Prand([1, 1/2, 2, 1/4], inf)).asStream.do{|i| i.postln};
x.next.isNil.not
