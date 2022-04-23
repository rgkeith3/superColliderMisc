// ambisonics on 7_1

({
	var sig, foa, out, c, fr, sr, srr, fl, sl, srl;
	sig = Saw.ar(50);

	foa = FoaEncode.ar(sig, FoaEncoderMatrix.newOmni);
	foa = FoaFocus.ar(foa, pi/2, SawDPW.kr(MouseY.kr(0.1, 5), mul: 2).range(-pi, pi), SawDPW.kr(MouseX.kr(0.1, 5), mul: 2).range(-pi/2, pi/2));
	foa = FoaProximity.ar(HPF.ar(foa, 150), LFNoise1.kr(1).range(0.01, 1));
	foa = FreeVerb.ar(foa, room: 10, damp: 1);
	// # c, fl, sl, srl, srr, sr, fr = FoaDecode.ar(foa, FoaDecoderMatrix.newPanto(7, k: 1));
	// [fr, fl, c, Mix([c,fl, sl, srl, srr, sr, fr] * 0.5), sl, sr, srl, srr];

	FoaDecode.ar(foa, FoaDecoderMatrix.newStereo);
}.play)
s.scope

// cartesian space exp
({
	var sig, foa, out, c, fr, sr, srr, fl, sl, srl, pos;
	sig = Saw.ar(50);
	pos = Cartesian(x: MouseX.kr(-10, 10), y: MouseY.kr(-10, 10), z: 0).asSpherical;

	pos.rho.poll;
	foa = FoaEncode.ar(sig, FoaEncoderMatrix.newOmni);
	foa = FoaFocus.ar(foa, pi/2, pos.theta, pos.phi);
	foa = FoaProximity.ar(HPF.ar(foa, 150), pos.rho);
	// foa = FreeVerb.ar(foa, room: 1);
	# c, fl, sl, srl, srr, sr, fr = FoaDecode.ar(foa, FoaDecoderMatrix.newPanto(7, k: 1));
	[fr, fl, c, Mix([c,fl, sl, srl, srr, sr, fr] * 0.5), sl, sr, srl, srr];
}.play)

(~a = {
	var sig, foa, out, c, fr, sr, srr, fl, sl, srl, pos;
	sig = Saw.ar(50);
	pos = Spherical(LFNoise2.kr(1).range(0.05, 1), LFNoise2.kr(1).range(-pi, pi), LFNoise2.kr(1).range(-pi/2, pi/2));

	foa = FoaEncode.ar(sig, FoaEncoderMatrix.newOmni);
	// foa = FoaFocus.ar(foa, pi/2, pos.theta, pos.phi);
	// foa = FoaZoom.ar(foa, pi/2, pos.theta, pos.phi);
	// foa = FoaPress.ar(foa, pi/2, pos.theta, pos.phi);
	foa = FoaPush.ar(foa, pi/2, pos.theta, pos.phi);
	// foa = FoaDominate.ar(foa, pi/2, pos.theta, pos.phi);
	// foa = FoaDirect.ar(foa, pi/2, pos.theta, pos.phi);
	foa = FoaProximity.ar(HPF.ar(foa, 150), pos.rho);
	// foa = FreeVerb.ar(foa, room: 1);
	# c, fl, sl, srl, srr, sr, fr = FoaDecode.ar(foa, FoaDecoderMatrix.newPanto(7, k: 1));
	[fr, fl, c, Mix([c,fl, sl, srl, srr, sr, fr] * 0.5), sl, sr, srl, srr];
})
~a.play

s.scope
FoaDecoderMatrix.newPanto(7, k: 0.5).dirChannels

({
	var foa, c, fl, sl, srl, srr, sr, fr, mouse;
	mouse = MouseX.kr(0.1, 50);
	foa = SinGrainBBF.ar(trigger: Dust.kr(50), dur: WhiteNoise.kr.range(0.05, 0.1), freq: Select.kr(WhiteNoise.kr.range(0,6), [0.5, 1, 1.333, 1.5, 2, 4] * 440), envbuf: e[\perc], azimuth: LFNoise1.kr(mouse).range(-pi, pi), elevation: LFNoise1.kr(mouse).range(-pi/2, pi/2), rho: WhiteNoise.kr.range(0.01, 5));
	// foa = FreeVerb.ar(foa, room: 1);
	# c, fl, sl, srl, srr, sr, fr = FoaDecode.ar(foa, FoaDecoderMatrix.newPanto(7));
	[fr, fl, c, Mix([c,fl, sl, srl, srr, sr, fr] * 0.5), sl, sr, srl, srr];
}.play)


d[\stereo_samples][\Miserere]

