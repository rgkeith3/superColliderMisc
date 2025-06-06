s.boot


({
	var lfact = 0.001, hfact=100, chaos = LFDNoise3.ar(LFDNoise3.ar(LFNoise2.ar(1).linexp(-1, 1, lfact, hfact)).linexp(-1, 1, lfact, hfact)!2, LFDNoise3.ar(LFNoise2.ar(1).linexp(-1, 1, lfact, hfact)).linexp(-1, 1, lfact, hfact)!2).pow(LFDNoise3.ar(LFNoise2.ar(1).linexp(-1, 1, lfact, 10)).linexp(-1, 1, 0.1, 10)).wrap(-1, 1);
	chaos;
}.play)


(SynthDef(\wildSaw, {|freq=440, gate=1, out=0, pow=4|
	var n=4, env, sig = LFDNoise3.ar(LocalIn.ar(n).linexp(-1, 1, 0.01, 100), LFNoise1.kr(1).linexp(-1, 1, 0.1, 2)).wrap(-1, 1);
	env = Env.asr(1).ar(2, gate);
	sig = sig * env;
	LocalOut.ar(sig[1..n-1] ++ sig[0]);
	Out.ar(out, Splay.ar(SinOscFB.ar(sig.pow(pow).linexp(-1, 1, 1/8, 8) * freq, LFNoise2.kr(0.5.dup(n)).linexp(-1, 1, 0.1, 2), mul: 1/n), level: env));
}).load)


{var env = Env.perc(0.1).ar(2); SinOscFB.ar(250, env * 1.5, env)}.play



x = (instrument: \wildSaw, degree: [0,2,4,6], dur: 4).play

Pbindef(\wildSaw, \instrument, \wildSaw, \degree, Pfunc({ (-6..6).scramble[0..3]}), \dur, 8, \pow, 4, \octave, 5, \legato, 1, \scale, Scale.major.tuning_(\just)).play

y.free; y = {ReplaceOut.ar(0, FreeVerb.ar(In.ar(0, 2), LFNoise1.kr(0.5!2).linexp(-1, 1, 0.1, 1), 1, LFNoise1.kr(0.5!2).linexp(-1, 1, 0.1, 1)))}.play

({
	var sig = Saw.ar(240 * [1, 2, 3, 4, 1.5, 2/3, 3/4, 3/2, 5/4]);
	sig = sig.sum.distort;
	20.do {
		// var mod = LFNoise2.kr(0.5).linexp(-1, 1, 0.01, 50);
		var mod = 1;
		sig = sig + Pan2.ar(Resonz.ar(sig, LFDNoise3.kr(mod).linexp(-1, 1, 20, 20000), LFDNoise1.kr(mod).linexp(-1, 1, 0.01, 0.0001)), LFDNoise1.kr(mod));
	};
	FreeVerb.ar(sig);
}.play)

(
a = [1,2,3, 4];
a[1..3] ++ a[0]
)

s.scope
s.dumpOSC(0)

	