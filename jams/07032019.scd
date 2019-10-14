(
SynthDef(\noiseBass, {
	|freq=440, noise_mix=0, amp=1, atk=0.1, hold=1, rel=0.1, clock=1, pan=1|
	var sig, env, noise, atk_time, hold_time, rel_time;
	noise = PinkNoise.ar(amp / 2);
	sig = LFTri.ar(freq);
	atk_time = atk * clock.reciprocal;
	hold_time = hold * clock.reciprocal;
	rel_time = rel * clock.reciprocal;
	env = EnvGen.ar(Env([0, amp, amp, 0], [atk_time, hold_time, rel_time]), doneAction: 2);
	sig = XFade2.ar(sig, noise, noise_mix) * env;
	sig = PanAz.ar(4, sig, pan);
	Out.ar(0, sig);
}).add
)
t = TempoClock.new(60/60)
t.tempo = 140/60
(
Pdef(\beet,
	Pbind(
		\instrument, \noiseBass,
		\clock, t.tempo,
		\delta, Pseq([2/3, 2/3, 2/3, 1/3, 1, 2/3], inf),
		\degree, Pseq([
			Pseq([1, 5, [7, 9]], 4),
			Pseq([2, 4, [6, 11]], 4)
		], inf),
		\octave, Prand([3, [2, 4]], inf),
		\noise_mix, Pwrand([-1, 0], [0.9, 0.1], inf),
		\atk, 0.1,
		\hold, Pkey(\delta) * 0.8,
		\rel, 0.01,
		\amp, 0.2,
		\pan, Pseg([0, 2], 5, repeats: inf)
	)
).play(t)
)

(
Pdef(\tick,
	Pbind(
		\instrument, \noiseBass,
		\clock, t.tempo,
		\delta, 1/3,
		\degree, 7,
		\octave, 8,
		\atk, 0,
		\hold, 0,
		\rel, 0.01,
		\noise_mix, Pwhite(),
		\amp, 0.5,
		\pan, Pwhite(hi: 2.0)
	)
).play(t)
)

(
Pdef(\kik,
	Pbind(
		\instrument, \noiseBass,
		\clock, t.tempo,
		\delta, Pseq([1/3, 1/3, 1/3, 3, 2/3, 1/3, 3, 2/3, 2/3, 2/3, 1, 1, 1, 3], inf).trace,
		\degree, 5,
		\octave, 2,
		\atk, 0,
		\hold, 0,
		\rel, 0.2,
		\amp, 0.7,
		\noise_mix, -1,
		\pan, 1
	)
).play(t, quant: 4)
)

(
Pdef(\crash,
	Pbind(
		\instrument, \noiseBass,
		\clock, t.tempo,
		\delta, Pseq([2, 2, 2, 2, 2, 2, 2, 2/3, 2/3, 2/3,2], inf),
		\noise_mix, 1,
		\amp, 0.5,
		\pan, Pwhite(hi: 2.0)
	)
).play(t)
)

(
Pdef(\chords,
	Pbind(
		\instrument, \noiseBass,
		\clock, t.tempo,
		\delta, 1/6,
		\degree, Prand([1,5,7,9], inf),
		\octave, Prand([4, 5, 7, 8], inf),
		\hold, 2,
		\amp, 0.02,
		\atk, 2,
		\rel, 2,
		\pan, Pseg([0, 2], 8, repeats: inf)
	)
).play(t)
)

Pdef(\chords).stop