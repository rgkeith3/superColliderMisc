(
SynthDef(\aKick, {
	arg out=0, freq=100, atk=0.01, rel=0.1, pitchRel=0.1, pitchBend=1, crush=0, pan=0;
	var env = EnvGen.ar(Env(times: [atk, rel]), doneAction: 2);
	var pitchEnv = EnvGen.ar(Env.perc(attackTime: atk, releaseTime: pitchRel), levelScale: pitchBend);
	var sig = SinOsc.ar(freq) + SinOsc.ar(freq * pitchEnv) * env;
	var crushedSig = CrossoverDistortion.ar(sig, crush);
	var pannedSig = PanAz.ar(2, crushedSig, pan);
	Out.ar(out, pannedSig);
}).add
)
(
Synth(\aKick, [
	\freq, 50,
	\atk, 0,
	\rel, 0.5,
	\crush, 0.1,
	\pan, 1.0.rand2,
	\pitchBend, -1,
	\pitchRel, 0.1
])
)

s.boot;

(
Pdef(\kicks,
	Pbind(
		\instrument, \aKick,
		\dur, Pseq([0.5, 0.5, 0.5, 0.1, 0.4 ], inf),
		\atk, 0,
		\rel, Pkey(\dur) / 2,
		\pan, 0,
		\freq, 75,
		\pitchBend, 7,
		\pitchRel, 0.05,
		\crush, 0.01,
	);
).play
)

(
SynthDef(\phat, {
	arg out=0, atk=0.01, rel=0.01, hold=0.3, amp=0.5, freq=50;
	var sig, env;
	env = EnvGen.ar(Env([0, 1, 1, 0], [atk, hold, rel]), doneAction: 2);
	sig = SinOsc.ar(freq) * env * amp;
	Out.ar(out, sig!2);
}).add
)

(
Pdef(\bass,
	Pbind(
		\instrument, \phat,
		\dur, 1/6,
		\hold, Pkey(\dur) * 0.75,
		\freq, Pseq([Pseq([50], 24), Pseq([40], 24)], inf),
		\amp, 1,
		\atk, 0,
		\rel, 0
	)
).play
)
s.quit;
s.scope