
(
var winenv;
winenv = Env.perc();
z = Buffer.sendCollection(s, winenv.discretize, 1);
)

(
SynthDef(\gKick, {
	arg rel=0.5,
	spray=0,
	grain_pitch=50,
	pitch_env=1,
	trig_speed=500,
	trig_env=1,
	grain_size=0.1,
	grain_size_env=1;
	var env = EnvGen.ar(Env.perc(releaseTime: rel), doneAction: 2);
	var sig = GrainSin.ar(
		2,
		Impulse.ar(trig_speed * (env * trig_env)),
		grain_size * (env * grain_size_env),
		(grain_pitch * (env * pitch_env)) + grain_pitch,
		WhiteNoise.ar(spray),
		z.bufnum,
		mul: 0.5
	);
	sig = Compander.ar(sig, sig, slopeBelow: 0.1, slopeAbove: 0.01);
	Out.ar(0, sig);
}).add
)

s.meter
s.scope

(
Pdef(\kikker,
	Pbind(
		\instrument, \gKick,
		\dur, Pseq([1/3, 1/3, 1/4], inf),
		\rel, Pkey(\dur),
		\grain_pitch, Pwhite(50, 500),
		\trig_speed, Pwhite(50, 500),
		\trig_env, Pwhite(1, 50),
		\spray, Pwhite(),
		\pitch_env, Pwhite(),
		\grain_size, Pwhite(0.001, 0.1),
		\grain_size_env, 1
	)
).play
)
s.boot