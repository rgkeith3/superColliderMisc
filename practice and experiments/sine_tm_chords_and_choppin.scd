s.boot

ProxySpace.push()
currentEnvironment.makeTempoClock
currentEnvironment.clock.tempo_(145/60)
currentEnvironment.quant_(4)
b = 150
(
~a[0] = Pbind(\instrument, \sin, \scale, Scale.major.tuning_(\just), \degree, Ptm(choices: [0, 2, 3, 4, 5, 7]).stutter(3), \dur, 1/4, \octave, 6, \pan, Pwhite(-1), \rel, Pwrand([0, 1], [0.8, 0.2], inf), \legato, Prand([0.5, 1], inf));
~a[1] = Pbind(\instrument, \sin, \scale, Scale.major.tuning_(\just), \degree, Ptm(choices: [0, 2, 3, 4, 5, 7]).stutter(5), \dur, 3/4, \octave, 5, \pan, Pwhite(-1), \rel, Pwrand([0, 1], [0.8, 0.2], inf), \legato, Prand([0.5, 1], inf));

~a[2] = Pbind(\instrument, \sin, \scale, Scale.major.tuning_(\just), \degree, Ptm(choices: [0, 2, 3, 4, 5, 7]).stutter(7), \dur, 5/4, \octave, 4, \pan, Pwhite(-1), \rel, Pwrand([0, 1], [0.8, 0.2], inf), \legato, Prand([0.5, 1], inf));

~a[3] = Pbind(\instrument, \sin, \scale, Scale.major.tuning_(\just), \degree, Ptm(choices: [0, 2, 3, 4, 5, 7]).stutter(5), \dur, 7/4, \octave, 3, \pan, Pwhite(-1), \rel, Pwrand([0, 1], [0.8, 0.2], inf), \legato, Prand([0.5, 1], inf));
)

~a[10] = \filter -> {|in| FreeVerb.ar(in, room: 1, damp: 0.5, mul: 50).distort}
~a[15] = \filter -> {|in| RLPF.ar(in, LFNoise2.kr(0.1).range(400, 4000), 0.2)}

~a[20] = \filter -> {|in, t_chopL, t_chopR, rel=1| in * EnvGen.ar(Env.perc(0, rel), [t_chopL, t_chopR])};
~a[21] = \set -> Pbind(\t_chopL, Pwrand([1, 0], [0.9, 0.1], inf), \t_chopR, Pwrand([1, 0], [0.9, 0.1], inf),\dur, Pseq([1/4, 1/4, 1/2, 1/4, 1/4, 3/2, 1/2, 1/2], inf), \rel, Pbrown());

Scale.major.degrees
(SynthDef(\sin, {|freq=440, gate=1, pan=0, out=0, atk=0, rel=0.1|
	Out.ar(out, Pan2.ar(SinOsc.ar(freq) * EnvGen.ar(Env.adsr(atk, 0, 1, rel), gate, doneAction: 2), pan));
}).load)

Scale.major.tuning_(\just).ratios
50 * 1.25 + 50


~a.play

3.lcm(5)
15.lcm(7)
7 * 15
105 / 3
5.lcm(7)
3.lcm(7)