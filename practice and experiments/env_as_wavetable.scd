s.boot;

b = Buffer.alloc(s, 2048);

(
var env, sig, wt;
env = Env.perc();
sig = env.asSignal(1024);
wt = sig.asWavetable;
b.loadCollection(wt);

)
b.plot

{Osc.ar(b.bufnum, MouseY.kr(0, 5000))!2}.play
s.scope;

(
~envs = Buffer.allocConsecutive(48, s, 1024).collect({
	arg b, i;
	var numSegs, env, sig, wt;
	numSegs = i+1;
	env = Env(
		{rrand(-1.0, 1.0)}!(numSegs + 1) * [-1, 1],
		{rrand(0.0, 5.0)}!numSegs,
		{rrand(-5.0, 5.0)}!numSegs
	);
	sig = env.asSignal(512);
	wt = sig.asWavetable;
	b.loadCollection(wt);
});
)

(
{
	var sig = VOsc3.ar(MouseX.kr(~envs[0].bufnum, ~envs[47].bufnum), 50, 75, 100)!2;
	sig = Shaper.ar(rrand(~envs[0].bufnum, ~envs[47].bufnum), sig);
	sig = RLPF.ar(sig, 5000, 0.2);
	sig = FreeVerb2.ar(sig[0], sig[1]);
	sig = Compander.ar(sig, sig, 1);
}.play
)
~envs[47].bufnum
(
SynthDef(\verb2, {
	arg in, out, room, mix, damp;
	var sig = In.ar(in, 2);
	Out.ar(out, FreeVerb2.ar(sig[0], sig[1], mix, room, damp));
}).add
)

b = Bus.audio(s, 2);
b.index;

v = Synth(\verb2, [\in, b.index, \out, 0, \room, 0.5, \mix, 0.3, \damp, 0.5]);
v.set(\room, 0.1);
v.set(\mix, 0.5);
v.set(\damp, 0.7);

(
SynthDef(\wow, {
	arg out=4, atk=4, rel=4, curve=0, freq=50, startBufnum=290, lastBufnum=337, center_freq=500, spread=2, q=0.2;
	var ampEnv, env1, env2, sig1, sig2, fenv1, fenv2, sig;
	ampEnv = EnvGen.ar(Env([0, 1, 0], [atk, rel], curve), doneAction: 2);

	env1 = Env({Rand(startBufnum, lastBufnum)}!4, {Rand(hi: (atk + rel)/3)}!3, {Rand(-5.0, 5.0)}!3);
	env2 = Env({Rand(startBufnum, lastBufnum)}!4, {Rand(hi: (atk + rel)/3)}!3, {Rand(-5.0, 5.0)}!3);
	sig1 = VOsc.ar(EnvGen.ar(env1), freq);
	sig2 = VOsc.ar(EnvGen.ar(env2), freq);
	fenv1 = Env({Rand(center_freq/spread, center_freq)}!4, {Rand(hi: (atk + rel)/3)}!3, {Rand(-5.0, 5.0)}!3);
	fenv2 = Env({Rand(center_freq * spread, center_freq * spread * spread)}!4, {Rand(hi: (atk + rel)/3)}!3, {Rand(-5.0, 5.0)}!3);
	sig1 = RLPF.ar(sig1, EnvGen.ar(fenv1), q) * ampEnv;
	sig2 = RHPF.ar(sig1, EnvGen.ar(fenv2), q, 10)* ampEnv;
	sig = Mix([sig1, sig2]);
	sig = Clip.ar(sig, -1, 1);
	Out.ar(out, sig!2)
}).add
)

s.scope;
~envs[0].bufnum
Synth(\wow, [\out, b.index, \startBufnum, ~envs[0].bufnum, \lastBufnum, ~envs[47].bufnum]);
b.index
Pdefn(\degree, 1)

(
Pdef(\wows,
	Pbind(
		\instrument, \wow,
		\dur, 1/4,
		\atk, 0.01,
		\rel, 1,
		\degree, Pdefn(\degree),
		\octave, 3,
		\center_freq, 500,
		\spread, 0.01,
		\q, 0.1,
		\curve, -3,
		\startBufnum, ~envs[0].bufnum,
		\lastBufnum, ~envs[45].bufnum,
		\out, b.index
	)
).play
)
(
Tdef(\chord_change, {
	loop {
		Pdefn(\degree, Prand(Scale.major.degrees.scramble[0..3], inf));
		"changed".postln;
		25.wait;
	}
}).play
)

Tdef(\chord_change).stop
Scale.minor.degrees.scramble[0..3]