p = ProxySpace.push(s.boot)
(
SynthDef(\k, {
	var sig = SinOscFB.ar(Env.perc(0, \kpDec.kr(0.01)).ar(0, \gate.kr(1), 1, \kAmt.kr(1000), \kfreq.kr(50)), \fb.kr(0));
	sig = sig * Env.perc(0, \krel.kr(0.1)).ar(2, \gate.kr(1));
	sig = Pan2.ar(sig, \kpan.kr(0), \kdb.kr(0).dbamp);
	Out.ar(\out.kr(0), sig);
}).load;

SynthDef(\s, {
	var sig = SinOscFB.ar(Env.perc(0, \pDec.kr(0.01)).ar(0, \gate.kr(1), 1, 10000, \sfreq.kr(250)), 500);
	var alt = ClipNoise.ar() * Env.perc(0.01, \rel.kr(0.2)/2).ar(2, \gate.kr(1));
	sig = sig * Env.perc(0, \srel.kr(0.2)).ar(0, \gate.kr(1));
	sig = sig + alt;
	sig = Pan2.ar(sig, \pan.kr(0), \db.kr(0).dbamp);
	Out.ar(\out.kr(0), sig);
}).load;

SynthDef(\h, {
	var sig = SinOscFB.ar(Env.perc(0, 0.01).ar(0, \gate.kr(1), 1, 10000, 10000), \fb.kr(0).linlin(0,1, 0, 100));
	sig = sig + ClipNoise.ar * Env.perc(0, \hrel.kr(0.05)).ar(2, \gate.kr(1));
	sig = Pan2.ar(sig, \pan.kr(0), \db.kr(0).dbamp);
	Out.ar(\out.kr(0), sig);
}).load;
)
~a[0] = Pbind(\instrument, Pseq([\k!8, \s!5, \h!19].flatten.scramble, inf), \dur, 1/4, \pan, Pwhite(-1), \fb, Pwhite(), \sfreq, 500, \srel, 0.1, \legato, 1, \db, -16)

~a[5] = nil
~a[10] = \filter -> {|in| CombN.ar(in, ~tempo.kr.reciprocal, ~tempo.kr.reciprocal * [\delr.kr(0.125), \dell.kr(0.125)], \dec.kr(1));}
~a[15] = \set -> Pbind(\wet10, Pwrand([0, 1], [0.8, 0.2], inf), \dec, Pwhite(1, 10), \delr, Prand(1/[1, 2, 4, 8], inf), \dell, Prand(1/[1, 2, 4, 8], inf), \dur, 1/2)

~a[20] = \filter -> {|in| in * (Amplitude.ar(in) > 0.03)}

~a[30] = \filter -> {|in| CombC.ar(in, 0.2, LFNoise2.ar(~tempo.kr!2).exprange(0.001, 0.05), LFNoise2.ar(~tempo.kr!2).exprange(0.01, 0.5))}
~a[40] = \filter -> {|in| PitchShift.ar(in, ~tempo.kr.reciprocal, LFNoise0.ar(~tempo.kr!2).exprange(0.5, 2))}
~a[45] = \set -> Pbind(\wet40, Pwrand([0, 1], [0.8, 0.2], inf), \wet30, Pwrand([0, 1], [0.8, 0.2], inf), \dur, 1/4)

~a[50] = nil

~b =Pbind(\instrument, \k, \dur, Prand([2, Pseq([1/2, 3/2], 1)], inf), \fb, 1, \krel, 1, \db, 16, \kAmt, 10000, \kfreq, 50, \kpDec, 0.05)
~b[1] = \filter -> {|in| (in * 10).distort}
~b.play;
~a[60] = \filter -> {|in| Compander.ar(in,~b.ar, slopeBelow: 0.1, slopeAbove: 0.1, relaxTime: 0.1)}
~a.set(\wet30, 0.5)
~a.set(\wet10, nil)
~a.set(\delr, nil)
~a.set(\dell, nil)
~a.set(\dec, nil)
~a[15] = nil
\k!5
p.makeTempoClock
p.quant_(4)

p.clock.tempo_(145/60)
~a.play
~a.stop

~tempo.asBus.getSynchronous.reciprocal



~b[0] = Pbind(\instrument, \k, \dur, Pbjorklund2(6, 16, inf) / 2, \legato, 1, \krel, Pwrand([0.5, 0.1, 1], [0.5, 0.4, 0.1], inf), \fb, 100)
~b[1] = Pbind(\instrument, \s, \dur, Pseq([3, Pbjorklund2(4, 16, inf)]) / 2)
~b[2] = Pbind(\instrument, \h, \dur, 1/2, \hrel, 0.1)
~b[3] = Pbind(\instrument, \h, \dur, Prand([12, 2, Pn(1/4, 8)], inf)/2, \hrel, 0.01)

~b[5] = \filter -> {|in| (in * 50).distort}
~b.play; ~a.stop;
~b.stop; ~a.play;