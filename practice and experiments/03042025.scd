s.boot

(
b = Buffer.allocConsecutive(10, s, 1024).collect({|buf, i| buf.loadCollection(Env([0, (1.0!(i + 1)).rand2, 0].flatten, 1!(i + 2), (8.0!(i + 2)).rand2).discretize(512).asSignal.asWavetableNoWrap)});

c = Buffer.allocConsecutive(10, s, 1024).collect({|buf, i| buf.loadCollection(Signal.sineFill(512, 1/(1..(i+1).pow(2)).scramble).asWavetableNoWrap)});
d = Buffer.allocConsecutive(10, s, 1024).collect({|buf, i| buf.loadCollection(Signal.chebyFill(512, 1/(1..(i+1).pow(2)).scramble).asWavetableNoWrap)});
)

({
	var freq = Select.ar(LFNoise0.ar(1/16).range(0, 5), DC.ar(Scale.minor.degreeToFreq((0..5), 440, -3)));
	var lFreq = Lag.ar(freq, 4);
	var sig = SelectX.ar(
		LFNoise1.ar(0.1).range(0, 2),
		VOsc3.ar(
			LFNoise1.ar(0.1).range([b.first.bufnum, c.first.bufnum, d.first.bufnum], [b.last.bufnum, c.last.bufnum, d.last.bufnum]),
			LFNoise1.ar(0.1).exprange(lFreq - 1, lFreq + 1),
			LFNoise1.ar(0.1).exprange(lFreq - 1, lFreq + 1) * LFClipNoise.ar(2).range(3,4),
			LFNoise1.ar(0.1).exprange(lFreq - 1, lFreq + 1) * LFClipNoise.ar(1).range(5,6),
			1/3
		);
	);
	var gfreq = Select.ar(WhiteNoise.ar.range(0, 6), DC.ar(freq * (1..5)) * 32);

	sig = sig * SinOscFB.ar(4, LFNoise1.ar(0.1).range(0, 2), LFNoise1.ar(0.1)).bi2uni;
	sig = Pan2.ar(sig, LFNoise1.ar(0.1));

	sig = sig + GrainFM.ar(2, Dust.ar(10), WhiteNoise.ar.exprange(0.001, 1), gfreq, Select.ar(WhiteNoise.ar.range(0,4), gfreq * [0.5, 1, 1.5, 2, 3.5]), LFNoise1.ar(0.1).range(0, 5), WhiteNoise.ar, mul: 0.1);

	sig = sig.collect({|ch| Resonz.ar(ch, Array.exprand(5, 50, 500), Array.exprand(5, 0.1, 1)).sum}) + sig;
	XFade2.ar(NHHall.ar(sig), sig, LFNoise1.ar(0.1))
}.play
)


(x.free; x = {
	var sig = Ringz.ar(Impulse.ar(14), Array.rand(3, 500, 1500), Array.rand(3, 0.001, 0.1)).sum;
	sig = BPF.ar(sig, LFNoise1.ar(0.1).exprange(200, 2000), 0.2) * LFNoise2.ar(1).bi2uni;
	sig = Resonz.ar(sig, Array.rand(5, 20, 500), Array.rand(5, 0.1, 1));
	sig;
}.play)


(x.free; x = {
	var sig = RLPF.ar(Saw.ar(Demand.ar(Impulse.ar(4), 0, Dseq(Scale.minor.degreeToFreq(Array.rand(16, 0, 12), 440, -3), inf))), SinOscFB.ar([4,5,0.2], 0, 1/3).sum.exprange(20, 5000), 1);
	NHHall.ar(sig!2) + sig + (SinOsc.ar(Env.perc(0, 0.01).ar(0, Impulse.ar(2), levelScale: 10000, levelBias: 50)) * Env.perc.ar(0, Impulse.ar(2)));
}.play)
s.scope

	Signal.sineFill(512, 1/[1,2,3,4,5,6].scramble).plot
