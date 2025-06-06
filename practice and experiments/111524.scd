
s.boot


(SynthDef(\wipe, {
var env = Env([0,1,0], [\atk.kr(0.5), 0]).ar(0, 1);
	var sig = WhiteNoise.ar * env;
	sig = CombN.ar(sig, delaytime: (\freq.kr(250) * [1, 1.5, 2/3]).reciprocal, decaytime: \dec.kr(1)).sum / 3 * \amp.kr(0.8);
sig = LPF.ar(sig, Env([0,1], \atk.kr(0.5)).ar(0, 1).linexp(0, 1, 50, 5000));
	DetectSilence.ar(sig, doneAction: 2);
	sig = Pan2.ar(sig, \pan.kr(0));
	Out.ar(\out.kr(0), sig);
}).load;

SynthDef(\air, {
	var sig = WhiteNoise.ar * Env.asr.ar(2, \gate.kr(1));
	sig = Resonz.ar(sig, \freq.kr(440), 0.01, 10);
	Out.ar(\out.kr(0), Pan2.ar(sig, \pan.kr(0)));
}).load;
)

Pbindef(\wipe, \instrument, \wipe, \dur, Prand([1, 1/4, 1/2, 1/8], inf), \atk, Pkey(\dur)*0.25, \dec, Pseg([0.1, 1, 0.1], 16, repeats: inf), \degree, Prand((0..7), inf), \scale, Scale.minorPentatonic, \pan, Pbrown(-1), \out, ~room)
Pbindef(\wipe).play;

~room = Bus.audio(s, 2);

// interesting
(x.free; x = {
	var sig = In.ar(~room, 2);
	sig = sig + Resonz.ar(sig, Array.exprand(20, 50, 5000), Array.exprand(20, 0.001, 0.1), 10) + FreeVerb2.ar(sig[0], sig[1], 1, 0.1, 1);
	Out.ar(0, sig);
}.play)


(Tdef(\wipe, {
	var airs = [], durs, chord, arp;
	loop {
		durs = [1].addAll(0.5.dup(2)).addAll(0.25.dup(4)).addAll(0.125.dup(8)).scramble;
		chord = Scale.minorPentatonic.degreeToFreq((0..7).scramble[0..3], 440, -1);
		airs.collect(_.set(\gate,0));
		airs = chord.collect{|freq| Synth(\air, [\freq, freq])};
		arp = Pseq(chord, inf).asStream;
		durs.do {|dur|
			Synth(\wipe, [\out, ~room, \atk, dur / 4, \freq, arp.next, \amp, 0.5]);
			dur.wait;
		};
		'next'.postln;
	};
}).play)

