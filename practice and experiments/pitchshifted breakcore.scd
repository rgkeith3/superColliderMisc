d[\samples][\breaks][3].play

~a[0] = Pbind(\instrument, \beatPlay, \clock, p.clock.tempo, \beats, 2, \buf, d[\samples][\breaks][6], \dur, 8, \legato, 1)

~a.play

~a[10] = \filter -> {|in, break=0, div=4| Select.ar(break, [in, PitchShift.ar(Breakcore.ar(b, in,break, 44100 / (p.clock.tempo * div), 0), 0.001, LFNoise1.kr(p.clock.tempo, 0.5, 1), timeDispersion: 0.0001)])}

~a[11] = \pset -> Pbind(\dur, 1/2, \break, Pwrand([0, 1], [0.7, 0.3], inf), \div, Prand([4, 2, 8, 16], inf))

~a[20] = \filter -> {|in| (CompanderD.ar(in* 5) * 2).softclip}

~a[25] = \filter -> {|in| CombN.ar(in, p.clock.tempo.reciprocal, p.clock.tempo.reciprocal / 4, 1)}


b = Buffer.alloc(s, 44100)


p.clock.tempo