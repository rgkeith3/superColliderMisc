s.reboot
ServerOptions.outDevices
s.options.outDevice_('DENON-AVAMP');
s.options.numOutputBusChannels_(8)
s.options.memSize_(2.pow(17))
s.options.numWireBufs_(1024)
2.pow(13)
(x.free; x = {
	RandSeed.ir(1, 2);
	Ringz.ar(Dust.ar(50), TExpRand.ar(20!20, 20000, 1), TExpRand.ar(0.001!20, 0.1, 1)).sum!2;
}.play)

(x.free; x = {|t_trig=1, seed=1|
	RandSeed.kr(t_trig, seed);
	Ringz.ar(GrainIn.ar(20, Dust.ar(50), 0.0001, K2A.ar(1), WhiteNoise.ar), TExpRand.ar(20!20, 20000, t_trig), TExpRand.ar(0.001!20, 0.1, t_trig)).sum!2
}.play)


// grain network that modulates to different states periodically
(
~env1 = Buffer.loadCollection(s, Env.perc.discretize);
~env2 = Buffer.loadCollection(s, Env.sine.discretize);
)
(
x.free; x = {
	var noise, tick, sig, notes, env, chanL, chanR, chanC, chanLS, chanRS, chanLRS, chanRRS, chan, freqs;
	noise = Env([0, 100], 8 * 16).ar;
	tick = Impulse.ar(8);
	env = Env.perc(5, 0, curve: 8).ar(0, PulseDivider.ar(tick, 8 * 16));
	// env = MouseY.kr(0, 1);
	notes = Scale.minor.tuning_(\just).degreeToFreq((0..15).scramble[0..3], 50, 1);
	notes = K2A.ar(notes);
	notes = Select.ar(LFDNoise0.ar(env * noise).range(0, notes.size), notes);
	sig = FMGrainIBF.ar(
		Impulse.ar(LFDNoise3.ar(env * noise).linexp(-1, 1, 1, 50)),
		LFDNoise3.ar(env * noise).linexp(-1, 1, 0.001, 1),
		notes,
		notes * Select.ar(LFDNoise0.ar(env * noise).range(0, 4), K2A.ar([1, 1.5, 2, 3, 4])),
		LFDNoise3.ar(env * noise).range(0, 10),
		~env1,
		~env2,
		LFDNoise3.ar(env * noise).range(0,1),
		LFDNoise3.ar(env * noise).range(pi, -pi),
		LFDNoise3.ar(env * noise).range(0.5pi, -0.5pi),
		LFDNoise3.ar(env * noise).linexp(-1, 1, 5, 0.5)
	);
	// sig = FoaRTT.ar(sig, LFDNoise3.kr(env * noise), LFDNoise3.kr(env * noise), LFDNoise3.kr(env * noise));
	sig = FoaDecode.ar(sig, FoaDecoderMatrix.newBtoA);
	sig = CombC.ar(sig, 4, LFDNoise3.ar(env * noise!4).linexp(-1, 1, 0.001, 4), LFDNoise3.ar(env * noise!4).linexp(-1, 1, 0.01, 1)) + sig;
	sig = sig.collect{|i|
		Resonz.ar(i, LFDNoise3.ar(env * noise!20).linexp(-1, 1, 20, 20000), LFDNoise3.ar(env * noise!20).linexp(-1, 1, 0.001, 1)).sum + i;
	};
	// sig = FreeVerb.ar(sig, LFDNoise3.ar(env!4).bi2uni, LFDNoise3.ar(env!4).bi2uni, LFDNoise3.ar(env!4).bi2uni);
	sig = FoaEncode.ar(sig, FoaEncoderMatrix.newAtoB);

	sig = AmbiVerbSC.ar(sig, LFDNoise3.kr(env * 5).bi2uni, lowRT: LFDNoise3.kr(env * 5).linexp(-1,1, 1, 10), highRT: LFDNoise3.kr(env * 5).linexp(-1,1, 1, 10), dispersion: LFDNoise3.kr(env * 5).bi2uni);
	sig = FoaDecode.ar(sig, FoaDecoderMatrix.newStereo);
	// sig = sig + CombN.ar(Pan2.ar(tick, TRand.ar(-1, trig: tick)), delaytime: [0, 0.01], decaytime: 0);
	// chan = FoaDecode.ar(sig, FoaDecoderMatrix.newPanto(7));
	// # chanC, chanL, chanLS, chanLRS, chanRRS, chanRS, chanR = chan;
	// sig = [chanL, chanR, Mix(LPF.ar(chan, 120)),chanC, chanLS, chanRS, chanLRS, chanRRS];
	// sig = sig.distort * 0.2;
}.play)

(x.free; x = {
	var sig = Saw.ar(50) * SinOsc.ar(SinOsc.ar(2/3).pow(1/2).range(5, 10)).range(0,1);
	sig = sig * 0.5;
	sig = FoaPanB.ar(sig, LFNoise1.kr(1, pi), LFNoise1.kr(1, 0.5pi));
	sig = FoaDecode.ar(sig, FoaDecoderMatrix.newBtoA);
	sig = RLPF.ar(sig, LFNoise1.kr(1!4).linexp(-1, 1, 50, 10000), LFNoise1.ar(1!4).bi2uni);
	sig = FreeVerb.ar(sig, LFNoise1.kr(0.1).bi2uni, 0.1, 0.1);
	sig = FoaEncode.ar(sig, FoaEncoderMatrix.newAtoB);
	FoaDecode.ar(sig, FoaDecoderMatrix.newStereo);
}.play)
0.3.pow(1/2)
