(
SynthDef(\sine, {
	|clock=1.0, beats=1, freq=440|
	var env, sig, dur;
	dur = clock.reciprocal * beats;
	env = EnvGen.ar(Env([0, 1, 1, 0], [0, dur, 0]),doneAction: 2);

	sig = SinOsc.ar(freq) * env;
	Out.ar(0, sig!2);
}).add
)

t.tempo.reciprocal

(
Pdef(\test,
	Pbind(
		\instrument, \sine,
		\clock, t.tempo,
		\delta, Pseq([2/3, 2/3, 1/3, 2/3, 1/3, 2/3, 2/3], inf),
		\beats, Pkey(\delta),
		\freq, 50
	)
).play(quant: 4)
)

Pdef.removeAll
