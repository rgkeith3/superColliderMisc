(SynthDef(\dopplerPannedSynth, {|freq=440, startPos=#[1,1,1], endPos=#[1,1,1], time=1, out=0|
	var pos, max_dist, rel_vel, normalized_amp, freq_delta, distortion_angle, rho, theta, phi, dist_from_origin, sig;

	pos = [
		Line.ar(startPos[0], endPos[0], time, doneAction: 2),
		Line.ar(startPos[1], endPos[1], time, doneAction: 2),
		Line.ar(startPos[2], endPos[2], time, doneAction: 2),
	];

	max_dist = (50.squared * 3).sqrt;
	dist_from_origin = pos.squared.sum.sqrt;
	rel_vel = pos[0] / dist_from_origin;
	normalized_amp = ((max_dist/dist_from_origin)/max_dist).clip(0.0, 1.0);
	freq_delta = (rel_vel / 1126) * freq + 1;

	distortion_angle = pi/2;
	rho = dist_from_origin;
	theta = (pos[1]/pos[0]).atan;
	phi = (pos[0..1].squared.sum.sqrt/pos[2]).atan;

	// could synthdef.wrap here with prependArgs: [freq * freq_delta, normalized_amp]
	sig = Saw.ar(freq * freq_delta, normalized_amp);
	sig = FoaEncode.ar(sig, FoaEncoderMatrix.newOmni());
	sig = FoaFocus.ar(sig, distortion_angle, theta, phi);
	Out.ar(out, sig);
}).add)

ProxySpace.push(s.boot)

100 / 50

0.reciprocal

~a = Pbind(\instrument, \dopplerPannedSynth, \octave, Prand([4], inf), \degree, Prand([1,3,5,6,7],inf), \startPos, Pfunc({[100.rand - 50, 100.rand - 50, 100.rand - 50]}), \endPos, Pfunc({[100.rand - 50, 100.rand - 50, 100.rand - 50]}), \dur, 5, \time, 5)

~a = Pbind(\instrument, \dopplerPannedSynth, \octave, Prand([4], inf), \startPos, #[50, -50, -50], \endPos, #[50, -50, 50], \dur, 5, \time, 5)

~a.clear
~a.scope

~bFormat = ~a

~bFormat.scope

~bDecode = {FoaDecode.ar(~bFormat.ar, FoaDecoderMatrix.newStereo)}

~bDecode.play
-3.sign
100.rand - 50
