s.boot

b = Bus.audio(s, 2);

(
SynthDef(\curveSaw, {
	arg freq=440,
	filt_freq=200,
	filt_q=1, amp=1,
	atk=1, rel=1,
	pitch_vector=0.5,
	pitch_chaos=10,
	pan_vector=(-1),
	pan_pos=0,
	out=0;
	var pitchEnv = Line.ar(
		freq - (pitch_vector * (freq/2)), freq + (pitch_vector * (freq/2)), atk + rel
	);
	var panEnv = Line.ar(pan_pos - pan_vector, pan_pos + pan_vector, atk + rel);
	var ampEnv = EnvGen.ar(Env([0,1,0], [atk, rel]), doneAction: 2);
	var sig = SawDPW.ar(pitchEnv + LFBrownNoise2.ar(mul: pitch_chaos));
	var filt = RLPF.ar(sig, filt_freq, filt_q);
	var flutter = PinkNoise.ar(0.1) * SinOsc.ar(15 * ampEnv);
	var mix = Mix([filt, flutter]) * ampEnv;
	Out.ar(
		out,
		PanAz.ar(2, mix, pan_pos + panEnv)
	)
}).add
)

(
Pdef(\curveSaw,
	Pbind(
		\instrument, \curveSaw,
		\dur, Pwhite(hi: 0.3),
		\freq, Prand([500, 100, 400, 200], inf),
		\pitch_vector, Pwhite(lo: -1.0),
		\pitch_chaos, 10,
		\pan_vector, Pwhite(-1.0),
		\pan_pos, Pwhite(),
		\filt_q, 0.05,
		\filt_freq, Pwhite(2000, 4000),
		\atk, Pwhite(),
		\rel, Pwhite(),
		\out, 0
	)
).play
)

s.scope

(
SynthDef(\slicer, {
	arg bus=0, out=0, speed=1, depth=1, width=0.5;
	var in = In.ar(bus, 2);
	var sig = PulseDPW.ar(speed, width, 0.5, 0.5) * in;
	Out.ar(out, sig);
}).add
)

x = Synth(\slicer, [\bus, b.index], addAction: \addToTail);
x.set(\speed, 3)
x.free

(
Pdef(\slicer,
	Pbind(
		\type, \set,
		\id, x.nodeID,
		\args, [\speed, \depth, \width],
		\speed, Prand([3, 4], inf),
		\depth, Pwhite(),
		\width, Pwhite()
	)
).play
)

(
SynthDef(\ping, {
	arg rel=1, freq=440;
	var env = EnvGen.ar(Env.perc(releaseTime: rel), doneAction: 2);
	var sig = SinOsc.ar(freq) * env;
	Out.ar(0, sig)
}).add
)

(
Pdef(\melody,
	Pbind(
		\instrument, \ping,
		\dur, Pseq(0.3!7 ++ [Pseq([0.1], 3)],inf),
		\rel, Pkey(\dur),
		\degree,
			Prand([
				Pseq([12, 14, 15, 17, 19,21], 2),
				Pseq([15, 17, 15, 17, 14, 12], 1),
				Pseq([17, 16], 4)
			], inf)
	)
).play
)
