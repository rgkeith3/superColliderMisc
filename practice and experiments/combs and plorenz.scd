(
SynthDef(\saw, {
	|atk = 0.01, rel=1, freq=440|
	var env, sig;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction: 2);

	sig = SawDPW.ar(freq) * env;
	Out.ar(0, sig!2);
}).add
)

(
Pbindef(\saws,
	\instrument, \saw,
	\delta, 1/4,
	\degree, Pfsm([
		#[0,1],
		4, #[0, 0, 3],
		6, #[1, 2],
		7, #[0, 2],
		Pseq([1,2,3,4]), #[2,3,3]
	]),
	\octave, Prand([3,4,5,6], inf),
	\atk, 0.01,
	\rel, 1,
).play
)

(
Pbindef(\saws,
	\instrument, \saw,
	\delta, 1/16,
	\degree, Plorenz(8, 20, 2.5, 0.02).trace,
	\octave, Prand([3,4,5,6], inf),
	\atk, 0.01,
	\rel, 0.2,
).play
)

(
{
	var sig = In.ar(0, 2);

	5.do { |i|
		sig = (CombN.ar(sig, 0.5, MouseX.kr(0.0001, 0.1) * i, MouseY.kr(maxval: 5) * MouseX.kr) + sig) * 0.5;
	};
	ReplaceOut.ar(0, sig);
}.play;
)

s.boot

(
SynthDef("help-VOsc",{ arg out=0, bufoffset=0, freq=240;
    var x;
    // mouse x controls the wavetable position
    x = MouseX.kr(0,7);
    Out.ar(out,
        VOsc3.ar(bufoffset+x, freq, freq * 2,freq / 2, 0.3)!2
    )
}).play(s,[\out, 0, \bufoffset, 0]);
)
s.boot
