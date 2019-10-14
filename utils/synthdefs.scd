// SynthDefs

// buffer players
(
// oneshots
var oneShot = {|buf, rate=1, start=0, atk=0, hold=1, rel=0, amp=1|
	var env, bufDur;
	bufDur = BufDur.kr(buf) * rate.reciprocal;
	env = EnvGen.ar(Env([0, 1, 1, 0],[atk * bufDur, hold * bufDur, rel* bufDur]), doneAction: 2);
	PlayBuf.ar(1, buf, BufRateScale.kr(buf) * rate, startPos: start * BufSamples.kr(buf), doneAction: 2) * env * amp;
};

SynthDef(\monoOneShot, {|out=0|
	var sig = SynthDef.wrap(oneShot);
	Out.ar(out, sig);
}).add;

SynthDef(\sterOneShot, {|out=0, pan=0|
	var sig = SynthDef.wrap(oneShot);
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).add;

SynthDef(\quadOneShot, {|out=0, panX=0, panY=0|
	var sig = SynthDef.wrap(oneShot);
	sig = Pan4.ar(sig, panX, panY);
	Out.ar(out, sig);
}).add;

SynthDef(\quadAZOneShot, {|out=0, pos=0|
	var sig = SynthDef.wrap(oneShot);
	# w, x, y, z = PanAz.ar(4, sig);
	Out.ar(0, [w, x, z, y])
}).add;
)

(
// granular buffer synths

// define grain window envs here
// not really sure why this isn't working
// maybe refactor this into different 'mono', 'ster', 'quad' versions

SynthDef(\granOneShot, {|buf, rate=1, grainRate=1, grainSize=1, densStart=1, densEnd=1, trigChaos=1, grainEnvBuf=(-1), spread=0, pan=0, atk=0, hold=1, rel=0, amp=1, out = 0|
	var playLine, densLine, trig, sig, bufDur, panSig, env;
	panSig = WhiteNoise.kr(spread, pan);
	bufDur = BufDur.kr(buf) * rate.reciprocal;
	env = EnvGen.ar(Env([0, 1, 1, 0], [atk * bufDur, hold * bufDur, rel * bufDur]), doneAction: 2);
	playLine = Line.kr(dur: bufDur);
	densLine = Line.kr(densStart, densEnd, bufDur);
	trig = GaussTrig.kr(densLine, trigChaos);
	# w, x, y, z = GrainBuf.ar(4, trig, grainSize * bufDur, buf, grainRate, playLine,pan: panSig, envbufnum: grainEnvBuf) * env * amp;
	Out.ar(out, [w, x, z, y]);
}).add;
)

(
SynthDef(\warpBufPlay, {|buf, tempo=1, beats=1, pitchRatio=1, windowSize-0.2, windowRand=0, overlaps=8, envBuf=-1|
	// write the warp buffer player for bufs.
	//
})
)


(
Pbindef(\test,
	\instrument, \quadOneShot,
	\delta, Pseq([1/3, 1/3, 1/3, 2/3, 2/3, 1/3, 1/6, 1/6], inf) * 0.5,
	\buf, ~samples[\Drums][\Kicks][8],
	\rate, 1,
	\start, 0,
	\atk, 0,
	\hold, 1,
	\rel, 0,
	\amp, 0.1,
	\panX, 0,
	\panY, 0
).play
)

(
Pbindef(\testSnare,
	\instrument, \quadOneShot,
	\delta, Pseq([2/3, Pwrand([4/3, Pseq(2/3!2, 2)], [0.8, 0.2])], inf),
	\buf, ~samples[\Drums][\Snares][2],
	\rate, Pwrand([1, 0.7], [0.8, 0.2], inf),
	\start, 0,
	\atk, 0,
	\hold, 1,
	\rel, 0,
	\amp, 0.4,
	\panX, Pwhite(-1.0, 1),
	\panY, Pwhite(-1.0, 1)
).play
)

(
Pbindef(\testhat,
	\instrument, \quadOneShot,
	\delta, 1/6,
	\buf, Prand(~samples[\Drums]['Closed Hihat'], inf),
	\rate, Pwrand([1, 0.7], [0.8, 0.2], inf),
	\start, 0,
	\atk, 0,
	\hold, 1,
	\rel, 0,
	\amp, 0.4,
	\panX, Pwhite(-1.0, 1),
	\panY, Pwhite(-1.0, 1)
).play
)

(
Pbindef(\testsynth,
	\instrument, \quadOneShot,
	\delta, 1/3,
	\buf, Pseq([Pseq([~samples[\Synths][3]], 32),Pseq([~samples[\Synths][8]], 32)], inf),
	\rate, Pseq((0.5!24) ++ (0.7!8), inf),
	\start, 0,
	\atk, 0,
	\hold, 1,
	\rel, 0.1,
	\amp, 0.1,
	\panX, Pseq([-1, 1, -1], inf),
	\panY, Pseq([0, -1, 0, 1], inf)
).stop
)

