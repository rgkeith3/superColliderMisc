// NOTE!!: the BinaryOpUGen implementation of 'pow' is broken and returning negative values, use .squared on these in the meantime.


({
	var x0, y0, z0, x1, y1, z1, x_diff, y_diff, z_diff, x_term, y_term, z_term, top_term, bottom_term, rel_vel, s_o_s, freq_delta, freq;
	# x0, y0, z0 = [-100, 100, 100];
	# x1, y1, z1 = [100, 100, 100];
	t = Line.ar(0, 1, 0.5, doneAction: 2);

	x_diff = (x1 - x0);
	y_diff = (y1 - y0);
	z_diff = (z1 - z0);
	x_term = (x_diff * t) + x0;
	y_term = (y_diff * t) + y0;
	z_term = (z_diff * t) + z0;
	top_term = (z_diff * z_term) + (y_diff * y_term) + (x_diff * x_term);
	bottom_term = (z_term.squared + y_term.squared + x_term.squared).sqrt;
	rel_vel = top_term / bottom_term;

	s_o_s = 343.2;
	freq_delta = s_o_s / (s_o_s + rel_vel);
	freq = 50 * freq_delta;
	Saw.ar(freq);
}.play)
s.boot

(SynthDef(\dopplerSaw, {|x0=1, y0=1, z0=1, x1=1, y1=1, z1=1, freq=440, time=3, out=0|
	var sig, dist, rel_vel, s_o_s, freq_delta, pos, pos_squared, normalized_amp, distortion_angle, rho, theta, phi, foa, c, fr, sr, srr, fl, sl, srl, chanArray;
	// all distance in m
	// sos = m per second
	pos = Cartesian(Line.ar(x0, x1, time, doneAction: 2), Line.ar(y0, y1, time, doneAction: 2), Line.ar(z0, z1, time, doneAction: 2)
	);
	dist = pos.rho;
	rel_vel = (pos.asArray * [x1-x0, y1-y0, z1-z0]).sum / dist;

	// very crude amp estimation;
	normalized_amp = dist.reciprocal.clip(0,1);

	s_o_s = 343.2;
	freq_delta = s_o_s / (s_o_s + rel_vel);
	freq = freq * freq_delta;
	sig = SawDPW.ar(freq, mul: 2);

	// tbh, not sure what distortion angle really means, might be a good use for 'distance' like the further away, the smaller the distortion angle?
	distortion_angle = pi/2;

	foa = FoaEncode.ar(sig, FoaEncoderMatrix.newOmni());
	foa = FoaFocus.ar(foa, distortion_angle, pos.theta, pos.phi);
	foa = FoaProximity.ar(HPF.ar(foa, 5),pos.rho);
	# c, fl, sl, srl, srr, sr, fr = FoaDecode.ar(foa, FoaDecoderMatrix.newPanto(7, k: 1));
	chanArray = [fr, fl, c, Mix([c,fl, sl, srl, srr, sr, fr] * 0.5), sl, sr, srl, srr];

	Out.ar(out, chanArray);
}).load)


(~a[0] = Pbind(
	\instrument, \dopplerSaw,
	\x0, 100, \x1, -100,
	\y0, 0, \y1, 0,
	\z0, 1, \z1, 1,
	\degree, Prand([1,3,5,7], inf), \time, 1, \dur, Pseq(f[\durFill].value(16, 0.5), inf), \octave, Prand([4,5,6],inf)));

~a[10] = \filter -> {|in| FreeVerb.ar(in, 0.5, room: 0.5)}
~a.play
~a.mold(8)
s.scope