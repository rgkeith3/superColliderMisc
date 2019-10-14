s.boot
(
SynthDef(\sin, {
	|atk = 0.01, rel = 0.1, freq = 50, amp =1|
	var sig, env;

	env = EnvGen.ar(Env.perc(atk, rel, amp), doneAction: 2);
	sig = SinOsc.ar(freq) * env;
	Out.ar(0, sig!2);
}).add
)

(
SynthDef(\delay, {
	|in=0, decaytime=1, clock=1, delaytime=0.25, pan=0|
	var sig;
	sig = In.ar(in);
	sig = CombC.ar(sig, clock * 8, delaytime * clock, decaytime) + sig;
	ReplaceOut.ar(0, Pan2.ar(sig, pan));
}).add
)

x = Synth(\delay, addAction: \addToTail)

x.set(\decaytime, 0)
x.set(\delaytime, 1/16)
(
Pbindef(\sins,
	\instrument, \sin,
	// \delta, Pseq([1/3, 1/3, 1/2, 2/3, 1/3, 1/2], inf),
	\delta, 1,
	\rel, 0.1,
	\degree, Pseq([1, 2,3,4], inf),
	\octave, 6
).play
)