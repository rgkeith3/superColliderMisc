(
~sin = {
	|freq|
	SinOsc.ar(freq)
};

~env = {
	|in, atk, dec, sus, rel|
	EnvGen.ar(Env.adsr(atk, dec, sus, rel), doneAction: 2) * in;
};

~pan = {
	|in, pan|
	Pan2.ar(in, pan);
};
)
(
SynthDef(\test, {
	var sig;
	sig = SynthDef.wrap(~sin);
	sig = SynthDef.wrap(~env, prependArgs: [sig]);
	sig = SynthDef.wrap(~pan, prependArgs: [sig]);
	Out.ar(0, sig);
}).add;
)

Synth(\test, [\freq, 50, \atk, 0.1, \pan, -1])