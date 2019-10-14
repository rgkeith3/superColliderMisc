(
SynthDef.new(\wormy, {
	arg freq=440, chaos=5, atk=1, rel=1, out=0;

	var env = LFBrownNoise2.ar(chaos.reciprocal) * EnvGen.ar(Env(times: [atk, rel]), doneAction: 2);
	var sig = SawDPW.ar(LFBrownNoise2.ar(chaos, mul: freq * chaos.reciprocal, add: freq));
	Out.ar(out, Pan2.ar(sig * env, LFBrownNoise2.kr(chaos)));
}).add;
)

(
SynthDef.new(\reverb, {
	arg in=100, out=0;
	var sig = In.ar(in, 2);
	Out.ar(out, FreeVerb2.ar(sig[0], sig[1]));
}).add
)
Synth(\reverb)

Synth(\wormy, [\freq, 100, \atk, 4, \rel, 4, \out, 100]);

(
p = Pbind(
	\instrument, \wormy,
	\dur, 0.1,
	\freq, Pxrand([12, 25, 50, 75], inf),
	\out, 100
).play;
)
p.stop;


(
q = Pbind(
	\instrument, \plucky,
	\dur, Pexprand(lo: 0.01, hi: 0.1, length: inf),
	\freq, Pseq([72, 76, 79, 83], inf).midicps,
	\length, Pwhite(lo: 1, hi: 5, length: inf),
	\pos, Pwhite(-1, 1, inf),
	\out, 100
).play;
)
q.stop;

440.reciprocal


(
SynthDef.new(\plucky, {
	arg freq=440, length=3, out=0, pos=0;
	var sig = Pluck.ar(PinkNoise.ar, delaytime: freq.reciprocal, decaytime: length);
	var env = EnvGen.ar(Env([1,0], [length]), doneAction: 2);
	Out.ar(out, Pan2.ar(sig, pos));
}).add
)
s.quit
s.plotTree;
s.boot;

(
SynthDef.new(\ping, {
	arg freq=440, amp=1, rel=1, pan=0, out=0;
	var env = EnvGen.ar(Env.perc(releaseTime: rel, level: amp), doneAction: 2);
	var sig = SinOsc.ar(freq) * env;
	Out.ar(out, Pan2.ar(sig, pos: pan));
}).add
)

(
x = Pbind(
	\instrument, \ping,
	\freq, Pseq([72, 76, 79, 83], inf).midicps,
	\dur, Pseq([0.3]++ (0.1 ! 7), inf),
	\amp, Prand([0.2, 0.1], inf),
	\pan, Pwhite(-1, 1, inf)
).play;
)
x.stop;

