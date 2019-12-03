d[\stereo_samples][\Miserere][2].play
~d = Pbind(\instrument, \stOneShot, \buf, d[\stereo_samples][\Miserere][2], \start, Pseq(Array.fill(32, {|i| i/64}).scramble, inf), \dur, 1/4, \rel, 0.5)

~d[10] = \filter -> {|in, divL=4, divR=2| var tempRecip = p.clock.tempo.reciprocal; [CombN.ar(in[0], tempRecip, tempRecip / divL, 2), CombN.ar(in[0], tempRecip, tempRecip / divR, 2)]}
~d.xset(\wet10, 0.5)
~d.set(\divL, 2);~d.set(\divR, 3)
~d.set(\winSize, 0.0002)
~d.set(\overlaps, 4)
~d.set(\winRand, 0)
~d.set(\freqScale, 1)
~d.set(\envBuf, e[\trap])

e.keys

~d.play