s.reboot



(SynthDef(\drop, {
	var time = \time.kr(0.01);
	var sig = WhiteNoise.ar(0.1) * Env.perc(0, 0.001).ar(gate: 1) + SinOsc.ar(XLine.ar(\start.kr(400), \end.kr(5000), time)) * Env.perc(0, time).ar(2, 1);
	sig = LPF.ar(sig, \lpf.kr(400));
	sig = HPF.ar(sig, \hpf.kr(50));
	Out.ar(\out.kr(0), Pan2.ar(sig, \pan.kr(0)));
}).load)


// start with random rain drops
// extend the env release
// make the random rain drops conform to a scale
(x.free; x = {
	var time = 0.1;
	var freqs = Scale.major.degreeToFreq([0,2,4,6], 440, 3);
	// var freqs = Array.rand(4, 2000, 5000);
	var sigs = WhiteNoise.ar(0.1) * Env.perc(0, 0.001).ar(gate: 1) + SinOsc.ar(XLine.ar(freqs / 8, freqs, time)) * Env.perc(0, time * 8).ar(0, 1);
	sigs = DelayN.ar(sigs, delaytime: Rand(0, 0.2!4)).sum;
	DetectSilence.ar(sigs);
	sigs;
}.play)

(
var rainloop = {|dropSize=0.01, low=200, high=2000, dens=0.1|
	loop {
		Synth(\drop, [\time, dropSize.rrand(0.03), \start, low.rrand(low * 2), \end, high.rrand(high * 2), \pan, 1.0.rand2]);
		dens.rand.wait;
	};
};

Routine({
	fork {
		rainloop.value(0.1, 50, 10000, 0.5);
	};
	fork {
		rainloop.value(0.1, 500, 5000, 0.1);
	}
}).play
)




(SynthDef(\three, {
	var detune = \detune.kr(0.01);
	var sig = Saw.ar(\freq.kr(440, \glide.kr(0.1)) * [detune.linexp(0, 1, 1, 0.75), 1, detune.linexp(0, 1, 1, 1.5)], 1/3).sum;
	var env = Env.adsr(\atk.kr(0.01), \dec.kr(0.01), \sus.kr(0.5), \rel.kr(1));
	sig = RLPF.ar(sig, SelectX.ar(\filtEnv.kr(0), [DC.ar(1), env.ar(0, \gate.kr(1))]) * \filtFreq.kr(2000), \q.kr(0.1), \dist.kr(0) + 1).tanh;
	sig = sig * env.ar(2, \gate.kr(1));
	Out.ar(\out.kr(0), Pan2.ar(sig, \pan.kr(0, 0.1)));
}).load;)

p = ProxySpace.push(s);
p.makeTempoClock
(~a = PmonoArtic(
		\three,
		\dur, 1/4,
		\atk, 0.01,
		\rel, 0.1,
		\detune, 0.05,
	\legato, Pdef(\legato, Pseq(Array.fill(12, {if (0.5.coin,{1}, {0.75})}), inf)),
	\degree, Pdef(\deg, Pseq(Array.rand(16, -6, 6), inf)),
	\octave, Pdef(\octave, Pseq(Array.rand(8, 4, 5), inf)),
		\filtEnv, 0.5,
		\filtFreq, Ndef(\lfo, {SinOsc.ar(0.1).range(1000, 10000)}),
		\scale, Scale.major,
		\q, 0.01,
		\dist, 10,
		\pan, Pwhite(-1.0)
)
)
~a.stop
(
~t = Task({
	~which = {Env([0, 1], 16).ar(2, 1)};
	(~tempo.asBus.getSynchronous.reciprocal * 16).wait;
	Pdef(\legato, Pseq(Array.fill(12, {if (0.5.coin,{1}, {0.75})}), inf));
	Pdef(\deg, Pseq(Array.rand(16, -6, 6), inf));
	Pdef(\octave, Pseq(Array.rand(8, 4, 5), inf));
}, p.clock);
)
~t.play
p.clock
~a.play
~a[10] = nil
~a[10] = \filter -> {|in| SelectX.ar(~which.ar, [in, FreeVerb.ar(in, 1, 1, 0)])}
~a[20] = \filter -> {|in| Compander.ar(in, ~k.ar, 1, 0.1, 2, relaxTime: 0.1)}

(
~c = Pbind(
	\instrument, \three,
	\dur, 0.25,
	\dist, 100,
	\filtFreq, 1000,
	\q, 0.1,
	\degree, Pseq([3, \, \], inf),
	\scale, Scale.pelog,
	\octave, 5
)
)
~c.play
~c.stop
(
~b = {
	var clock = Impulse.ar(~tempo.kr.reciprocal * 2);
	var sig = SinOscFB.ar(Env.perc(0, 0.05).ar(0, clock).linexp(0, 1, 50, 10000), Env.perc(0, 0.1).ar(0, clock).linexp(0, 1, 0, 1000)) * Env.perc(0, 0.5).ar(0, clock);
	sig = (sig * 20).tanh;
	sig!2
}
)
~b.play
~b.stop

