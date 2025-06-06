
s.boot


({
	var planets, sun = LFNoise2.kr(1!2);
	planets = 5.collect {
		var orbit = SinOsc.ar(ExpRand()!2, Rand(0, 2pi!2), 0.1, sun);
		Pan2.ar(SinOsc.ar(orbit[0].linexp(-1, 1, 50, 5000), mul: 1/5), orbit[1]);
	}.sum;

	planets + Pan2.ar(Saw.ar(sun[0].linexp(-1, 1, 50, 5000), 1/5), sun[1]);
}.play)
