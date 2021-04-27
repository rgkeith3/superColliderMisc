~a[0] = Pbind(\instrument, \beatWarp, \index, Pseq([1,1,1,1,1,0,0,1,1,0,0,1,1,1,1,0], inf),\buf, Pindex([\, d[\samples][\breaks][10]], Pkey(\index), inf), \dur, Pwrand([Pn(1/4, 32), Pn(1/2, 16)], [0.7, 0.3] ,inf), \beats, 4, \clock, p.clock.tempo, \start, PbeatRepeat(Array.fill(16, {|i| i/16}), Pwhite(0, 1)), \winSize, 0.001, \rel, Prand([0.01, 1],inf), \atk, 0.01, \legato, 1, \pan, Pwhite(-1), \amp, 0.7)

~a[10] = \filter -> f[\stDelay]

~a[20] = \set -> Pbind(\decR, Prand([0, 1, 2],inf), \decL, Prand([0, 1, 2],inf), \divL, Prand([4, 8, 16, 32],inf), \divR, Prand([4, 8, 16, 32],inf), \wet10, Pwrand([0, 1], [0.8, 0.2], inf), \dur, 1/2)

~a.play

~b = Pbind(\instrument, \noizSpr, \dur, Pseq(f[\durFill].value(64, 4), inf), \octave, 2, \tilt, Pwhite(), \amp, 0.5, \degree, Pseq([1, 1, 1, 3, 1, 2, 3, 5],inf), \scale, Scale.minorPentatonic, \sprTm, 8, \cutoff, Pwrand([500, 5000], [0.8, 0.2],inf), \res, 0.8)

~b.play

~c = Pbind(\instrument, \flutterSaw, \dur, Pwrand([1/2, Pn(1/4, 2)], [0.8, 0.2], inf), \degree, Pseq([Pseq([1,3, 5], 24), Pseq([2,4,6], 24)], inf), \scale, Scale.minorPentatonic, \amp, 0.5, \rate, Pwhite(5, 25), \cutoff, Pwhite(500, 5000), \q, 0.1, \rel, Pwhite(0.1, 3))
~c.play(fadeTime: 5)


~revSnd = ~c
~rev = {NHHall.ar(~revSnd.ar)}
~rev.play(fadeTime: 10)

~d = Pbind(\instrument, \oneShot, \buf, d[\samples][\drums][\k].choose, \amp, 1)
~d.play

~e = Pbind(\instrument, \oneShot, \buf, d[\samples][\drums][\s].choose, \amp, 1, \dur, Pbjorklund2(4, 10))

~e.play

~f = Pbind(\instrument, \oneShot, \buf, d[\samples][\drums][\ch].choose, \amp, Pwhite(0.8), \dur, Pseq([0.26, 0.24], inf))

~f.play

~out = ~a + ~b + ~c + ~d + ~e + ~f + ~rev

~out.play; ~a.stop; ~b.stop; ~c.stop; ~d.stop; ~e.stop; ~f.stop; ~rev.stop;

~out[10] = \filterIn -> {|in| GrainIn.ar(2, Dust.ar(0.3), 0.1, in, WhiteNoise.ar(), e[\perc])}
~out.set(\wet10, 1)

~out[20] = \filterIn -> {|in| FreeVerb.ar(in, 0.5, MouseY.kr, MouseX.kr)}