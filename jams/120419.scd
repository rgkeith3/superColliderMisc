~hat = Pbindef(\hat, \instrument, \oneShot, \buf, d[\samples][\zap2][15], \dur, 1/4)
Pbindef(\hat, \buf, d[\samples][\zap2][20], \rel, 0.1, \rate, 4, \pan, Pwhite(-0.5, 0.5))
Pbindef(\hat, \amp, Pwhite(0.3, 0.5))
~hat.play


~k = Pbindef(\k, \instrument, \oneShot, \buf, d[\samples][\Drums][\Kicks].choose, \dur, Pseq(f[\durFill].value(16, 1), inf))
Pbindef(\k, \amp, 1)
Pbindef(\k, \rel, 1)
Pbindef(\k, \dur, Pseq(f[\durFill].value(16, 1/4, 0.5), inf))

Pbindef(\k, \buf, d[\samples][\Drums][\Kicks][1])
~k.play

~s = Pbindef(\s, \instrument, \oneShot, \buf, d[\samples][\Drums][\Snares].choose, \dur, 8)
~s.set(\amp, 0.5)
~s.play

~s[10] = \filter -> {|in, divR=2, divL=2, dec=5| var beatTime = p.clock.tempo.reciprocal; [CombN.ar(in[0], beatTime, beatTime / divR, dec), CombN.ar(in[1], beatTime, beatTime / divL, dec)]}

~s.set(\divR, 4, \divL, 4.1, \dec, 10)

~s.set(\dec, 2)
Pbindef(\s, \pan, Pwhite(-1))

~b = Pbindef(\b, \instrument, \saw, \octave, 2, \dur, Pseq(f[\durFill].value(16, 1), inf), \degree)
Pbindef(\b, \degree, Pstutter(Pseq([4, 4,2, 2, 4], inf), Pseq([1,1,2, 1,6], inf)), \dur, 1/2)

~b.play

~b.set(\amp, 0.3)
~b.set(\fFreq, 500, \q, 0.1)
Pbindef(\b, \pan, Pwhite(-1))

~b.set(\fFreq, ~sin)


~sin = {l[\sin].value(p.clock.tempo.reciprocal, 1/15, 500, 5000)}


~c = Pbindef(\c, \instrument, \flutterSaw, \degree, Pwrand([1, 6], [0.9, 0.1], inf))
~c.fadeTime_(10); ~c.play
Pbindef(\c, \octave, 6, \amp, 0.6)

Pbindef(\c, \rate, 25, \ffreq, 1000, \q, 0.1, \amt, Prand([0, 0.1, 1, 2], inf), \pan, Pwhite(-1), \delta, 0.1, \dur, 1, \amp, 0.3)


~c[10] = \filter -> {|in| ((in) * Amplitude.kr(~k.ar * 5, releaseTime: 1, mul: -1, add: 1).clip).scope * 0.2}

~break = Pbindef(\break, \instrument, \beatPlay, \buf, d[\samples][\breaks].choose, \beats, 4, \start, Pseq(Array.fill(16, {|i| i/16}).scramble, inf), \dur, 1/4)

Pbindef(\break, \buf, d[\samples][\breaks][13], \beats, 4, \instrument, \beatWarp, \freqScale, 2)
Pbindef(\break, \winSize, 0.01)
~break.set(\amp,2)
~break.play

~k.fadeTime_(10); ~k.stop

(
Tdef(\temp, {
	var tempo = p.clock.tempo * 60;
	while ({tempo < 160}, {
		tempo = tempo + 1;
		tempo.postln;
		p.clock.tempo_(tempo / 60);
		10.yield;
	})
}).play
)

~revSnd = (~b * 0.3) +  ~c


~rev = {NHHall.ar([~revSnd.ar[0], ~revSnd.ar[1]], 2, 0.5)}

~rev.fadeTime_(5); ~rev.play