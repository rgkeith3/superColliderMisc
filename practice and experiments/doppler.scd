//https://stackoverflow.com/questions/3120357/get-closest-point-to-a-line
(
// start point, endpoint, speed (m/s), freq, roomsize(m)
// going with speed of sound as 1225 km/h or ~340 m/s
{ |x1, y1, x2, y2, v, freq|
	var a_to_o = [0 - x1, 0 - y1];
	var a_to_b = [x2 - x1, y2 - y1];

	var a_to_b_squared = (a_to_b[0] ** 2) + (a_to_b[1] ** 2);

	var a_to_o_dot_a_to_b = (a_to_o[0] * a_to_b[0]) + (a_to_o[1] * a_to_b[1]);

	var normalized_a_to_t_dist = a_to_o_dot_a_to_b / a_to_b_squared;
	var
	// this is 'where along the line from the closest point to the origin is, 0 being the beginning of the line, 1 being the end.

	// find dist from start to o, from t to o, from o to end
	// the dist from start to o - from o to t = positive velocity
	// from t to o - from o to end = negative velocity
	// plug these in the 'perceived freq' formula,
	// somehow different velocities relate to the curve of the env.

	var dist_from_o_to_start = (x1.pow(2) + y1.pow(2)) ** 0.5;
	var dist_from_o_to_end = (x2.pow(2) + y2.pow(2)) ** 0.5;
	var dist_from_o_to_t =

}.value(0, 0, -1, -1, , 440)
)
((1225 / 60) / 60) * 1000

perceived_freq = ((speed of sound +/- 0 )/ (speed of sound +/- velocity of source))* original freq

// find the closest point on the line to the origin -> this is where freq will be 'true' aka the unaltered freq arg
// constant speed of the line (relation of it's distance traveled * duration) will determine the freq delta
// freq delta and distance starting point is from 'true' point will determine starting freq
// freq delta and distance end point is from 'true' point will determine end freq.
// start -> 'true' distance = atk time, 'true' -> end distance = release time.

//things i need:
// 'true' point on line
// speed of vector
// distance from start to 'true'
// distance from 'true' to end

// in the future, a 'doppler-aware synth' should know how big the space is, therefore the -1 to 1 of pan2 and pan4 is a normalized version of that. it should also take in either start and end points and a speed ( and calculate dur from that), or start and end and dur and calculate speed.
// could even come up with some functions to wrap user-definable synthdefs in panners, pitchshifters, envs and lpfs to simulate moving sound.