(
SynthDef(\k, {
	var sig = SinOscFB.ar(Env.perc(0, 0.05).ar(0, 1).linexp(0,1,50, 50000), Env.perc(0, 05).ar);
	Out.ar(\out.kr, sig);
}).load
)

(
~drums = {
	MiGrids.ar(1, ~tempo.kr * 60, LFNoise0.kr(~tempo.kr.reciprocal * 4).bi2uni, LFNoise0.kr(~tempo.kr.reciprocal * 4).bi2uni, MouseY.kr, LFNoise1.kr(~tempo.kr.reciprocal * 4).bi2uni, LFNoise1.kr(~tempo.kr.reciprocal * 4).bi2uni, LFNoise1.kr(~tempo.kr.reciprocal * 4).bi2uni, ~clock.ar(1, 8), ext_clock: 1).flatten
};

~k = {
	var trig = ~drums.ar(1, 0);
	var accent = ~drums.ar(1, 3);
	var sig = SinOscFB.ar(
		Env.perc(0, 0.05).ar(0, trig + accent).linexp(0,1, 50, 10000),
		Env.perc(0.1, 0.1, 1, -4).ar(0, trig + accent, levelScale: 500, levelBias: 0),
		Env.perc(0, 0.1).ar(0, trig) + Env.perc(0, 1).ar(0, accent));
	Out.ar(\out.kr(0), Pan2.ar(sig, TRand.ar(-1, trig: trig + accent)));
};
~k.play;

~s = {
	var trig = ~drums.ar(1, 1);
	var accent = ~drums.ar(1, 4);
	var sig = [Ringz.ar(trig, Array.exprand(10, 500, 1000).sort, Array.exprand(10, 0.01, 1).sort.reverse, 1/20).sum, Ringz.ar(accent, Array.exprand(10, 1000, 2000).sort, Array.exprand(10, 0.01, 1).sort.reverse, 1/20).sum];
	Out.ar(\out.kr(0), sig);
};
~s.play;

~h = {
	var trig = ~drums.ar(1, 2);
	var accent = ~drums.ar(1, 5);
	var sig = WhiteNoise.ar + Ringz.ar(trig + accent, Rand(5000, 10000));
	sig = [sig, sig] * [Env.perc(0, 0.01).ar(0, trig), Env.perc(0, 0.1).ar(0, accent)];
	Out.ar(\out.kr(0), sig);
};
~h.play;
)

~clock = {Impulse.ar(~tempo.kr * [1, 2, 3,4, 5, 6, 7, 8, 16, 32])}
~clock.mold(10)

(
~c[0] = {
	var chordGate = CoinGate.ar(0.5, ~clock.ar(1, 0));
	var chordTrigger = CoinGate.ar(0.5, chordGate);
	var chords = DC.ar(Array.fill(6, {Scale.major.degreeToFreq(Array.rand(5, -6, 6), 440, 0)}));
	chordGate = ToggleFF.ar(chordGate);
	chords = Lag.ar(Select.ar(TRand.ar(0, chords.size - 1, chordTrigger), chords), 0.5);
	chords = SinOscFB.ar(chords, LFNoise1.ar(0.1).bi2uni.linexp(0, 1, 0.01, 10), 1/4) * Env.asr.ar(0, chordGate);
	Out.ar(\out.kr(0), Splay.ar(chords));
};
~c[1] = \filter -> {|in| Compander.ar((in * 5).distort, ~k.ar, 0.1, slopeAbove: 0.2)}
)

~c.play
(~b[0] = {
	var arp = Demand.ar(~clock.ar(1, 3), 0, Dseq(Scale.minor.degreeToFreq(Array.rand(16, -6, 12), 440, -3), inf));
	var sig = Saw.ar(Lag.ar(arp));
	sig = sig * Env.perc.ar(0, CoinGate.ar(0.8, ~clock.ar(1, 1)));
	sig = RLPF.ar(sig, LFNoise2.ar(0.1).linexp(-1, 0, 50, 5000), 0.1);
	Out.ar(\out.kr(0), Pan2.ar(sig, LFNoise2.ar(0.1)));
})
~b.play
~k.play;~s.play;~h.play;~c.play;
~k.stop;~s.stop;~h.stop;~c.stop;
~out[0] = ~k + ~s + ~h;
~out[1] = \filter -> {|in| CompanderD.ar(FreeVerb.ar(in, room: 0.5, damp: 1), 0.5, slopeBelow: 0.1, slopeAbove: 0.1, mul: 1).tanh + ~c.ar}
~out.play

~tempo = {180/60}
~tempo.asBus.getSynchronous

~drums.scope
~k.play

~drums


