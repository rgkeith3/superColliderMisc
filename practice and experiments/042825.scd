s.boot
~decoder = FoaDecoderMatrix.newStereo();

(
s.options.numOutputBusChannels_(8);
s.options.outDevice_('DENON-AVAMP');
s.options.numWireBufs_(1024);
s.options.sampleRate_(48000);
s.options.memSize_(8192 * 8)
)
s.reboot
~decoder = FoaDecoderMatrix.newPanto(7);
)
(x.free; x = {
	var l, r, c, ls, rs, lrs, rrs;
	var freqs = Scale.phrygian.tuning_(\just).degreeToFreq(Array.rand(16, 0, 8), 440, 0);
	var trate = MouseY.kr(0.1, 1000, 1);
	// var trate = Demand.ar(Impulse.ar(4), 0, Dseq(freqs, inf)) * Env([1, 1, 1/256, 1/256, 1], 16, \sin).circle.ar;

	// var trate = SinOsc.ar(1/16).bi2uni.pow(4).linexp(0,1,4, 1000);
	// grain panning will decide which tone plays, like chimes arranged around you in a circle
	// it'll strike n times per second, but will always travel around the circle at the same rate
	var trig = GrainSin.ar(16, Impulse.ar(trate), LFNoise1.ar(1).exprange(0.0001, 0.01), LFNoise1.ar(0.1).exprange(20, 2000), LFSaw.ar(1/4, 1));


	var sig = Ringz.ar(trig, freqs, trate.reciprocal * LFNoise1.ar(1).exprange(0.5, 4), 0.25);
	sig = Limiter.ar(sig, 0.5);

	sig = FoaEncode.ar(sig, FoaEncoderMatrix.newPanto(16));

	// sig = FreeVerb.ar(sig, LFNoise2.ar(1).bi2uni, LFNoise2.ar(1).bi2uni, LFNoise2.ar(1).bi2uni);
	sig = CombC.ar(sig, 1/4, 1/4, LFNoise1.ar(0.2).bi2uni * 3, 0.3);

	sig = FoaDecode.ar(sig, ~decoder);

	#c, l, ls, lrs, rrs, rs, r = sig;

	[l, r, Mix(sig), c, ls, rs, lrs, rrs];
}.play)
2.pow(3)


(x.free; x = {
	var l, r, c, ls, rs, lrs, rrs;
	// cat purr
	var sig = LPF.ar(Saw.ar(25, 0.4), SinOsc.ar(0.75 /2).range(500, 800), SinOsc.ar(0.75).bi2uni);
	sig = FoaEncode.ar(sig, FoaEncoderMatrix.newDirection());
	sig = FoaRTT.ar(sig, LFSaw.ar(0.1, mul: pi));
	sig = FreeVerb.ar(sig);
	sig = FoaDecode.ar(sig, ~decoder);
	#c, l, ls, lrs, rrs, rs, r = sig;

	[l, r, Mix(sig), c, ls, rs, lrs, rrs];
}.play)


