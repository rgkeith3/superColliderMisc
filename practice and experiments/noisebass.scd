s.boot

(
x = {
	|gate=1|
	var pitchEnv, env, sig;
	env = EnvGen.ar(Env.adsr(), gate, doneAction: 2);
	pitchEnv = EnvGen.ar(Env.perc(0, 0.1, 1000), levelBias: 50);

	sig = HenonN.ar(pitchEnv) * env;
	sig!2
}.play
)


(
SynthDef(\noiseBass, {
	|gate=1, atk=0.01, dec=0.1, sus=0.8, rel=0.1, pitchDec=0.1, pitchPeak=1, freq=440|
	var pitchEnv, env, sig;
	env = EnvGen.ar(Env.adsr(atk, dec, sus, rel), gate, doneAction: 2);
	pitchEnv = EnvGen.ar(Env.perc(0, pitchDec, 1000* pitchPeak), levelBias: freq);

	sig = QuadN.ar(pitchEnv);
	sig = Ringz.ar(sig, freq * 5, 0.1)* env;
	Out.ar(0, sig!2)
}).add
)

(
Pbindef(
	\noiseBass,
	\instrument, \noiseBass,
	\dur, Pseq([1/3,2/3, 3, 1/3, 2/3, 2, 1/3, 2/3], inf),
	\stretch, 0.25,
	\pitchPeak, 1,
	\pitchDec, 0.05,
	\sus, 0.3,
	\legato, 1,
	\octave, 3,
	\degree, Prand([1,5,7], inf).trace
).play
)


(
x = {
	var sig = [];
	5.do {
		sig = sig.add(HenonN)
	}
}
)

StageLimiter.activate