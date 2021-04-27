~a[0] = Pbind(\instrument, \beatWarp, \buf, d[\samples][\breaks][0], \beats, 4, \dur, 1/8, \start, Pseq(Array.fill(32, {|i| i/32}), inf), \clock, ~tempo, \atk, 0.01, \rel, 0.001, \legato, 1, \winSize, 0.001, \freqScale, 1, \overlaps, 16, \envBuf, e[\trap])
~a.play

~a[10] = \filter -> {|in, freq=1| var cont = WhiteNoise.ar(); Concat2.ar(cont, in, matchlength: freq.reciprocal)}
~a.set(\wet10, 1)
~a.set(\freq, 500)

~a[15] = nil

~a[20]= \filter -> {|in, gate1=1, atk1=1, rel1=1| in * EnvGen.ar(Env(times: [atk1, rel1]), gate1)}
~a[20] = nil
~a[25]= \set -> Pbind(\gate1, Pseq([1, 0],inf), \dur, 1/8, \atk1, 0.01, \rel1, Pkey(\dur), \octave, Pseq([Pseg([4, 0], 30), 0]), \wet10, Pseq([Pseg([1, 1], 30), 0]), \degree, Pseq([1,1,3,1,1,5,1,7], inf).stutter(4), \scale, Scale.minorPentatonic)

p.clock.tempo = 165 / 60


Scale.minorPentatonic
d