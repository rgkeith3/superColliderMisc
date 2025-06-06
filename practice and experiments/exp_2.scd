s.reboot



(SynthDef(\sn, {
	var sig = WhiteNoise.ar * Env.perc(0, \noise_dec.kr(0.1)).ar;
	RandSeed.kr(1, \seed.kr(1));
	sig = SelectX.ar(\noise.kr(0.5), [Ringz.ar(sig * Env.perc(0, 0.001).ar, TScramble.kr(Array.exprand(5, 1, 10).expexp(1, 10, \freq.kr(500), \freq.kr(500) * \freq_ratio.kr(2))), TScramble.kr(Array.exprand(5, 1, 10).expexp(1, 10, 0.01, \ring_dec.kr(0.1)))).sum, sig]);
	sig = (sig * \dist.kr(5)).distort;
	sig = Limiter.ar(sig) * Env.asr(0.01, 1, 0.01).ar(2, \gate.kr(1));
	DetectSilence.ar(sig, doneAction: 2);
	sig = Pan2.ar(sig);
	Out.ar(\out.kr(0), sig);
}).load)

(SynthDef(\hh, {
	var sig = BPF.ar(WhiteNoise.ar, \freq.kr(5000), \q.kr(0.1)) * Env.perc(\atk.kr(0.01), \rel.kr(0.1)).ar(2);
	sig = Pan2.ar(sig);
	Out.ar(\out.kr(0), sig);
}).load)


ProxySpace.push
(
~h = Pbind(\instrument, \hh, \dur, Pseq([9/8, 1, 7/8, 1] * 1/16, inf), \degree, Pseq(Array.rand(4, 0, 6), inf), \octave, 10, \atk, 0, \rel, Pseq([0.1, 0.01, 0.05, 0.01], inf));

~sn = Pbind(\instrument, \sn, \dur, Pseq([3/4, 5/4], inf), \freq, 150, \freq_ratio, 5, \seed, Pseq([1, 5], inf), \dist, 50, \ring_dec, 1, \noise, 0.5, \noise_dec, 0.1)
)
~sn.stop; ~h.stop;

~out = {Limiter.ar(CompanderD.ar((~sn.ar + ~h.ar * 1), 0.5, slopeBelow: 0, slopeAbove: 1, clampTime: 0.01, relaxTime: 0.5))}

~out.play


x = Synth(\sn, [\freq, 150, \dist, 50, \freq_ratio, 2, \seed, 50.rand, \ring_dec, 0.1, \noise, 0.5, \noise_dec, 0.01])

7.83 * Array.series(10, 1)

{var sig = SinOsc.ar(LFNoise1.kr(0.5, 0.1, 7.83) * Array.series(6, 1),mul: 1/Array.series(6, 1)/2).sum!2; sig;}.play
s.scope

(x.free; x = {
	var trig = Impulse.ar(0.5), sig = RLPF.ar(Saw.ar(50), (Env.perc(1).ar(gate: trig) * SinOsc.ar(TRand.ar(1, 100, trig).floor)).linexp(-1, 1, 50, 5000), TRand.ar(trig: trig)) * Env.perc(1).ar(gate: trig);
	sig = Resonz.ar(HPF.ar(sig, 500), Array.fill(50, {LFNoise1.kr(0.01).linexp(-1, 1, 50, 5000)}), Array.fill(50, {LFNoise1.kr(0.01).linexp(-1, 1, 0.0001, 0.1)})) + (sig * 0.5);
	Splay.ar(sig);
}.play)

(x.free; x = {
	var trig = Impulse.ar(8), ctrig = CoinGate.ar(0.8, trig), tog = ToggleFF.ar(ctrig), x;
	x = Select.ar(TRand.ar(0, 3, ctrig), [Crackle.ar(TRand.ar(0.5, 1.5, trig))!2, Saw.ar(LFNoise1.kr(1!2, TExpRand.ar(1, 50, trig), TExpRand.ar(50, 5000, trig))), FreeVerb.ar(RLPF.ar(trig, TExpRand.ar(50, 5000, trig), 0.01))!2]);
	x + (Gendy3.ar(freq: 50) * tog);
}.play)

(x.free; x = {
	var trig = Impulse.ar(8);
	LPF.ar(trig, TExpRand.ar(500, 10000, trig)) + HPF.ar(PinkNoise.ar * Env.perc(0, 0.1).ar(gate: CoinGate.ar(0.1, trig)), 10000) + SinOscFB.ar(50, TRand.ar(hi: 2, trig: trig), ToggleFF.ar(CoinGate.ar(0.5!2, trig)));
}.play)





s.reboot