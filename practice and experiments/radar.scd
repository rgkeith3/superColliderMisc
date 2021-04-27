s.boot



// basic radar sim
({
	var source, obj, reflection;
	// send out our radar pulse
	source = SinOsc.ar(440, mul: Env.perc(releaseTime: 0.1).ar);

	// the distance and velocity of the obj affects the reflection time and freq
	// as the obj is further away, the reflection takes longer to return
	// as the obj is moving closer to the source (500 is the start distance, and 50 is the end distance), the reflection is higher pitched because the soundwaves bunch up as they bounce off an incoming object.
	// it's lower pitched when the obj is moving away
	obj = Line.ar(500, 50, 5);
	reflection = CombC.ar(source, 1, obj / 500, 0.1);
	source + reflection;
}.play)

50/ 50000