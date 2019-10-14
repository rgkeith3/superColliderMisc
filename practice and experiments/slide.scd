(
SynthDef(\sine, {
	arg freq;
	Out.ar(0,
		Pan2.ar(
			SinOsc.ar(freq) * EnvGen.ar(
				Env(),
				levelScale: 0.1,
				doneAction: 2
			)
		)
	);
}).add
)

Pslide(#[1, 2, 3, 4, 5, 6, 7, 8], 10, 3, 1, 0, false).asStream.all;

// or, to show the segments as separate arrays
Pslide(#[1, 2, 3, 4, 5, 6, 7, 8], 10, 3, 1, 0, false).clump(3).asStream.all;

// Flock of Seagulls!
(
p = Pbind(
	\instrument, \sine,
    \degree, Pslide((-6, -4 .. 12), 8, 3, 1, 0),
    \dur, 0.1,
    \sustain, 0.15
).play;
)

s.boot;
s.quit