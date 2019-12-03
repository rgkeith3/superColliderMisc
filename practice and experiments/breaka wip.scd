(
{
	var clock, beatStretch, buf, bufDur, pointer, beatStart, beatLength;
	buf = ~samples[\breaks][7];
	clock = 1;
	beatStretch = 4;
	beatStart = 0/4;
	beatLength = 4/4;

	pointer = Line.ar(beatStart, beatStart + beatLength, beatStretch * beatLength, doneAction: 2);
	Warp1.ar(1, buf, pointer, windowSize: 0.01);
}.play
)


(
var slicePlay = {
	|clock=1, beatStretch=4, buf, beatStart=0, beatDiv=16, pitchRatio=1, windowSize=0.1, overlaps=4, amp=1, atk=0, hold=1, rel=0|
	var fullLength, beatEnd, pointer, sliceSize, env;
	fullLength = clock.reciprocal * beatStretch;
	sliceSize = fullLength / beatDiv;
	beatEnd = beatStart + (1/ beatDiv);
	env = EnvGen.ar(Env([0, 1, 1, 0], [atk * sliceSize, hold * sliceSize, rel * sliceSize]), doneAction: 2);
	pointer = Line.ar(beatStart, beatEnd, sliceSize, doneAction: 2);
	Warp1.ar(1, buf, pointer, pitchRatio, windowSize, overlaps: overlaps) * env * amp;
};

SynthDef(\monoSlicePlay, {|out=0|
	var sig;
	sig = SynthDef.wrap(slicePlay);
	Out.ar(out, sig);
}).add;

SynthDef(\sterSlicePlay, {|out=0, panX=0|
	var sig;
	sig = SynthDef.wrap(slicePlay);
	Out.ar(out, Pan2.ar(sig, panX));
}).add;

SynthDef(\quadSlicePlay, {|out=0, panX=0, panY=0|
	var sig;
	sig = SynthDef.wrap(slicePlay);
	Out.ar(out, Pan4.ar(sig, panX, panY));
}).add;

SynthDef(\quadAzSlicePlay, {|out=0, panX=0, panY=0|
	var sig;
	sig = SynthDef.wrap(slicePlay);
	Out.ar(out, PanAz.ar(4, sig, panX, width: panY));
}).add;
)


(
~setTempo = {
	|bpm|
	var tempo = bpm / 60;
	Pdefn(\tempo, tempo);
	TempoClock.default.tempo_(tempo);
}
)
~setTempo.value(120)

(
Pbindef(\slices,
	\instrument, \sterSlicePlay,
	\buf, ~samples[\breaks][7],
	\beatDiv, 16,
	\beatStretch, 8,
	\dur, (Pdefn(\tempo).reciprocal/Pkey(\beatDiv)) * Pkey(\beatStretch),
	\clock, Pdefn(\tempo),
	\beatStart, Pseq((0..31), inf) / 16,
	\panX, Pwhite(-0.5, 0.5),
	\amp, 1,
	\atk, 0.5,
	\hold, 0,
	\rel, 0.5,
	\pitchRatio, 0.5,
	\windowSize, 0.001,
	\overlaps, 4
).play
)

Pbindef.clear
(1..16)
2.reciprocal / 16
