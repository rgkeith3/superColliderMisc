(~a[0] = {GrainBuf.ar(
	2,
	Impulse.ar(MouseY.kr(1/4, 64)),
	sndbuf: Select.kr(
		LFNoise0.kr(MouseX.kr(1, 16)).range(0, d[\samples][\drums].values.flatten.size - 1),
		d[\samples][\drums].values.flatten.scramble
	),
	envbufnum: e[\perc],
	pan: WhiteNoise.ar
)})

~a.play
~a[10] = \filter -> {|in| XFade2.ar(Concat2.ar(in, DelayN.ar(in), matchlength: MouseX.kr(50.reciprocal, 500.reciprocal), freezestore: LFNoise1.kr(1), randscore: 0), in, LFNoise1.kr(1))}

~a[20] = \filter -> {|in| GVerb.ar(in)}
~a[20] = nil
d[\samples][\drums].values.flatten.size