s.reboot
s.options.numWireBufs_(1024)

~env1 = Buffer.loadCollection(s, Env([1,0], 1, \sin).asSignal(1024));
~env2 = Buffer.loadCollection(s, Env([0, 1, 0], 1, \sin).asSignal(1024));
~env3 = Buffer.loadCollection(s, Env([0, 1], 1, \sin).asSignal(1024));

(
x.free; x = {
	var sig, room = Array.fill(20, {LFNoise1.ar(0.01).exprange(50, 10000)}), freqs = Scale.minor.tuning_(\just).degreeToFreq((-12..12), 440, 0), noise = 1;
	sig = 4.collect{
		Select.ar(TRand.ar(0, freqs.size - 1, Impulse.ar(1/16)), K2A.ar(freqs));
	};
	sig = sig.collect {|freq, i|
		FMGrainIBF.ar(
			Dust.ar(SinOsc.ar(i * 0.01).bi2uni * 50),
			LFDNoise3.ar(noise).exprange(0.001, 1),
			freq,
			LFDNoise3.ar(noise).pow(8).bi2uni + 1 * freq,
			WhiteNoise.ar.exprange(hi: 5),
			~env1,
			~env2,
			LFDNoise3.ar(noise).bi2uni,
			LFDNoise3.ar(noise, pi),
			LFDNoise3.ar(noise, 0.5pi),
			LFDNoise3.ar(noise).exprange
		);
	};
	sig = sig.sum;
	sig = CombC.ar(sig * LFDNoise3.ar(noise).bi2uni.pow(4), delaytime: Array.fill(4, {LFDNoise3.ar(0.1, 10, freqs.choose)}).reciprocal*2, decaytime: 1) + sig;
	sig = sig.collect{|chan| Resonz.ar(chan, room, LFNoise2.ar(1).exprange, room.size.reciprocal).sum};
	sig = FoaDecode.ar(sig, FoaDecoderMatrix.newStereo);
	sig;
}.play;

y.free; y = {
	var trig = Impulse.ar(8);
	var freqs = Scale.minor.tuning_(\just).degreeToFreq((0..6), 440, -4);
	var freq = Select.ar(TRand.ar(0, freqs.size - 1, Impulse.ar(1/16)), K2A.ar(freqs));
	GrainFM.ar(2, trig, LFNoise2.ar(0.1).exprange(lo: 0.001, hi: 0.1), freq, freq * WhiteNoise.ar.exprange(lo: 2, hi: 16), 100, WhiteNoise.ar) +
	Pan2.ar(SinOscFB.ar(freq, Select.ar(TRand.ar(trig: trig) > 0.9, [LFNoise2.ar(0.1).exprange(lo: 0.5, hi: 3), DC.ar(10)]), ToggleFF.ar(CoinGate.ar(0.5, trig))), TRand.ar(-1, trig: trig));
};
)


