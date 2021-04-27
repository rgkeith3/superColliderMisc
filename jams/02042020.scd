~a = Pbind(\dur, Pbjorklund2(13, 16) / 4, \instrument, \oneShot, \buf, Ptm(3, d[\samples][\drums][\k][58..60], 0.1), \pan, Pwhite(-1), \amp, Pwhite(0.8))
~a.play
~a[10] = {Crackle.ar(LFNoise0.ar(~tempo.kr!2).range(0.5, 2)) * 0.05}
~a[20] = \filter -> {|in| CompanderD.ar(in * 5).softclip}

~b = Pbind(\dur, Pbjorklund2(5, 12) / 4, \instrument, \oneShot, \buf, d[\samples][\drums][\s].choose, \amp, 0.3)
~b.play

~c = Pbind(\dur, Pbjorklund2(14, 16) / 4, \instrument, \oneShot, \buf, Prand(d[\samples][\drums][\ch], inf), \amp, Pwhite(0.4, 0.5))
~c.play


~d[0] = Pbind(\instrument, \oneShot, \dur, 8, \buf, d[\samples][\drums][\c].choose, \amp, 1)
~d[10] = \filter -> {|in| FreeVerb.ar(in, 0.5, 2)}
~d.play

~e = Pbind(\instrument, \oneShot, \dur, Pbjorklund2(13, 16)/4, \buf, d[\samples][\stabs][16], \amp, Pwhite(0.3, 0.5), \pan, Pwhite(-1), \spd, Prand([0.5, 0.75, 1], inf))
~e[10] = \filter -> {|in| RLPF.ar(in, 1000 ,0.1)}
~e[20] = \filter -> {|in| FreeVerb.ar(in, 0.5, 0.7, 1)}
~e.play

s.record