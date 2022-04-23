ProxySpace.push(s.boot)

(SynthDef(\saw, {|freq=440, out=0, gate=1, ffreq=1000, q=0.5, pan=0, atk=0.01, rel=0.1, fenv=1|
	var sig, env;
	env = EnvGen.ar(Env.adsr(atk, 0, 1, rel), gate, doneAction: 2);
	sig = RLPF.ar(Saw.ar(freq), ffreq * fenv * env, q);
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).load)

~a = Pbind(\instrument, \saw, \dur, Pseq([1/6, 2/6], inf), \q, 0.5, \ffreq, ~ffreq, \octave, 4, \degree, [0,2,4], \scale, Scale.minor.tuning_(\just), \atk, 0.1, \rel, 0.2, \legato, 0.1, \fenv, Pbrown(1, 4))
~a.play
~a[10] = nil
~a[10] = \filter -> {|in| CombN.ar(in, 1/2, [2/6, 3/8], 2)}
~a.set(\wet10, 0.3)

~a[11] = \filter -> {|in| FreeVerb.ar(in, room: 1)}


~ffreq=  {SinOsc.ar(0.1).range(500, 5000)}