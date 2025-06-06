s.boot


p = ProxySpace.push
p.makeTempoClock
p.quant_(8)
p.clock.tempo_(145/60)

(
SynthDef(\plink, {
	var freqs = \freq.kr(440) * Array.series(16, 1, \harm.kr(1.5));
	var sig = Ringz.ar(Env.sine(\mallet.kr(0.5).linexp(0, 1, 0.01, 0.001)).ar(0, 1), freqs, Array.exprand(16, 0.001, 1).sort.reverse * \rel.kr(1), 1/16).sum;
	DetectSilence.ar(sig, doneAction: 2);
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.8));
	Out.ar(\out.kr(0), sig);
}).add
)


~a[0] = Pbind(\instrument, \plink, \dur, Pseq(Bjorklund2(13, 16).scramble, inf)/2, \degree, Pseq(Array.rand(13, 0, 8), inf), \octave, 5, \amp, -6.dbamp, \scale, Scale.phrygian, \rel, Pbrown(hi: 2.0))

~a[5] = \filter -> {|in| (in * 8).tanh}
(
~a[10] = \filterIn -> {|in|
	var fb = FbNode(2, 2);
	var sig = fb.delay(\del.kr(3/8) * ~tempo.kr.reciprocal) + in;
	sig = sig.distort;
	sig = BLowPass.ar(sig, LFNoise1.ar(0.1).exprange(1000, 10000));
	sig = BHiPass.ar(sig, LFNoise1.ar(0.1).exprange(100, 1000));
	sig = DoubleNestedAllpassC.ar(sig);
	sig = sig.fold(-1, 1);
	fb.write(sig * \fb.kr(0.9));
	sig = sig + Crackle.ar(LFNoise2.ar(0.1).range(1, 2), 0.1);
	sig;
}
)
~a.set(\del, 5/6);
~a.set(\fb, 0.5)
~b = {Lag.ar(2.pow(LFNoise1.ar(0.1).exprange(1, 8).floor).reciprocal)}
~a.set(\wet10, 1)

~a[15] = \filter -> {|in| in * Env([1, 0, 1, 0, 1, 1, 0], [1, 0.001, 1, 0.001, 1, 1].normalizeSum).circle.ar(0, 1, ~tempo.kr.reciprocal)}
~a[15] = nil

~a[20] = \filterIn -> {|in| FreeVerb.ar(in, 1, 1, 0)};
~a.set(\wet20, 0.1)






~a[10] = \filterIn -> {|in| DoubleNestedAllpassC.ar(in, delay1: 0.001, delay2: 0.01, delay3: 0.1)}
~a.set(\wet10, 0.1)

~a.play
~a[10] = nil