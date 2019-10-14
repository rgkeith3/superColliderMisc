// TODO:
// make some window envs for the grainenv in warp

// beat slicing via routine
// 1. specify beat length, make it stretch the sample to play same speed across that length of time
// 2. play only a slice of the beat

(
SynthDef(\slice, {
	arg bufnum, clock=1, beatStretch=1, sliceSize=1, start=0, windowSize=0.001, pitchRatio=1;
	var dur, sig;
	dur = (beatStretch / clock) * sliceSize;
	sig = Warp1.ar(2, bufnum, Line.ar(start, start + sliceSize, dur, doneAction: 2), freqScale: pitchRatio,windowSize: windowSize, overlaps: 8, windowRandRatio: 0);
	Out.ar(0, sig);
}).add
)


(
Pbindef(\slices,
	\instrument, \slice,
	\delta, 1/32,
	\bufnum, ~break,
	\clock, TempoClock.default.tempo,
	\beatStretch, 2,
	\sliceSize, Pkey(\delta),
	\start, Prand([Pseg([0, 1], Pkey(\beatStretch),repeats: inf), 0], inf)
).play
)

~beatStretch = 8;
~sliceSize = 1/128;
~prob = 0.8;
~beatRepeat = 1/16;
~pitchRatio = 1;
~windowSize = 0.001;

TempoClock.default.tempo_(140/60)

TempoClock.default.tempo_(2)
(
Tdef(\beatslicer, {
	var playHead=0;
	var sliceStart=0;
	var hold = false;
	loop {
		if (mod(playHead, ~beatRepeat) == 0, {hold = false;});
		if (mod(playHead, ~beatRepeat) == 0 && ~prob.coin, {hold = true});
		hold.postln;
		Synth(\slice, [
			\bufnum, ~break,
			\clock, TempoClock.default.tempo,
			\beatStretch, ~beatStretch,
			\sliceSize, ~sliceSize,
			\start, sliceStart,
			\pitchRatio, ~pitchRatio,
			\windowSize, ~windowSize,
		]);
		playHead = playHead + ~sliceSize;
		if (hold, {}, {sliceStart = playHead});
		(~beatStretch * ~sliceSize).yield;
	};
}).play
)

Tdef.clear


mod(0.75, 0.25) == 0
Tdef.clear

Synth(\slice, [\bufnum, ~break, \clock, 1, \beatStretch, 4, \sliceSize, 1, \start, 0])
0.rrand(1)
0.5.coin