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

SynthDef(\sterOneShot, {|out=0, panX=0|
	var sig = SynthDef.wrap(oneShot);
	sig = Pan2.ar(sig, panX);
	Out.ar(out, sig);
}).add;

SynthDef(\quadOneShot, {|out=0, panX=0, panY=0|
	var sig = SynthDef.wrap(oneShot);
	sig = Pan4.ar(sig, panX, panY);
	Out.ar(out, sig);
}).add;

SynthDef(\quadAZOneShot, {|out=0, panX=1, panY=1|
	var sig = SynthDef.wrap(oneShot);
	# w, x, y, z = PanAz.ar(4, sig, panX, width: panY);
	Out.ar(0, [w, x, z, y])
}).add;
)

(
// granular buffer synths

// define grain window envs here
// not really sure why this isn't working
// it wasn't working because buffers for grain buffers must be mono
// maybe refactor this into different 'mono', 'ster', 'quad' versions

SynthDef(\granOneShot, {|buf, grainRate=1, grainSize=1, densStart=1, densEnd=1, trigChaos=1, grainEnvBuf=(-1), spread=0, panX=0, atk=0, hold=1, rel=0, amp=1, out = 0|
	var playLine, densLine, trig, sig, bufDur, panSig, env;
	panSig = WhiteNoise.kr(spread, panX);
	bufDur = BufDur.kr(buf) + (BufDur.kr(buf) * grainSize);
	env = EnvGen.ar(Env([0, 1, 1, 0], [atk * bufDur, hold * bufDur, rel * bufDur]), doneAction: 2);
	densLine = Line.kr(densStart, densEnd, bufDur);
	trig = GaussTrig.kr(densLine, trigChaos);
	# w, x, y, z = GrainBuf.ar(4, trig, grainSize * bufDur, buf, grainRate, 0,pan: panSig, envbufnum: grainEnvBuf) * env * amp;
	Out.ar(out, [w, x, z, y]);
}).add;
)

(

var envWarpBuf = {|buf, clock=1, beatStretch=1, gate=1, atk=0, decay=0, sus=1, rel=0, amp=1, pitchRatio=1, windowSize=0.2, windowRand=0, overlaps=8, envBuf=(-1)|
	var env, pointer, beatDur, playRate;
	beatDur = clock.reciprocal / beatStretch;
	env = EnvGen.ar(Env.adsr(atk * beatDur, decay* beatDur, sus, rel * beatDur), gate, doneAction: 2) * amp;
	pointer = Line.ar(dur: beatDur);
	Warp1.ar(1, buf, pointer, pitchRatio, windowSize, envBuf, overlaps, windowRand, 2) * env;
};

SynthDef(\monoBeatBufPlay, {|out=0|
	var sig = SynthDef.wrap(envWarpBuf);
	Out.ar(0, sig);
}).add;

SynthDef(\sterBeatBufPlay, {|out=0, panX=0|
	var sig = SynthDef.wrap(envWarpBuf);
	sig = Pan2.ar(sig, panX);
	Out.ar(0, sig);
}).add;

SynthDef(\quadBeatBufPlay, {|out=0, panX=0, panY=0|
	var sig = SynthDef.wrap(envWarpBuf);
	sig = Pan4.ar(sig, panX, panY);
	Out.ar(0, sig);
}).add;

SynthDef(\quadAzBeatBufPlay, {|out=0, panX=1, panY=1|
	var sig = SynthDef.wrap(envWarpBuf);
	sig = PanAz.ar(4, sig, panX, width: panY);
	Out.ar(0, sig);
}).add;
)

(
Pbindef(\sterBeatBufPlay,
	\instrument, \sterBeatBufPlay,
	\buf, ~samples[\breaks][7],
	\clock, 1,
	\delta, 4,
	\dur, 4,
	\legato, 1,
	\beatStretch, 4,
	\panX, Pwhite(-1.0, 1.0),
	\windowSize, 0.1,
	\overlaps, 4,
	\pitchRatio, 1,
)
)

~samples[\breaks][7].play

Pbindef(\sterBeatBufPlay).play

(
Pbindef(\sterBeatBufPlaySynths,
	\instrument, \sterBeatBufPlay,
	\buf, Pstutter(32, Prand(~samples[\Synths], inf)),
	\clock, Pdefn(\tempo),
	\delta, 4,
	\sustain, Pkey(\delta),
	\beats, 4,
	\amp, 0.3,
	\panX, Pwhite(-1.0, 1.0),
	\windowSize, 0.1,
	\overlaps, Prand([2,4,8,16], inf),
	\pitchRatio, 5
)
)

Pbindef(\sterBeatBufPlaySynths).play

(
var tempo = 160/60;
Pdefn(\tempo, tempo);
TempoClock.default.tempo_(tempo)
)



(
Pbindef(\testGranOneshot,
	\instrument, \granOneShot,
	\dur, 8,
	\buf, Prand([~samples[\Drums][\Snares][0]], inf),
	\amp, 0.4,
	\spread, 1,
	\grainRate, 1,
	\grainSize, 0.1,
	\densStart, 250,
	\atk, 0,
	\hold, 0,
	\rel, 1,
	\trigChaos, Pwhite()
)
)


(
Pbindef(\test,
	\instrument, \sterOneShot,
	\delta, Pseq([1/3, 2/3, 1, 1, 1], inf),
	\buf, ~samples[\Drums][\Kicks][7],
	\rate, 1,
	\start, 0,
	\atk, 0,
	\hold, 1,
	\rel, 0,
	\amp, 10,
	\panX, 0,
	\panY, 0
).play
)

StageLimiter.activate

(
Pbindef(\testSnare,
	\instrument, \sterOneShot,
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
	\instrument, \sterOneShot,
	\delta, 1/4,
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
	\instrument, \sterOneShot,
	\delta, 1/3,
	\buf, Pseq([Pseq([~samples[\Synths][5]], 32),Pseq([~samples[\Synths][8]], 32)], inf),
	\rate, Pseq((0.5!24) ++ (0.7!8), inf),
	\start, 0,
	\atk, 0,
	\hold, 0,
	\rel, 0.4,
	\amp, 0.3,
	\panX, Pseq([-1, 1, -1], inf),
	\panY, Pseq([0, -1, 0, 1], inf)
).play
)

Event.addEventType(\testPost, {~play.value})
Event.new()


