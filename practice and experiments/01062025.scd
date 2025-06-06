s.options.numInputBusChannels_(0)
ServerOptions.outDevices
s.options.outDevice_('Galaxy Buds FE')
s.options.outDevice_('MacBook Pro Speakers')
s.reboot

(x.free; x = {
	var sig = SinOsc.ar(100);
	sig;
}.play)
(
SynthDef(\sin, {
	var sig = SinOscFB.ar(\freq.kr(440), Env.perc(1).ar(0, 1) * 2, 0.5) * Env.adsr(0.5, 0.1, releaseTime: 0.3).ar(2, \gate.kr(1));
	sig = Pan2.ar(sig, \pan.kr(0));
	Out.ar(0, sig);
}).load
)

Tuning.et31.ratios
(
var phrase = [Array.rand(8, 0, 15) * 2, Array.rand(8, 1, 4).normalizeSum * 2].flop;
var playPhrase = {|mod=0, dMod=1, pan=0|
	loop {
		phrase.do {|e|
			var degree = e[0] + mod;
			var freq = ~scale.degreeToFreq(degree, 440, 0);
			var dur = e[1] * dMod;
			fork {
				var synth = Synth(\gamelan, [\freq, freq, \pan, pan]);
				(dur * 3).wait;
				synth.set(\gate, 0);
			};
			dur.wait;
		};
	};
};

Routine({
	// var num = 3;
	num.do {|n|
		fork {
			playPhrase.value(5.rand2, 1.rrand(4), n.linlin(0, num, -1, 1));
		};
	};
}).play)

~scale = Scale.pelog
5.rand2
1.rrand(4)
~scale = Scale.new([0, 5, 10, 13, 18, 23, 28, 30, 4, 9, 12, 17, 22, 27], 31, \et31)

~harms = [];
(Routine({
	var events = [Array.rand(8, 0, 5), Array.rand(8, 1, 4).normalizeSum * 4].flop;
	var harms = Array.rand(4, -3, 8);
	loop {
		harms.do { |harm|
			var freqs = Scale.pelog.degreeToFreq(harm, 440, [-1, -2, 0]);
			~harms.collect(_.set(\gate, 0));
			~harms = freqs.collect {|freq| Synth(\sin, [\freq, freq])};
			2.do {
				events.do{|event|
					var degree = event[0];
					var dur = event[1];
					x = Synth(\gamelan, [\freq, Scale.pelog.degreeToFreq(degree, 440, 1)]);
					dur.wait;
					x.set(\gate, 0);
				}
			}
		};
	};
}).play)



(x.free; x = {
	var freqs = Scale.majorPentatonic.degreeToFreq((-3..8), 440, -1);
	var freq1 = Lag.ar(Demand.ar(Impulse.ar(0.4), 0, Drand(freqs, inf)), 0.2);
	var freq2 = Lag.ar(Demand.ar(Impulse.ar(0.4), 0, Drand(freqs * 2, inf)), 0.2);
	var sig = DWGBowed.ar([freq1, freq2] + SinOsc.ar(LFNoise1.ar(0.2!2).exprange(8, 12), mul: LFNoise1.ar(1).bi2uni * 3), LFNoise1.ar(1).bi2uni, LFNoise2.ar(1).bi2uni, pos: LFNoise2.ar(1).bi2uni) * 0.2;
	sig = DWGSoundBoard.ar(sig);
	sig = FreeVerb.ar(sig, 1, 1, 1);
}.play)



(x.free; x = {
	var cello, celloFreq, bass, bassFreq, midHiFreq, midHi, hi, sig;
	bassFreq = 100;
	bass = SinOscFB.ar(bassFreq, LFNoise2.ar(1).exprange(1, 2));
	celloFreq = 200;
	cello = DWGBowed.ar(celloFreq + SinOsc.ar(LFNoise1.ar(0.2).exprange(8, 16), mul: LFNoise1.ar(1).bi2uni * 5), LFNoise1.ar(1).bi2uni, LFNoise2.ar(1).bi2uni, pos: LFNoise2.ar(1).bi2uni) * 0.2;
	cello = DWGSoundBoard.ar(cello);
	midHiFreq = 400 * Select.ar(WhiteNoise.ar.range(0,4), DC.ar([1, 2, 3, 1.5]));
	midHi = GrainFM.ar(1, Dust.ar(15), 0.1, midHiFreq, midHiFreq * 1.5, WhiteNoise.ar.range(1, 5));
	hi = GrainFM.ar(1, Dust.ar(15), 0.1, 400 * 64, 400 * 128, 1);
	sig = (hi * LFNoise2.ar(0.1).bi2uni) + (midHi * LFNoise2.ar(0.1).bi2uni) + (cello * LFNoise2.ar(0.1).bi2uni) + (bass * LFNoise2.ar(0.1).bi2uni);
	FreeVerb.ar(sig);
}.play)



(
SynthDef(\gamelan, {
	var n = 8;
	var sig = Ringz.ar(Impulse.ar(0), Array.exprand(n, 1, 128).sort * \freq.kr(150), Array.exprand(n, 0.1, 10).sort.reverse, 1/n).sum;
	sig = sig * Env.asr(0, 1, 0.1).ar(2, \gate.kr(1));
	DetectSilence.ar(sig, doneAction: 2);
	Out.ar(\out.kr(0), Pan2.ar(sig, \pan.kr(0)));
}).load;
)

(x.free; x = {Ringz.ar(Impulse.ar(0), ExpRand(1, 128!8) * 150, ExpRand(0.01, 1!8), 1/8).sum}.play)

(Routine({
	var events = [Array.rand(8, 0, 16), Array.rand(8, 1, 4).normalizeSum].flop;
	loop {
		events.do {|ev|
			var freq = Scale.pelog.degreeToFreq(ev[0], 440, -2);
			var synth = Synth(\gamelan, [\freq, freq]);
			ev[1].wait;
			synth.set(\gate, 0);
		};
	};
}).play
)

(x.free; x= {
	var mod = SinGrain.ar(Dust.ar(50), WhiteNoise.ar.range(0, 1), 0.01);
	SinOsc.ar(mod.linexp(-10, 10, 50, 10000));
}.play)


(x.free; x = {
	var sig = FMGrainBF.ar(
		Impulse.ar(LFNoise1.ar(1, 5, 10)),
		0.001,
		XLine.ar(50, 5000, 10) + WhiteNoise.ar(50),
		// Line.ar(100, 10000, 10),
		10000,
		WhiteNoise.ar.range(0, XLine.ar(1, 10, 10)),
		WhiteNoise.ar(pi),
		Line.ar(-0.5pi, 0.5pi, 10),
		WhiteNoise.ar.abs
	);
	var hi = HPF.ar(sig, 1000);
	var lo = LPF.ar(sig, 1000);
	var mod = LFNoise1.ar(1).exprange(50, 5000);
	sig = CombN.ar(hi, 1, 50.reciprocal, 1) + lo;
	10.do {
		sig = BAllPass.ar(sig, mod, 0.1);
	};
	sig = FreeVerb.ar(sig, 1, LFNoise1.ar(5).abs, LFNoise1.ar(5).abs) + sig;
	FoaDecode.ar(sig, FoaDecoderMatrix.newStereo);
}.play)

s.scope

400 * 16

(
var bus = Bus.control(s);
bus.getSynchronous();
)

