s.boot;
s.meter;

// making some drum sounds

//kick
(
SynthDef(\crunchKick, {
	arg crunch=0.01,
	rel=0.5,
	freq=50,
	tone=2;
	var sig;
	sig = WhiteNoise.ar(EnvGen.ar(Env.perc(releaseTime: crunch)));
	EnvGen.ar(Env([1, 0], [rel]), doneAction: 2);
	sig = Ringz.ar(sig, freq, decaytime: rel);
	sig = RLPF.ar(sig, freq * (tone * tone), tone.reciprocal, mul: 0.5);
	sig = Limiter.ar(sig, 1);
	Out.ar(0, sig);
}
).add
)


(
p = Pbind(
	\instrument, \crunchKick,
	\dur, Pwrand([0.2, Pseq([0.2/3], 3)], [0.9, 0.1], inf),
	\rel, 0.1,
	\freq, 50,
	\crunch, 0.5,
	\tone, 1
).play
)
// things I would do differently:
// need to work on limiter or something, to get it crunchy but not blow your ears out
// also would like to make a kick that is multi channel, that can be spread or panned.
