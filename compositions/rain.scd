(
SynthDef(\plucky, {
		arg out=0, freq=440, rel=1, timbre=0.5, pan=0, pan_width=2, amp=1;
		var sig;
		sig = Pluck.ar(
			WhiteNoise.ar(amp),
			maxdelaytime: freq.reciprocal,
			delaytime: freq.reciprocal,
			decaytime: rel,
			coef: timbre
		);
		DetectSilence.ar(sig, doneAction: 2);
		sig = PanAz.ar(2, sig, pan, width: pan_width);
		Out.ar(out, sig);
	}).add;
)

(
Pdef(\pluck_rain,
	Pbind(
		\instrument, \plucky,
		\dur, Pwhite(hi: 0.1),
		\amp, Pwhite(0.001, 0.1),
		\out, Prand([~bus[\reverb][0].index], inf),
		\degree, Prand([1, 3, 5, 7, 11], inf),
		\octave, Prand([3, 4, 5, 6, 7], inf),
		\timbre, Pwhite(0.1, 0.5),
		\rel, Pwhite(1.0, 7.0),
		\pan, Pseg([0, 2], 24, repeats: inf),
		\pan_width, Pseg([2, 4, 2], 56, repeats: inf)
	)
).play
)

(
Pdef(\verbs,
	Pbind(
		\type, \set,
		\id, ~reverbGroup.nodeID,
		\args, [\room, \damp],
		\dur, 0.1,
		\room, Pseg([0, 1, 0], 62, repeats: inf),
		\damp, Pseg([1, 0, 1], 42, repeats: inf)
	)
).play
)

