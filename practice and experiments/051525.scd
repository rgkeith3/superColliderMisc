s.boot
// using multiple proxy spaces

p = ProxySpace(s)
p.makeTempoClock(2)
p.quant_(4)

(SynthDef(\saw, {
	var sig = Saw.ar(\freq.kr(440) * Env.perc(0, 0.05).ar(0, 1, 1, 10, 1));
	sig = RLPF.ar(sig, \filt_freq.kr(1000) * SinOsc.ar(4).linexp(-1, 1, 0.5, 2), \q.kr(0.5));
	sig = sig * Env.asr(releaseTime: 0.01).ar(2, \gate.kr(1));
	sig = Pan2.ar(sig, \pan.kr(0));
	Out.ar(\out.kr(0), sig);
}).add)
p.clock.tempo_(140/60)

p[\a][0] = Pbind(\instrument, \saw, \octave, 2, \degree, Pseq([2, \, \, \], inf), \dur, 2, \filt_freq, Pbrown().linexp(0, 1, 50, 1000), \q, Pbrown(0.1), \legato, 0.5)

p[\a][100] = \filterIn -> {|in| var fb = FbNode(2, 2); var sig = in + HPF.ar(fb.delay(3/4 * p[\tempo].kr.reciprocal) * 0.9, [440, 550]) + Crackle.ar(LFNoise1.ar(1).range(0.5, 2), 0.01); fb.write(sig); sig;}
p[\rev][0] = \mix -> {p[\a].ar}
p[\rev][100] = \filterIn -> {|in| NHHall.ar(in, 2)}
p[\rev].set(\mix0, 0.5)

p[\out][0] = \mix -> {p[\a].ar}
p[\out][10] = \mix -> {p[\rev].ar}
p[\out].set(\mix10, 1)
p[\out].play


o = ProxySpace(s); o.makeTempoClock(210/60)
o.quant_(4);

o[\out].play

o[\a] = Pbind(\instrument, \saw, \degree, Pseq([1,2,3],inf), \dur, 1/2, \filt_freq, Pseg([50, 5000, 50], 28, \sin, inf), \q, Pbrown(0.1))

o[\out][0] = \mix -> {o[\a].ar}
