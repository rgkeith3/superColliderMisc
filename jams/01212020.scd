~a = Pbind(\instrument, \pluck, \pAmt, 0, \pTime, 0.3, \dec, Prand([1, 3, 5], inf), \degree, Prand([1,3,5,7],inf), \octave, Prand([4,5,6],inf), \dur, 1, \scale, Scale.majorPentatonic, \timbre, Pbrown(hi: 0.9, step: 0.01), \pan, Pbrown(-1))
~a.play



~delSnd = ~a

~del[0] = {|divL=1, divR=1, decL=1, decR=1| var tm = p.clock.tempo.reciprocal; [CombN.ar(~delSnd.ar[0], tm, tm/divL, decL), CombN.ar(~delSnd.ar[1], tm, tm/divR, decR)]}

~del.play

~del.set(\divL, 1.55, \divR, 1.5, \decR, 5, \decL, 5)


~revSnd = ~a + ~del + ~b

~rev = {FreeVerb.ar(~revSnd.ar, 1, 10, 0.1)}

~rev.play

~b = Pbind(\instrument, \saw, \scale, Scale.majorPentatonic, \degree, Pseq([1,1,1,3,1,5,6,7,1,2,3,4,3,2,1,8], inf), \octave, Pseq([3,5,3,4,5,6],inf).stutter(12), \pan, Pbrown(-1), \dur, 1/3, \q, Pbrown(0.01), \cutoff, Pbrown(500, 5000, 125), \legato, 0.5, \rel, Pwrand([0.1, 1, 5, 10], [0.6, 0.2, 0.15, 0.05], inf), \atk, 0.01)

~b.play

~c = Pbind(\instrument, \ringDrum, \dur, Pseq([3/4, 3/4, 6.5], inf), \octave, 4, \degree, 1, \scale, Scale.majorPentatonic, \pan, Pseq([-1, 1, -0.5, 0.5, 0], inf), \bounce, Pseq([1, 2, 3, 4],inf), \clock, ~tempo, \amp, 0.5)

~c.play

~d = Pbind(\instrument, \oneShot, \dur, 8, \buf, d[\samples][\Drums][\Snares].choose, \amp, 0.5)
~d.play

~e = Pbind(\instrument, \oneShot, \dur, Pwrand([1/2, 1/4], [0.7, 0.3], inf), \buf, Pxrand(d[\samples][\kitchen], inf), \amp, 0.8, \rel, Pwrand([0.1, 1], [0.8, 0.2],inf), \pan, Pwhite(-1))
~e.play

