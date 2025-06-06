s.boot

(
SynthDef(\three, {
	var sig = LFSaw.ar(\freq.kr(440, \glide.kr(0.1)) * (\detune.kr(0.5) * [-1, 0, 1]).linexp(-1, 1, 0.5, 2), 1/3).sum;
	var env = Env.adsr(\atk.ar(0.01), \dec.kr(0.3), \sus.kr(0.5), \rel.kr(0.1)).ar(2, \gate.kr(1));
	sig = RLPF.ar(sig, LinXFade2.kr(\filtFreq.kr(1000), env.linexp(0, 1, 20, \filtFreq.kr(1000, \glide.kr(0.1))), \filtEnv.kr(0.5).linlin(0, 1, -1, 1)), \q.kr(0.3), \dist.kr(0).linexp(0, 1, 1, 100)).distort;
	sig = sig * env * \amp.kr(0.8);
	sig = Pan2.ar(sig, \pan.kr(0));
	Out.ar(\out.kr(0), sig);
}).add
)


p = ProxySpace.push(s)

p.makeTempoClock(140/60)
p.quant_(4)
(
~a[0] = PmonoArtic(\three,
	\dur, 1/4,
	\detune, 0.01,
	\dist, Pbrown(),
	\octave, Pseq(Array.fill(16, {[3,4].choose}), inf),
	\legato, Pseq(Array.fill(16, {[0.5, 1].choose}), inf),
	\degree, Pseq(Array.fill(32, {[0,1,2,3,4,5,\].choose}), inf),
	\filtFreq, Pseq(Array.exprand(16, 2000, 10000), inf),
	\q, Pbrown(),
	\filtEnv, Pbrown(),
	\glide, 0.1,
	\scale, Scale.phrygian,
	\pan, Pbrown(-1),
	\amp, Pseq(Array.fill(32, {[0.5, 0.8].choose}), inf),
	\atk, Pbrown(),
	\sus, Pbrown(),
	\dec, Pbrown(),
	\rel, Pbrown()
)
)

~a[10] = \filter -> {|in| RLPF.ar(in, LFNoise2.ar(0.1).exprange(50, 10000), 1)}

~a[20] = \filterIn -> {|in| var fb = FbNode(2, 3); var sig = in + fb.delay(~tempo.kr.reciprocal * 3/4 * 2); sig = HPF.ar(sig); fb.write(sig * 0.99); sig }; ~a.set(\wet20, 0.2)

~a[30] = \filterIn -> {|in| FreeVerb.ar(HPF.ar(in), 1, 1, 0)};
~a[40] = \filter -> {|in| Compander.ar(in, ~b.ar, 0.1, slopeBelow: 0.5, slopeAbove: 0.5).distort}
~a.set(\wet30, 0.5)
~a.play


(
SynthDef(\k, {
	var freq = Env.perc(\pAtk.kr(0.1).linexp(0, 1, 0.00001, 0.1), \pRel.kr(0.1).linexp(0, 1, 0.0001, 0.1)).ar(0, \gate.kr(1), 1, \pAmt.kr(0.1).linexp(0, 1, 1, 10000), \freq.kr(50, \glide.kr(0.1)));
	var sig = SinOscFB.ar(freq, \fb.kr(0.1));
	sig = sig * Env.perc(\atk.kr(0.1).linexp(0, 1, 0.00001, 0.1), \rel.kr(0.1).linexp(0, 1, 0.0001, 1)).ar(2, \gate.kr(1));
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.8));
	Out.ar(\out.kr(0), sig);
}).add
)

~b = Pbind(\instrument, \k, \amp, 1, \rel, 1, \octave, 3, \pAtk, 0, \pRel, 0.1, \scale, Scale.phrygian, \pAmt, 1, \atk, 0, \rel, 0.8, \dur, Pbjorklund2(Pseq([3, 5], inf), Pseq([8, 12], inf))/4)

~b.play