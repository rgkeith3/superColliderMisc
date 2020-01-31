~a = Pbind(\instrument, \beatPlay, \buf, Pindex([\, d[\samples][\breaks][0]], Pbjorklund(13, 16), inf), \beats, 4, \dur, 1/4, \start, Pseq(Array.fill(16, {|i| i/16}).scramble, inf), \clock, p.clock.tempo, \atk, 0.01, \rel, 0.01, \legato, 1)
~a.play

~a[10] = \filter -> {|in, freq=1| var cont = WhiteNoise.ar(); Concat2.ar(cont, in, matchlength: freq.reciprocal)}
~a.set(\wet10, 1)
~a[15] = \set -> Pbind(\degree, Pseq([1,1,3,1,1,5,1,7], inf).stutter(4), \octave, 1, \dur, 1/4)

~a[20]= \filter -> {|in, gate1=1, atk1=1, rel1=1| in * EnvGen.ar(Env(times: [atk1, rel1]), gate1)}

~a[25]= \set -> Pbind(\gate1, Pseq([1, 0],inf), \dur, Prand([1/8, 1/16],inf), \atk1, 0.01, \rel1, Pkey(\dur), \octave, 2)

p.clock.tempo = 165 / 60