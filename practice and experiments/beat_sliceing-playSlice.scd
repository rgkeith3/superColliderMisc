// beat slicing via patterns approach

~break = Buffer.read(s, "/Users/greykeith/superCollider/sounds/breaks/eric_moore_breaks_cuts_3.wav");
~break.bufnum
(
SynthDef(\playSlice, {
	arg out=0, bufnum=0, division=16, slicenum=0, ;
	var sig, startPos, sliceSize, sliceDur, endPos;
	sliceSize = BufFrames.ir(bufnum) / division;
	startPos = sliceSize * slicenum;
	startPos.postln;
	endPos = startPos + sliceSize;
	endPos.postln;
	sliceDur = sliceSize / SampleRate.ir;
	sig = BufRd.ar(
		numChannels: 2,
		bufnum: bufnum,
		phase: Line.ar(startPos, endPos, sliceDur, doneAction: 2),
		loop: 0
	);
	Out.ar(out, sig);
}).add
)

~chooseSlice
TempoClock.default.tempo_(1)
(
Pdef(\break,
	Pbind(
		\instrument, \playSlice,
		\bufnum, ~break.bufnum,
		\beatLength, 2,
		\division, 16,
		\delta, (Pkey(\beatLength) / Pkey(\division)),
		\hold, Pwrand([0, 1], [0.8, 0.2], inf),
		\scramble, Pwrand([0, 1], [0.8, 0.2], inf),
		\playHead, Pseg([0, 1], Pkey(\beatLength), repeats: inf),
		\slicenum, Pwrand([(Pkey(\playHead) * Pkey(\division)), Pstutter(4, Pwhite(hi: Pkey(\division) -1, repeats: 1))], [0.8, 0.2], inf)
	)
).play
)

// i think what i may want to do is a combination of this and 'messing with beatslicing' basically using '\set patterns, that send gates to lock beats or not
x.put(\hello, 1)
x.at(\hello)
(
SynthDef(\beatslice, {
	arg out=0, bufnum=0, beat_stretch=16, division=128, repitch=1, freeze=0, pitch_spread=0, time_spread=0, spray=0.2;
	var playRate,
	playhead,
	sig,
	click,
	sliceSize,
	startPos,
	endPos,
	tempoRate,
	beatDur,
	reset,
	slicePlayhead;

	beatDur = TempoClock.default.beatDur;
	tempoRate = beatDur.reciprocal;
	click = Impulse.ar((tempoRate / beat_stretch) * division);

	playRate = BufSamples.kr(bufnum) / (SampleRate.ir * (beat_stretch * beatDur));
	sliceSize = BufSamples.kr(bufnum) / division;

	playhead = Phasor.ar(0, playRate, 0, BufSamples.kr(bufnum));

	startPos = Gate.ar(Stepper.ar(click, max: division - 1) * sliceSize, (freeze - 1).neg);
	endPos = startPos + sliceSize;
	slicePlayhead = Phasor.ar(freeze, playRate, startPos, endPos, startPos);


	sig = BufRd.ar(
		numChannels: 2,
		bufnum: bufnum,
		phase: Select.ar(freeze, [playhead, slicePlayhead])
	);
	sig = PitchShift.ar(sig, windowSize: spray, pitchRatio: repitch, pitchDispersion: pitch_spread, timeDispersion: time_spread);
	Out.ar(out, sig);
}).add
)

x = Synth(\beatslice, [\bufnum, ~break.bufnum]);
x.free
(
Pdef(\breka,
	Pbind(
		\type, \set,
		\id, x.nodeID,
		\args, [\freeze, \division, \repitch, \beat_stretch, \pitch_spread, \time_spread, \spray],
		\freeze, Pxrand([0, Prand([0, 1])], inf),
		\division, 4 ** Prand([2, 3, 4, 5], inf),
		\beat_stretch, 5,
		\dur, TempoClock.default.tempo / (Pkey(\beat_stretch) * 2),
		\repitch, 3,
		\spray, 0.2,
		\pitch_spread, 0.01,
		\time_spread, 0.001,
		\out, 0
	)
).play
)
//^ this is good



b = Buffer.alloc(s,1024);
(
//trig with MouseY
SynthDef("help-magFreeze2", { arg out=0, bufnum=0, soundBufnum=2;
    var in, chain;
    in = PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum), loop: 1);
    chain = FFT(bufnum, in);
    // uncomment the line below to compare while ...
	// chain = PV_MagFreeze(chain, MouseY.kr > 0.5 );
    // commenting the line below
	chain = PV_Freeze(chain, MouseY.kr > 0.5 );
    Out.ar(out, 0.5 * IFFT(chain).dup);
}).play(s,[\out, 0, \bufnum, b.bufnum, \soundBufnum, ~break]);
)