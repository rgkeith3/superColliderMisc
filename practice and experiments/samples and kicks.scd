s.boot;
(
~uhhs = Array.new(7);
PathName("/Users/greykeith/superCollider/sounds/uhhs/")
.entries
.collect({ arg sf;
	b = Buffer.read(s, sf.fullPath);
	~uhhs.add(b);
})
)

(
SynthDef(\sampler, {
	arg bufnum=0,
	rate=1,
	rev_mix=0.5,
	rev_room=0.5,
	rev_damp=0.5,
	pan=0,
	out=0;
	var snd = PlayBuf.ar(2, bufnum, rate, doneAction: 2);
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
}).add
)


(
Pdef(\uhhs,
	Pbind(
		\instrument, \sampler,
		\bufnum, Pxrand(~uhhs.do({|el| el.bufnum}), inf),
		\dur, Pwrand([0.1, Pseq((0.1/3)!3)], [0.9, 0.1], inf),
		\rate, Pkey(\dur).reciprocal / 2,
		\pan, Pwhite(-1.0, 1.0),
	)
).play
)

~sizz = Buffer.readChannel(s, "/Users/greykeith/superCollider/sounds/kitchen/Audio Track-12.wav", channels: 0);
~sizz

(
{
	var sig = GrainBuf.ar(
		2,
		GaussTrig.ar(1000, MouseX.kr()),
		MouseY.kr(0.00001, 0.01),
		~sizz.bufnum,
		1,
		LFBrownNoise2.ar(0.1).range(0, ~sizz.numFrames),
		pan: WhiteNoise.ar(),
		mul: 1
	);
	sig = Ringz.ar(sig, MouseY.kr(0, 50), 0.1);
	FreeVerb2.ar(sig[0], sig[1]);
}.play
)



// good kick
(
{
	var env = EnvGen.ar(Env.perc(), doneAction: 2);
	var sig = Shaper.ar(
		~uhhs[0].bufnum,
		PlayBuf.ar(2, ~uhhs[0].bufnum)
	);
	Ringz.ar(sig, 50, LFNoise2.ar().range(0.01, 0.5)) * env;
}.play
)
// also insane thud
(
{
	var env = EnvGen.ar(Env.perc(releaseTime: 0.8), doneAction: 2);
	var sig = Shaper.ar(
		~uhhs[0].bufnum,
		LFNoise2.ar()!2
	);
	sig = Ringz.ar(sig * env, 50, WhiteNoise.ar().range(0.01, 0.5));
	Compander.ar(sig, slopeAbove: 0.9)
}.play
)
s.meter

(
{
	var sig = Ringz.ar(WhiteNoise.ar(), MouseY.kr(0, 100), 1);
	Compander.ar(sig, sig, 0.1)!2
}.play
)