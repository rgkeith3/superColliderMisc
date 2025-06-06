s.options.sampleRate_(44100)

s.options.memSize_(8192 * 4)

s.boot

(
SynthDef(\p, {
	var freq = Env([\freq.kr(440) * \bend.kr(0).linexp(-1, 1, 0.5, 2), \freq.kr(440)], [\pDec.kr(0.01)], -4,).ar(0, 1);
	var sig = Pluck.ar(
		SinOsc.ar(\exc_freq.kr(500)),
		1,
		(\freq.kr(440) * 0.5).reciprocal,
		freq.reciprocal,
		\dec.kr(1),
		\timbre.kr(0.5);
	);
	DetectSilence.ar(sig, doneAction: 2);
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.8));
	Out.ar(\out.kr(0), sig);
}).add;
)

p = ProxySpace.push(s)
p.makeTempoClock

Pdefn(\scale, Scale.phrygian.tuning_(\just))

~a[0] = Pbind(\instrument, \p, \degree, Pdefn(\deg), \dur, 1/2, \strum, 0.01, \dec, Pwrand([1, 5, 10], [9, 2, 1].normalizeSum, inf), \octave, 5, \pDec, 0.05, \bend, Pwhite(-0.5, 0.5), \timbre, Pbrown(0, 0.5), \pan, Pwhite(-1), \scale, Pdefn(\scale))
~a.play
(
~a[10] = \filterIn -> {|in|
	var fb1, fb2, fb3, fb4,del1, del2, del3, del4, beatTime;
	beatTime = ~tempo.asBus.getSynchronous.reciprocal;

	fb1 = FbNode(2, 4 * beatTime, 0);
	fb2 = FbNode(2, 4 * beatTime, 0);
	fb3 = FbNode(2, 4 * beatTime, 0);
	fb4 = FbNode(2, 4 * beatTime, 0);

	del1 = fb1.delay(1/4 * beatTime).distort;

	del2 = fb2.delay(1/32 * beatTime).distort;

	del3 = fb3.delay(LFNoise2.ar(1).range(0, 1) * beatTime).distort;

	del4= fb4.delay(LFNoise2.ar(1).exprange(50, 5000).reciprocal).distort;

	fb1.write(del4 + in * LFNoise1.ar(1).range(0.8, 1.2));

	fb2.write(del1 * LFNoise1.ar(1).range(0.8, 1.2));

	fb3.write(del2 * LFNoise1.ar(1).range(0.8, 1.2));

	fb4.write(del3 * LFNoise1.ar(1).range(0.8, 1.2));

	HPF.ar(LPF.ar([del1 + del2 + del3 + del4].sum, 10000), 20) + in;
};
)

~a.play