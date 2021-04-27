(~a = {
	var sig, chain, chain2;
	sig = SoundIn.ar();

	sig = sig + LocalIn.ar(2);

	chain = FFT(LocalBuf(512!2), sig);
	chain2 = PV_BinScramble(chain, LFNoise1.kr(1).range(0,1), LFNoise1.kr(1).range(0,1));
	chain2 = PV_MagShift(chain2, 1, LFNoise1.kr(0.1).range([-20, 5],[-15, 10]));
	chain = PV_RandComb(chain, LFNoise1.kr(1).range(0, 1));
	chain = PV_MagSmooth(chain, LFNoise1.kr(1).range(0,1));
	chain = PV_RandWipe(chain, chain2, LFNoise1.kr(1).range(0, 1));

	sig = IFFT(chain);
	sig = [CombN.ar(sig[0], 0.1, 0.1), CombN.ar(sig[0], 0.05, 0.05)];

	sig = FreeVerb.ar(sig, room: 1, damp: 0.1);

	LocalOut.ar(CompanderD.ar(sig * LFNoise1.kr(1).range(0, 0.9), slopeBelow: 1, slopeAbove: 0.1));

	sig;
})

~a.play


(~vocoder = {
	var voice, voiceChain, inChain, chain, v;
	voice = SoundIn.ar()!2;

	voiceChain = FFT(LocalBuf(512!2), voice);
	inChain = FFT(LocalBuf(512!2), ~sig.ar());
	v = LFNoise1.kr(1).range(0.0001, 1);

	chain = PV_BinShift(inChain, 0.5, LFNoise1.kr(1).range(-50, 0), 1);
	chain = PV_RandComb(chain, LFNoise1.kr(1).range(0,1));
	chain = PV_SpectralEnhance(chain, 10, 0.5, 0.1);

	IFFT(chain);
})

~vocoder.play
~vocoder.set(\in, ~sig)


~sig = {Splay.ar(Saw.ar([440, 220, 660, 880]))}
~sig.stop