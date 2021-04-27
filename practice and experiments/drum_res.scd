~a[0] = Pbind(\instrument, \beatWarp, \buf, Pwrand([d[\samples][\breaks][3], Prand(d[\samples][\breaks][0..7])], [0.8, 0.2], inf), \beats, 4, \clock, ~tempo, \dur, 1/4, \start, PbeatRepeat(Array.fill(16, {|i| i/16}).scramble, Pwrand([0, 1], [0.7, 0.3], inf)), \winSize, Pwrand([0.001, 0.1], [0.7, 0.3], inf), \pan, Pwhite(Pseg([0, -1], 32, repeats: inf), Pseg([0, 1], 32, repeats: inf)), \amp, 1)
~a[10] = \filter -> {|in| HPF.ar(in, 150, 2).softclip}

~a[20] = \filter -> {|in, midiNoteL=69, midiNoteR=73, decL=1, decR=1| CombN.ar(in, 0.1, [midiNoteL.midicps.reciprocal, midiNoteR.midicps.reciprocal], [decL, decR])}

~a[25] = \set -> Pbind(\wet20, Pwrand([0, 0.5, ~c], [0.5, 0.3, 0.2], inf), \midiNoteL, Pseq([60, 62, 64, 65, 67, 69, 71].scramble, inf).stutter(2) - Prand([12, 24, 36], inf), \midiNoteR, Pseq([60, 62, 64, 65, 67, 69, 71].scramble, inf) - Prand([12,24, 36], inf), \dur, 1, \decL, Pwrand([0.3, 1, 5], [0.6, 0.3, 0.1], inf), \decR, Pkey(\decL))

~a[20] = \filter -> {|in, midiNoteL=69, midiNoteR=73, rand=0| var cSrc = WhiteNoise.ar(LFNoise0.kr(~tempo.kr));  Concat.ar(cSrc, in, matchlength: [midiNoteL.midicps.reciprocal, midiNoteR.midicps.reciprocal], randscore: rand)}

~a[30] = \filter -> {|in| CompanderD.ar(in, 0.15, 10, 1)}
~a.play
p.clock.tempo = 165 / 60


~d = {|density=5, gSize=0.2, which=0, rate=1, pos=0, pan=0|GrainBuf.ar(2, GaussTrig.kr(density), gSize, Select.kr(which, d[\samples][\kitchen]), rate, pos, 0, pan, e[\perc])}
d[\samples][\kitchen]
d.set(\envBufNum, e[\perc].bufnum)

e[\perc].bufnum
~a.stop
~d.play
~b.clear
~c = {SinOsc.kr(16).range(0, 1)}

~d.set(\which, ~which)
~d.set(\density, ~density)
~d.set(\rate, ~rate)
~d.set(\gSize, ~gSize)
~d.set(\pan, ~pan)
440.cpsmidi
~density = {LFNoise1.kr(0.1).range(1, 100)}
~gSize = {LFNoise1.kr(0.2).range(0, 1)}
~pan = {WhiteNoise.ar}
~rate = {Select.kr(WhiteNoise.kr().range(0, 3), [0.5, 1, 1.5, 2])}

~which = {WhiteNoise.kr(LFNoise1.kr(0.1).range(0, 1)).range(0, d[\samples][\kitchen].size)}
s.meter