
({
	var sig, wet;
	sig = PlayBuf.ar(1, d[\stereo_samples][\texture].choose, loop: 1);
	sig = PanAz.ar(7, sig, LFNoise2.kr(LFNoise2.kr(1).range(0.01, 1), 5).wrap(pi, -pi), width: 2);
	wet = LPF.ar(CombL.ar(sig, delaytime: (250 * [0.5, 1, 4/3, 3/2, 2]).reciprocal, decaytime: 2), 2000);
	6.do {
			wet = AllpassL.ar(wet, delaytime: Rand(0, 0.1!7), decaytime: 2);
	};
	sig = sig + wet;
	[sig[6], sig[1], sig[0], Mix(sig), sig[5], sig[2], sig[4], sig[3]];
}.play)
p

SynthDef(\ambiPluck, {
	|freq=440, excite=0.5, timbre=0.5, dec=1, out=0, azi=0, ele=0, dist=1|
	var sig = Pluck.ar(LPF.ar(WhiteNoise.ar(), excite.linlin(0, 1, 0, 10000)), 1, freq.reciprocal, freq.reciprocal, dec, timbre);
	DetectSilence.ar(sig, doneAction: 2);
	sig = FoaEncode.ar(sig, FoaEncoderMatrix.newOmni);
	sig = FoaFocus.ar(sig, pi, azi, ele);
	sig = FoaProximity.ar(sig, dist, dist.reciprocal.clip(0, 1));
	Out.ar(out, sig);
}).load
~a.clear
~a = Pbind(\instrument, \ambiPluck, \azi, Pwhite(-pi, pi), \dist, Pwhite(0.1, 10), \dec, 4, \dur, 1/4, \timbre, Pwhite(0.4, 0.8), \excite, Pwhite(), \degree, Prand([0, 2, 4,6],inf), \octave, Prand([3,4,5,6],inf))
~a[10] = \filter -> {|in| FreeVerb.ar(in, room: 0.5, damp: 0)}
~a.scope
~a.play(b)



p.push

0.1.reciprocal
b
// outside of proxySpace
// make b a var so we can use it in proxyspace to play to
b = Bus.audio(s, 4);
b.monitor
b.ar
// this is a global var in the toplevel env (non proxyspace)
(q = {
	var sig = FoaDecode.ar(b.ar, FoaDecoderMatrix.newPanto(7));
	[sig[6], sig[1], sig[0], Mix(sig), sig[5], sig[2], sig[4], sig[3]];
}.play(addAction: \addToTail))
q.moveToTail
s.scope
currentEnvironment