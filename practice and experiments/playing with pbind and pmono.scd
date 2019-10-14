(
SynthDef(\siney, {
	arg freq=440, gate=0;
	var env = EnvGen.ar(Env.adsr(), gate);
	var sig = SinOsc.ar(freq) * env;
	Out.ar(0, Pan2.ar(sig));
}).add
)

(
p = Pmono(\siney,
	\dur, 1,
	\freq, Pseq(Scale.minor.degrees + 40, inf).midicps,
	\gate, Pseq([1, 0], inf)
).play
)
//alternate approach using pbind
(
x = Synth(\siney);

p = Pbind(
	\type, \set,
	\id, x.nodeID,
	\args, #[\freq, \gate],
	\freq, Pseq(Scale.major.degrees + 60, inf).midicps,
	\gate, Pseq([1, 0], inf)
).play;
)


p.stop;
s.boot;