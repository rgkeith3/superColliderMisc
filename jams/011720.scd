~a[0] = Pbind(\instrument, \beatWarp, \clock, ~tempo, \beats, 16, \buf, d[\samples][\lost][7], \start, Pseq((Array.fill(16, {|i| i/16})!2).flatten.scramble, inf), \dur, 1/4, \winSize, 0.1, \freqScale, Pseq([0.75, 1, 1.25, 1, 1.5, 1.5, 0.5, 1], inf), \atk, 0, \rel, 0.1, \legato, 0.5, \amp, 1, \envBuf, e[\trap])

~a.play

~b = Pbind(\instrument, \oneShot, \buf, d[\samples][\Drums]['Open Hihat'].choose, \dur, 0.5)
~b.play

~c = Ptpar([1, Pbind(\instrument, \oneShot, \buf, d[\samples][\Drums][\Snares].choose, \dur, 2)])
~c.play

~d = Pbind(\instrument, \oneShot, \buf, d[\samples][\Drums][\Kicks][10], \dur, Pseq([3/4, 3/4, 6.5], inf), \amp, 1)

~d.play

(Array.fill(16, {|i| i/16})!2).flatten.scramble

8 - 1.5