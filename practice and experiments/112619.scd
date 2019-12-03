~a = Pbindef(\a, \instrument, \saw, \degree, Pfsm([#[0, 1], Pseq([1,1,3,5,3], 2), #[0, 1, 2], Pseq([7, 7, 8, 9, 7], 2), #[3], Pseq([5,5,5,5,5], 2), #[0, 1], Pseq([1,1,1,6,7,6,7,1,1,1]), #[2]], inf), \dur, Pseq([1/2, 1/2, 2, 1/2, 1/2], inf))
Pbindef(\a, \scale, Scale.major, \octave, Pseq([3,4,6,7], inf))
Pbindef(\a, \pAmt, 1, \pSpd, 1, \rel, 5, \fAmt, 1)
Pbindef(\a, \fFreq, 1400, \q, 0.5)

~a.play


~b = Pbindef(\b, \instrument, \oneShot, \buf, d[\samples][\Drums][\Kicks][2], \dur, Pwrand([Pseq([1/2, 1/2, 1], inf), Pseq([1/2, 1/2, 1/2, 1/2, 1], inf) ], [0.7 ,0.3], inf), \amp, Pwhite(0.8))
Pbindef(\b, \pan, Pwhite(-0.2, 0.2))
Pbindef(\b, \buf, d[\samples][\Drums][\Kicks][8])

~c = Pbindef(\c, \instrument, \oneShot, \buf, d[\samples][\Drums][\Snares][5], \dur, 8, \amp, 1)
~c[10] = \filter -> {|in| CombN.ar(in, p.clock.tempo.reciprocal / 4, p.clock.tempo.reciprocal / 4, 1)}

~c.play

~b.play

~d = Pbindef(\d, \instrument, \flutterSaw, \degree, Prand([1, 2, 3,4,5,6,7], inf), \scale, Scale.major, \dur, Prand([2,4, 6, 8], inf))

Pbindef(\d, \rate, 25, \amt, Prand([0.1, 0.5, 0.2,1, 2], inf), \octave, 6, \fFreq, 1500, \q, 0.2, \amp, 0.7, \pan, Pwhite(-1), \rel, 1)

~d.fadeTime = 10; ~d.play

~e = Pbindef(\e, \instrument, \saw, \degree, Pstutter(12, Prand([[1,3,5], [2,4,6], [3,5,7]], inf)), \scale, Scale.major, \dur, 1/4, \octave, 6, \rel, 0.5, )

~e.play

~e.set(\amp, 0.8)

~delSnd = ~c + ~b;

~del = {|lTm = 1, lDec=3, rDec=3, rTm=1| var beatDur = p.clock.tempo.reciprocal;[CombC.ar(~delSnd.ar()[0], beatDur * 4, beatDur * lTm, lDec), CombC.ar(~delSnd.ar()[1], beatDur * 4, beatDur * rTm, rDec)]}

~del.play
~del.set(\lTm, 1/2)
~del.set(\rTm, 1/4)
~del.set(\lDec, 3)





~revSnd = ~a + (~c * 0.1) + (~d * 0.1);
~revTm = 1
~rev = {NHHall.ar(~revSnd.ar, ~revTm)}
~rev.fadeTime = 5
~rev.play