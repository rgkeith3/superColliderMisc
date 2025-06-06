s.reboot


(
PathName(Platform.userHomeDir() ++ "/projects/RaveNN").entries.do {|entry|
	NN.load(entry.fileNameWithoutExtension, entry.fullPath);
}
)
NN.models.at(5)
// latent pattern w/ vari speed
(x.free; x = {
		var sig, speed, cep, cep2, chain,cchain, car, numInputs, mod, key, freq, hasFreq;
	key = NN.models.at(2).key.postln;
	numInputs = NN.model(key).method(\decode).numInputs;
	speed = (2048/s.sampleRate).reciprocal.postln;
	mod = numInputs.collect {|i|
		var vals = Array.rand(speed.asInteger * 4, -2.0, 2.0);
		Lag.ar(Demand.ar(Impulse.ar(speed), 0, Dseq(vals, inf)), MouseY.kr(1, speed).reciprocal);
		};
	mod = LFDNoise3.ar(LFDNoise3.ar(LFNoise2.ar(1.dup(numInputs)).linexp(-1, 1, 0.01, 1000)).linexp(-1, 1, 0.01, 1000), 2);
	sig = NN(key, \decode).ar(mod);

	sig = CompanderD.ar(sig, slopeBelow: 0.1, slopeAbove: 0.1);

	sig = Splay.ar(PitchShift.ar(sig, 1, LFNoise2.ar(1!4).exprange(1/2, 2), timeDispersion: 1));
	sig;
}.play)

(x.free; x = {
		var sig, in, mod, numInputs, key = NN.models.at(2).key.postln;
	numInputs = NN.model(key).method(\decode).numInputs;
	in = LocalIn.ar(2);
	mod = K2A.ar(MFCC.kr(Cepstrum(LocalBuf(512!2), FFT(LocalBuf(1024!2), in)), numInputs).linlin(0,1, -2, 2));
	sig = [NN(key, \decode).ar(mod[1]), NN(key, \decode).ar(mod[0])];

	sig = CompanderD.ar(sig, slopeBelow: 0.3, slopeAbove: 0.3);
	LocalOut.ar(sig);

	sig;
}.play)

// diverge latent walks per channel
(
x.free; x = {
	var key, mod1 = [], mod2 = [], numInputs;
	key = NN.models.at(8).key.postln;
	numInputs = NN.model(key).method(\decode).numInputs;
	numInputs.collect({|i|
		var modMix = Splay.ar(LFNoise1.ar(23.4375!2, 3), MouseY.kr);
		mod1 = mod1.add(modMix[0]); mod2 = mod2.add(modMix[1]);
	});
	[NN(key, \decode).ar(mod1), NN(key,\decode).ar(mod2)].collect({|i|
		Resonz.ar(i, Array.exprand(25, 50, 5000), Array.exprand(25, 0.001, 0.1)).sum;
		i
	});
}.play
)

// latent pattern with 1 manual latent

(x.free; x = {
	var key = NN.models.at(3).key;
	var numInputs = NN(key, \decode).numInputs;
	var mod = numInputs.collect {|i|
		var vals = Array.rand(16, -3.0, 3.0);
		Lag.ar(Demand.ar(Impulse.ar(165/60 * 2), 0, Dseq(vals, inf)), 1 / 2);
	};
	// mod = mod + PanAz.ar(mod.size, LFNoise1.ar(0.25, 3), LFNoise1.kr(0.25), width: LFNoise1.kr(0.25).range(1, mod.size));
	mod = mod + PanAz.ar(mod.size, K2A.ar(MouseY.kr(-3, 3)), MouseX.kr(-1, 1), width: mod.size / 2);
	NN(key, \decode).ar(mod) + Impulse.ar(165/60);
}.play)

(2048/s.sampleRate).reciprocal



// latent exploration with modulatable breadth

	(x.free; x = {
		var chain1, chain2, sig, n = 9;
	sig = NN(NN.models.at(n).key, \encode).ar(SoundIn.ar);
	sig = LFDNoise3.ar(PanAz.ar(16, K2A.ar((2048/s.sampleRate).reciprocal), MouseX.kr(-1, 1), width: MouseY.kr(1, 18, 1)), 3);
	// sig = PanAz.ar(16, K2A.ar(-2), MouseX.kr(-1, 1), width: MouseY.kr(1, 16, 1));
		sig = NN(NN.models.at(n).key.postln, \decode).ar(sig) * 2;
		sig = Resonz.ar(sig, Array.exprand(25, 50, 10000), Array.exprand(25, 0.001, 0.1).sort).sum + sig;
		sig;
	}.play)

	(x.free; x = {
		var sig = NN(NN.models.at(9).key, \prior).ar(LFNoise1.ar(100));
		sig;
	}.play)

	NN.models.at(4).describe
	(2048/s.sampleRate).reciprocal

	s.options.blockSize_(512)
	s.options.hardwareBufferSize_(2048);


10.linexp(0, 18, 1/8, 23)