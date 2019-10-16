s.boot

// chords in degrees
(
Pbindef(\chords,
	\delta, Pseq([1/3, 1/3, 1/2, 1/6, 1/3, 1/3], inf),
	\dur, 1/6,
	\scale, Pdefn(\scale, Scale.major.degrees),
	\degree, Pdefn(\degree, [1]),
	\strum, Pdefn(\strum, 0)
).play
)
(
Pdefn(\degree, Pseq([
	Pseq([[0,2,4]], 6),
	Pseq([[2,4,6]], 6),
	Pseq([[5,7,9]], 6),
	Pseq([[1,3,5]], 6),
	Pseq([[4,6,8]], 3),
	Pseq([[2,4,6]], 3)
], inf))
)

Pdefn(\strum, Pseg([0, 0.5, 0], 30, repeats: inf))
// I
Pdefn(\degree, [0, 2, 4])

// II
Pdefn(\degree, [1, 3, 5])

// III
Pdefn(\degree, [2, 4, 6])

// IV
Pdefn(\degree, [3, 5, 7])

// V
Pdefn(\degree, [4, 6, 8])

//VI
Pdefn(\degree, [5, 7, 9])

// VII
Pdefn(\degree, [6, 8, 10])

//i
Pdefn(\degree, [0, 3, 7])

Pdefn(\scale, Scale.harmonicMajor.degrees)

Scale.names.choose
