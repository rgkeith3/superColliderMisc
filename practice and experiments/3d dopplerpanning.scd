s.boot


({
	var start_point, end_point, time, moving_point, dist_from_origin, rel_vel, freq_delta, s_o_s, freq, amp;


	freq = 150;
	start_point = [-50, 5, 3];
	end_point = [50, -5, -3];
	time = 1;
moving_point = [
		Line.ar(start_point[0], end_point[0], time, doneAction: 2),
		Line.ar(start_point[1], end_point[1], time, doneAction: 2),
		Line.ar(start_point[2], end_point[2], time, doneAction: 2),
	];
/*	moving_point = [
		LFNoise2.ar(1).range(-50, 50),
		LFNoise2.ar(1).range(-50, 50),
		LFNoise2.ar(1).range(-50, 50),
	];*/

	dist_from_origin = moving_point.squared.sum.sqrt;

	// moving_point of the derivative of the distance formula will give us velocity at any one point?
	//solve doppler for delta frequency instead of observed frequency

	rel_vel = moving_point[0] / dist_from_origin * -2;

	s_o_s = 1126;

	amp = ((50/dist_from_origin)/50).clip(0.0, 1.0);
	freq_delta = (rel_vel / s_o_s) * freq + 1;
	freq_delta.poll;
	Saw.ar(freq * freq_delta, mul: amp);
	//PitchShift.ar(Saw.ar(freq), 0.01, freq_delta, mul: amp);

	// does this work with moving point?
	// todo: more accurate volume scaling, along with 'spatial scaling' for ambisonics and actual ambisonic transformations
}.play)

