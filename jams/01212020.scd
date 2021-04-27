~a = Pbind(\instrument, \pluck, \pAmt, 0, \pTime, 0.3, \dec, Prand([1, 3, 5], inf), \degree, Prand([1,3,5,7],inf), \octave, Prand([4,5,6],inf), \dur, 1, \scale, Scale.majorPentatonic, \timbre, Pbrown(hi: 0.9, step: 0.01), \pan, Pbrown(-1))
~a.stop


~delSnd = ~a
~delSnd.fadeTime = 10

~del[0] = {|divL=1, divR=1, decL=1, decR=1| var tm = p.clock.tempo.reciprocal; [CombN.ar(~delSnd.ar[0], tm, tm/divL, decL), CombN.ar(~delSnd.ar[1], tm, tm/divR, decR)]}
~del[10] = \filter -> {|in| CompanderD.ar(in* 2)}

~del.play(fadeTime: 5)
s.record

~del.set(\divL, 3.3, \divR, 4.1, \decR, 10, \decL, 10)
~del.stop(10)

~revSnd = 0; ~b.stop(3)
s.stopRecording
~revSnd.fadeTime = 10

~rev = {FreeVerb.ar(~revSnd.ar, LFNoise1.kr(1).range(0, 1), LFNoise1.kr(1).range(0, 5), LFNoise1.kr(1).range(0, 1))}

~rev.play(fadeTime: 10)

~b = Pbind(\instrument, \saw, \scale, Scale.majorPentatonic, \degree, Pseq([1,1,1,3,1,5,6,7,1,2,3,4,3,2,1,8], inf), \octave, Pseq([3,5,3,4,5,6],inf).stutter(12), \pan, Pbrown(-1), \dur, 1/3, \q, Pbrown(0.01), \cutoff, Pbrown(500, 5000, 125), \legato, 0.5, \rel, Pwrand([0.1, 1, 5, 10], [0.6, 0.2, 0.15, 0.05], inf), \atk, 0.01)

~b.play(fadeTime: 10)

~c = Pbind(\instrument, \ringDrum, \dur, Pseq([3/4, 3/4, 6.5], inf), \octave, 4, \degree, 1, \scale, Scale.majorPentatonic, \pan, Pseq([-1, 1, -0.5, 0.5, 0], inf), \bounce, Pseq([1, 2, 3, 4],inf), \clock, ~tempo, \amp, 0.5)

~c.play(fadeTime: 5)
~c.stop(5)

~d = Pbind(\instrument, \oneShot, \dur, 8, \buf, d[\samples][\drums][\s].choose, \amp, 0.5)
~d.stop(5)

~e[0] = Pbind(\instrument, \oneShot, \dur, Pwrand([1/2, 1/4], [0.7, 0.3], inf), \buf, Prand(d[\samples][\kitchen], inf), \amp, 0.8, \rel, Pwrand([0.1, 1], [0.8, 0.2],inf), \pan, Pwhite(-1))

~e[10] = \filter -> f[\stDelay]
~e[20] = \set -> Pbind(\divL, Prand([4, 6, 8, 16, 32], inf), \divR, Prand([4, 6, 8, 16, 32], inf), \decL, Pwhite(hi: 2), \decR, Pwhite(hi: 2), \dur, 1/2)
~e.stop(10)

