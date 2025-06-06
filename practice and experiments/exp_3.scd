s.options.numWireBufs_(1024)

s.options.sampleRate_(48000)
s.options.memSize_(65536 * 4)
s.options.blockSize_(64)
s.options.numInputBusChannels_(0)
s.reboot


ProxySpace.push


~a = {LFDNoise3.kr(1).linexp(-1, 1, 500, 10000)}

{LFDNoise3.ar(LFDNoise3.ar(LFNoise2.ar(1).linexp(-1, 1, 0.01, 100)).linexp(-1, 1, 0.01, 100))}.scope

(
SynthDef(\three, {
	var sig, env = Env.adsr(\atk.kr(0.01), \dec.kr(0.1), \sus.kr(0.5), \rel.kr(0.1)).ar(2, \gate.kr(1));
	sig = Saw.ar(\freq.kr(440, \glide.kr(0.1)));
	sig = RLPF.ar(sig, \filt_freq.kr(880) + (\filt_freq.kr(880) * (env * \filt_env.kr(0.5))), \q.kr(0.5), 1 + \dist.kr(0)).distort;
	sig = sig * env * \db.kr(0).dbamp;
	sig = Pan2.ar(sig, \pan.kr(0));
	Out.ar(\out.kr(0), sig);
}).load;
)

(
SynthDef(\pad, {
	var sig, env = Env.asr(\atk.kr(0.1), releaseTime: \rel.kr(0.1)).ar(0, \gate.kr(1));
	sig = Resonz.ar(LPF.ar(WhiteNoise.ar, env * \filt_freq.kr(880)) * env, TScramble.kr(Array.series(8, 1) * \freq.kr(440, \glide.kr(0.1))), TScramble.kr(Array.geom(8, 0.1, 0.5)) * env.linlin(0, 1, 2, 1));
	sig = Splay.ar(sig);
	DetectSilence.ar(sig, doneAction: 2);
	Out.ar(\out.kr(0), sig);
}).load;
)

~d = Pbind(\instrument, \pad, \degree, [0, 2,4, 5], \dur, Pseq([1, 1, 1/3, 1, 2/3], inf) / 4, \rel, 0, \atk, 0, \mtranspose, Pdup(5, Prand((0..6), inf)), \octave, 3, \scale, Scale.minor)
~d.play
~b.play

(x.free; x = {
	var env = Env.asr(\atk.kr(0.1), releaseTime: \rel.kr(0.1)).ar(2, gate: \gate.kr(1));
	Resonz.ar(LPF.ar(WhiteNoise.ar, env * \filt_freq.kr(880), env), Array.series(8, 1) * \, Array.geom(8, 0.1, 0.5).postln);
}.play)
x.set(\filt_freq, 10000)
x.set(\rel, 2)
x.set(\gate, 0)


~b[0] = PmonoArtic(\three, \instrument, \three, \dur, 1/8, \legato, Pseq(Array.fill(16, {if (0.8.coin, {0.5}, {1})}), inf), \degree, Pseq(Array.fill(32, {(-6..6).wchoose(((-6..6) + 7).normalizeSum.scramble)}), inf), \octave, Pseq(Array.fill(16, {(3..4).choose}), inf), \mtranspose, Pdup(32, Prand((0..4), inf)), \scale, Scale.minor, \filt_freq, Pdefn(\filt_freq, 5000), \q, 0.1, \dist, 0, \pan, Pbrown(-1), \filt_env, Pdefn(\filt_env, 0), \db, 0, \atk, Pdefn(\atk, Pbrown(hi: 0.3)), \sus, 0.5, \rel, Pdefn(\rel))
~b[2] = \filterIn -> {|in| CombN.ar(in, 0.5, 1/4, decaytime: SinOsc.kr(1/4, [0, pi]).range(0, 2))}

