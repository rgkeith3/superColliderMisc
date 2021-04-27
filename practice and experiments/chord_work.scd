~a[0] = Pbind(\type, \freqable, \instrument, \flutterSaw, \amt, 0, \octave, 5, \q, Pwhite(), \dur, 1/2, \degree, Pseq([c.value(Scale.major, 1), c.value(Scale.major, 3), c.value(Scale.major, 5)], inf), \scale, Scale.chromatic, \rel, 1, \pan, Pwhite(-1))

~a.play

[Scale.major.degrees[0], Scale.major.degrees[2]-1, Scale.major.degrees[4]]

(c = {|scale, chord_index|
	[scale.degrees[chord_index-1%scale.size], scale.degrees[chord_index+1%scale.size], scale.degrees[chord_index+3%scale.size]];
})


[1,2,3][5%3]

c.value(Scale.major, 0)

Scale.major.degrees.size