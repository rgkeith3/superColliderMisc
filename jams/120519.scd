~a = Pbindef(\a, \instrument, \flutterSaw, \degree, Psr(4, (0..7)), \scale, Scale.major)
Pbindef(\a, \dur, 4, \legato, 1, \rel, 1, \rate, 5, \amt, 0.01)
Pbindef(\a, \amt, 0.01, \dur, 1/2, \pan, [-1, -0.3, 0.3, 1])

~a.set(\amt, nil)

~a.play

~b = Pbindef(\b, \instrument, \saw, \degree, Ptm(3, (0..7), 0.2), \scale, Scale.major, \dur, 1/6, \fFreq, 100, \pan, Pseq([1, 0, -1], inf))
Pbindef(\b, \octave, 7)

~b.fadeTime_(5); ~b.play
~b.set(\fFreq, ~sin)
~b.set(\q, 0.2)
~sin = {l[\sin].value(p.clock.tempo, 1/32, 500, 5000)}


~revSnd = ~b + ~a;
~rev = {NHHall.ar([~revSnd.ar[0],~revSnd.ar[1]], 2)}


~rev.fadeTime_(10); ~rev.play