Pdefn(\filt_freq, ~a)
Pdefn(\rel, 0.5)
Pdefn(\atk, 0)
Pdefn(\filt_env, 2)
~b[1] = \filter -> {|in| in + DelayC.ar(in, delaytime: LFNoise1.kr(1!2).linexp(-1, 1, 0.01, 0.0001))}
~a.bus.getSynchronous
~b[1] = nil;
~b[2] = nil;
~b.set(\wet3, ~b.get(\wet2));
~b.set(\wet2, 1);
~b[3] = \filterIn -> {|in| FreeVerb.ar(in, 1, 1, 1)}

~b.set(\wet1, 0, \wet2, 0, \wet3, 0)

(0..2) ++ [\]
~b[2] = \filterIn -> {|in| Splay.ar(CombN.ar(in, delaytime: Scale.minor.degreeToFreq((-3..7).scramble[0..3], 440, -1).reciprocal, decaytime: 1))}
~b.clear
~b.set(\wet2, 0.2)
~b.set(\wet3, ~c)
~b.set(\wet2, 0.2)
~b.set(\wet1, 1)

(
x.free; x = {
	var freq = Rand(50, 500), sig = SinOsc.ar(freq + SinOsc.ar(freq * 1.75, mul: Env(Array.exprand(10, 1, 10000), Array.rand(9, 1, 100).normalizeSum).ar));
	sig = sig * Env(times: Rand(0!2).normalizeSum, curve: Rand(-4, 4)).ar;
	sig = Pan2.ar(sig, Env(Rand(-1!2), 1, Rand(-4, 4)).ar);
	sig = FreeVerb2.ar(sig[0], sig[1]);
	DetectSilence.ar(sig, doneAction: 2);
	sig;
}.play
)


(
x.free; x = {
	var freq, sig, iRatios, iRatiosScale, pRatios, n;
	n = 4;
	freq = 250;
	iRatios = Array.fill(n, {(0.5, 0.75..2).choose});
	iRatiosScale = Array.rand(n, 0, 10);
	pRatios = Array.fill(n, {(0.5, 0.75..4).choose});
	sig = 0;
	n.do {|i|
		var env = Env(
			[iRatios[i], iRatios[i] * iRatiosScale[i], iRatios[i]],
			Rand(1, 2.0!2).normalizeSum,
			Rand(-4, 4!2)
		).ar;
		sig = SinOsc.ar(freq * pRatios[i] + sig, mul: freq * iRatios[i] * env);
	};

	sig = SinOsc.ar(freq + sig) * Env(times: Rand(1, 2.0!2).normalizeSum, curve: Rand(-4, 4!2)).ar
}.play
)


(x.free; x = {
	var mod, pow = MouseY.kr(1/4, 4, 1), mul = MouseX.kr, sig = Saw.ar(150);
	mod = LFNoise2.ar(1);
	4.do {
		mod = LFDNoise3.ar(mod.pow(pow).linexp(-1, 1, 0.1, 50), LFNoise2.kr(1, mul * 2), LFNoise2.kr(1, mul * 2)).fold(-1, 1);
	};
	sig = RLPF.ar(sig, mod.pow(pow).linexp(-1, 1, 50, 10000), 0.1, LFNoise1.kr(1).range(1, 10)).distort;
	FreeVerb.ar(sig);
}.play)


~b[0] = \set -> Pbind(\dur, 1, \dist, Pwhite(0, 10))

~c = {SinOsc.kr(1).bi2uni}
~c.fadeTime_(10)
~c = \setbus -> Pbind(\dur, 4, \value, Pseq([1, 0], inf))
~c = \set -> Pbind(\

~d = {LFNoise1.kr(1!2).bi2uni}
~b.play

~b[2] = \filter -> {|in| in * Env([1, 0, 1, 0, 0,1, 1, 0], [1, 0, 1, 1, 0, 1, 1], 4).circle.ar(timeScale: 1/5/4)}
~b[2] = nil

// psuedo ugen for trancegates that has a few presets and pre-divides the time scale


~b.play

~b.set(\wet1, 0, \wet2, 0, \wet3, 0)


	Array.fill(16, {(-6..6).choose})

