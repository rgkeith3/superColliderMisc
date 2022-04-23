(SynthDef(\wt, {|out=0, gate=1, freq=440, pan=0, x=0.5, y=0.5, traverse=0, traverseSpd=0, atk=0.01, rel=0.1|
	var sig, env;
	sig = SelectX.ar((K2A.ar(y) + LFNoise1.kr(traverseSpd, traverse)).linlin(0, 1, 0, 3), [
		VOsc.ar((K2A.ar(x) + LFNoise1.kr(traverseSpd, traverse)).linlin(0, 1, w.first.bufnum, w.first.bufnum + 11), freq),
		VOsc.ar((K2A.ar(x) + LFNoise1.kr(traverseSpd, traverse)).linlin(0, 1, w.first.bufnum + 12, w.first.bufnum + 23), freq),
		VOsc.ar((K2A.ar(x) + LFNoise1.kr(traverseSpd, traverse)).linlin(0, 1, w.first.bufnum + 24, w.first.bufnum + 35), freq),
		VOsc.ar((K2A.ar(x) + LFNoise1.kr(traverseSpd, traverse)).linlin(0, 1, w.first.bufnum + 36, w.first.bufnum + 47), freq),
	]);
	env = EnvGen.ar(Env.adsr(atk, sustainLevel: 1, releaseTime: rel), gate, doneAction: 2);
	sig = sig * env;
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).load)
{VOsc.ar((K2A.ar(0.5) + LFNoise1.kr(0.5, 0.5)).linlin(0, 1, w.first.bufnum + 36, w.first.bufnum + 47), 150)}.play
w.size/4

s.scope

~a = Pbind(\instrument, \wt, \degree, Pdict((i: [0,2,4,5], ii: [1,3,5,7], iii: [2,4,6,8], iv: [3,5,7,9], v: [4,6,8,10], vi: [5,7,9,11], vii: [6,8,10,12]), Ptm(choices: [\i, \ii, \iii, \iv, \v, \vi, \vii], probability: 0.2)), \octave, 4, \dur, 8, \scale, Scale.minor.tuning_(\just), \x, Pbrown(), \y, Pbrown(), \pan, Pwhite(-1), \rel, 0, \atk, 0, \traverse, 0.5, \traverseSpd, 1, \legato, 1)

~a[10] = \filter -> {|in| NHHall.ar(in, 2) + in + Crackle.ar(LFNoise1.kr(0.1).range(0.5, 2))}
~a.mold(2)
~a.play