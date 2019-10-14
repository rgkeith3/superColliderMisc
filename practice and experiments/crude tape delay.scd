(
SynthDef(\sinTone, {
	arg atk=0.01, hold=1, rel=0.01, freq=440, pan=0;
	var env, sig;
	env = EnvGen.ar(Env([0, 1, 1, 0], [atk, hold, rel]), doneAction: 2);
	sig = SinOsc.ar(freq) * env;
	Out.ar(0, Pan2.ar(sig, pan));
}).add
)

(
SynthDef(\tapeDel, {
	arg in=0, delayTime=1, fb=0.5, warbleDepth=0.5, warbleSpeed=1;
	var sig, local, warble;
	warble = LFNoise2.ar(warbleSpeed, warbleDepth) * delayTime;
	sig = In.ar(0, 2);
	local = LocalIn.ar(2) + sig;
	local = CombC.ar(local, 5, delayTime + warble, 0.001);
	LocalOut.ar(local * fb);
	ReplaceOut.ar(0, sig + local);
}).add
)

~del = Synth.new(\tapeDel, addAction: \addToTail)
~del.set(\fb, 0.5);
~del.set(\delayTime, 1/2);
~del.set(\warbleDepth, 0.1);
~del.set(\warbleSpeed, 0.1);

~del2 = Synth.new(\tapeDel, addAction: \addToTail)
~del2.set(\fb, 0.5)
~del2.set(\delayTime, 1/16)
~del2.set(\warbleDepth, 0.1)
~del2.set(\warbleSpeed, 0.1)

(
Pbindef(\sins,
	\instrument, \sinTone,
	\delta, Pseq([1/3, 1/3, 1/2], inf),
	\atk, 0.01,
	\hold, 0,
	\rel, 0.1,
	\degree, Prand([1, 5,7,11], inf),
	\pan, Pwhite(-1.0, 1.0)
).play
)

(
Pbindef(\bass,
	\instrument, \sinTone,
	\delta, 1/2,
	\atk, 0,
	\hold, 0,
	\rel, 0.1,
	\octave, 4,
	\pan, Pbrown(-1.0, 1.0)
).play
)

{[SinOsc.ar(150), CombC.ar(SinOsc.ar(150), 1, MouseX.kr())]}.play