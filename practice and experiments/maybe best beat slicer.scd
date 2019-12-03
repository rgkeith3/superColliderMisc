(
SynthDef(\slice, {
	|buf, beats, clock, start, gate=1, pan=0, amp=1|
	var beatDur, sig, pointer, env;
	beatDur = clock.reciprocal * beats;
	env = EnvGen.ar(Env.adsr(releaseTime: 0.01), gate, doneAction: 2);
	pointer = Line.ar(dur: beatDur, add: start, doneAction: 2);

	sig = BufRd.ar(1, buf, pointer * BufSamples.kr(buf)) * amp;
	sig = Compander.ar(sig, sig).clip(-1, 1);
	Out.ar(0, Pan2.ar(sig, pan));
}).add
)

(
Event.addEventType(\slice, {
	~instrument = \slice;
	~clock = ~clock ?? TempoClock.default.tempo;
	~legato = 1;
	~dur = ~beats / ~division;
	~start = currentEnvironment[~trakPlay] ?? ~start;

	~type = \note;
	currentEnvironment.play;
})
)


(
Pbindef(\slicer,
	\type, \slice,
	\buf, ~samples[\breaks][7],
	\beats, 4,
	\division, 32,
	\trakPlay, Pdefn(\trakPlay, \trak1),
	\trak1, Pseg([0, 1], Pkey(\beats), repeats: inf),
	\trak2, 0.125,
	\trak3, Pseq([1/2, 1/2, 1/2, 1/4, 3/4, 3/4, 1/3, 1/3, 1/3, 1/3, 2/3], inf),
	\trak4, Pwhite(0, Pkey(\division)) * 0.03125,
	\amp, 25,
	\pan, 0
)
)

~samples[\breaks][7].play




Pbindef(\slicer).play
Pbindef(\slicer, \division, 8)

Pdefn(\trakPlay, Pwrand([\trak1, \trak2, \trak3, \trak4], inf))

1/32

(type: \slice, buf: ~samples[\breaks][7], beats: 8, division: 16 ).play
(dur: 0.5).play

TempoClock.default.tempo_(140/60)

Pbindef.clear

20.reciprocal