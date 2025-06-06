s.boot
// good stuff in here

({
	var freq, sig, num=8;

	freq = num.collect({
		Demand.kr(Impulse.kr(8.reciprocal), 0, Drand(Scale.major.degreeToFreq((0..21), 60, 1), inf));
	});
	sig = DWGBowed.ar(Lag2.kr(freq, 0.1), velb: LFTri.kr(LFNoise1.kr(0.5!num, LFNoise1.kr(0.5!num).range(0, 8), 8)).linexp(-1, 1, LFNoise1.kr(0.5!num).range(0.0000001, 0.05), 1), force: LFNoise1.kr(0.5!num).range(0.1, 2)) * 0.1;
	// sig = Pan2.ar(sig, LFNoise1.kr(1!4));
	// sig = sig.sum;
	sig = Splay.ar(sig);
	sig = DWGSoundBoard.ar(sig);
    sig = LPF.ar(sig,6000);
	sig = FreeVerb.ar(sig, 0.33, 1, 0.5);
}.play)
s.boot
~decoder = FoaDecoderKernel.newSpherical
({
	var freq, sig, num=4;

	num.collect({
		var sig, dist, ddist, distGain, vel, ofreq, freqs, noteDur, chain;
		dist = LFDNoise1.kr(LFNoise1.kr(1).linexp(-1, 1, 0.1, 5)).bi2uni;
		ddist = DelayN.kr(dist, ControlDur.ir, ControlDur.ir);
		vel = (dist - ddist)/ControlDur.ir;
		ofreq = (343.2/(343.2 + (vel))).pow(3);

		freqs = Scale.major.degreeToFreq((0..21), 60, 1);
		noteDur = LFDNoise1.kr(LFNoise1.kr(1).linexp(-1, 1, 0.1, 5)).linexp(-1,1,1, 10);
		freqs = Demand.kr(Impulse.kr(noteDur), 0, Drand(freqs, inf));
		sig = DWGBowed.ar(ofreq * Lag.kr(freqs, 0.01) + LFTri.kr(8, mul: noteDur.reciprocal * 5), velb: LFTri.kr(noteDur * 2).bi2uni, force: LFNoise1.kr(0.5).range(0.1, 2)) * 0.1;
		sig = DWGSoundBoard.ar(sig);
		sig = LPF.ar(sig,6000);
		sig = FoaEncode.ar(sig, FoaEncoderMatrix.newOmni);
		sig = FoaFocus.ar(sig, pi/2, LFNoise1.kr(0.5).range(-pi, pi), LFNoise1.kr(0.5).range(-pi/2, pi/2));
		distGain = (0 - (20 * log(dist.linexp(0,1, 1, 100)/1))) * 0.1;
		sig = FoaProximity.ar(sig, dist.linexp(0,1, 1, 100), distGain.dbamp);
		chain = FFT(LocalBuf(2048!4), sig, 0.2);
		RandSeed.ir;
		chain = PV_RandComb(chain, MouseY.kr);
		chain = PV_MagSmooth(chain, MouseX.kr);
		sig = IFFT(chain) * MouseY.kr(1, 2);
		sig = FreeVerb.ar(sig, (distGain.dbamp * -1 + 1) * 0.5, 0.5, 0);
		sig = FoaDecode.ar(sig, ~decoder);
	}).sum;
}.play)

({
	var freq, sig, num=4;

	num.collect({
		var sig, dist, ddist, distGain, vel, ofreq, freqs, noteDur;
		dist = LFDNoise1.kr(LFNoise1.kr(1).linexp(-1, 1, 0.1, 5)).bi2uni;
		ddist = DelayN.kr(dist, ControlDur.ir, ControlDur.ir);
		vel = (dist - ddist)/ControlDur.ir;
		ofreq = (343.2/(343.2 + (vel))).pow(3);

		freqs = Scale.major.degreeToFreq((0..21), 60, 1);
		noteDur = LFDNoise1.kr(LFNoise1.kr(1).linexp(-1, 1, 0.1, 5)).linexp(-1,1,1, 32);
		freqs = Demand.kr(Impulse.kr(noteDur), 0, Drand(freqs, inf));
		sig = DWGPlucked.ar(ofreq.pow(1/3) * Lag.kr(freqs, 0.01), inp: PinkNoise.ar * Env.perc(0, 0.01).ar(gate: Impulse.kr(noteDur))) * 0.1;
		sig = DWGSoundBoard.ar(sig);
		sig = LPF.ar(sig,6000);
		sig = FoaEncode.ar(sig, FoaEncoderMatrix.newOmni);
		sig = FoaFocus.ar(sig, pi/2, LFNoise1.kr(0.5).range(-pi, pi), LFNoise1.kr(0.5).range(-pi/2, pi/2));
		distGain = (0 - (20 * log(dist.linexp(0,1, 1, 100)/1))) * 0.5;
		sig = FoaProximity.ar(sig, dist.linexp(0,1, 1, 100), distGain.dbamp);
		sig = FreeVerb.ar(sig, (distGain.dbamp * -1 + 1) * 0.5, 0.5, 0);
		sig = FoaDecode.ar(sig, ~decoder);
	}).sum;
}.play)

({
	var sig, n;
	n = 8;
	sig = DWGBowed.ar(SawDPW.kr(0.1!n, Rand(0, 2pi!n)).linexp(-0.5, 0.5, 5000, 100), LFTri.kr(8).bi2uni, LFNoise1.kr(0.5).bi2uni) * n.reciprocal;
	sig = DWGSoundBoard.ar(sig);
	sig = Splay.ar(sig);
	sig = FreeVerb.ar(sig);
	sig;
}.play)


s.boot