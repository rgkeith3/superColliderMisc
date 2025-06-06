s.reboot
s.options.memSize_(8192 * 4)
~decoder = FoaDecoderKernel.newListen()

~decoder = FoaDecoderMatrix.newPanto(7);
// a wave of excitation passes over you


~envBuf = Buffer.loadCollection(s, Env.perc.discretize);
(
x.free; x = {
	var l, r, c, ls, rs, lrs, rrs;
	var point = Cartesian(WhiteNoise.ar, LFSaw.ar(MouseY.kr(0.1, 100, 1), pi, mul: 10), WhiteNoise.ar);
	// dust rate affects density
	// var sig = InGrainBF.ar(Dust.ar(100), 0.001, DC.ar(1), point.theta, point.phi, point.rho);
	var sinFreqs = Select.ar(WhiteNoise.ar.range(0, 4), DC.ar(Scale.phrygian.tuning_(\just).degreeToFreq((0..8).scramble[0..3], 440, 0)));
	var sig = FMGrainBBF.ar(Dust.ar(100), WhiteNoise.ar.exprange(0.0001, MouseX.kr(0.0005, 2, 1)), sinFreqs, sinFreqs * Select.ar(WhiteNoise.ar.range(0, 3), DC.ar([1, 2/3, 3/4, 4/5])), WhiteNoise.ar.exprange(0.01, 200), ~envBuf, point.theta, point.phi, point.rho);
	var freqs = Array.exprand(5, 20, 10000).sort.postln;
	var decs = Array.exprand(5, 0.01, 0.1).sort.reverse;
	sig = sig.collect{|ch| Resonz.ar(ch, freqs, decs, 5).sum} + sig;

	// sig = AmbiVerbSC.ar(sig, 0.2, lowRT: 1, highRT: 1, dispersion: 0.5);
	sig = FoaDecode.ar(sig, FoaDecoderMatrix.newBtoA());
	sig = FreeVerb.ar(sig, room: 1, damp: 0);
	sig = FoaEncode.ar(sig, FoaEncoderMatrix.newAtoB());


	sig = FoaDecode.ar(sig, ~decoder, 0.1);

	// #c, l, ls, lrs, rrs, rs, r = sig;

	// [l, r, Mix(sig), c, ls, rs, lrs, rrs];
}.play)
