~a[0] = {GrainBuf.ar(2, Dust.kr(LFNoise1.kr(0.3).range(0, 100)), LFNoise1.kr(0.2).range(0, 1), Select.kr(LFNoise1.kr(0.1).range(0, 16) + WhiteNoise.kr(LFNoise1.kr(0.3).range(0, 8)), d[\samples][\kitchen]), Select.kr(WhiteNoise.kr(LFNoise1.kr(0.1).range(0, 1)).range(0, 8), [0.25, 0.5, 1, 1.25, 4/3, 1.5, 2]), LFNoise1.kr(0.1).range(0, 1), pan: LFNoise1.kr(0.2) + WhiteNoise.kr(LFNoise1.kr(0.1).range(0, 1)), envbufnum: e[\perc]) * 0.2}
~a[20] = {Decimator.ar(SinOsc.ar(LFNoise1.kr([0.01, 0.05]).range(50, 51)), LFNoise1.kr(0.4).range(1, 20000), LFNoise1.kr(0.6).range(1, 24)) * SinOsc.kr(4, mul: LFNoise1.kr([0.2, 0.21]).range(0, 1))}

~a.play(fadeTime: 10)
5/4
~a.play(fadeTime: 0)
~a.scope

~a = {Warp1.ar(1, Select.kr(LFNoise1.kr([0.5, 0.4]).range(0, 72) + WhiteNoise.kr(), d[\samples][\zaps]), LFNoise1.kr(1).range(0, 1), Select.kr(LFNoise1.kr(25).range(0, 8), [0.25, 0.5, 1, 1.25, 4/3, 1.5, 2]), LFNoise1.kr(0.7).range(0, 0.5), overlaps: LFNoise1.kr(1).range(2, 12), windowRandRatio: LFNoise1.kr(1).range(0, 1)) * 0.1}
~b.clear
~revSnd = (~a) * 0.5
~rev = {FreeVerb2.ar(~revSnd.ar[0], ~revSnd.ar[1], 1, LFNoise1.kr(LFNoise1.kr(0.5).range(0, 2)).range(0, 2), LFNoise1.kr(LFNoise1.kr(0.4).range(0, 2)).range(0, 1))}
~rev[10] = \filter -> {|in| [CombC.ar(in[0], 0.05, LFNoise1.kr(LFNoise1.kr(0.1).range(0, 5)).range(0, 0.05), LFNoise1.kr(0.2).range(0, 1)), CombC.ar(in[1], 0.05, LFNoise1.kr(LFNoise1.kr(0.1).range(0, 5)).range(0, 0.05), LFNoise1.kr(0.2).range(0, 1))]}
~rev[20] = \filter -> {|in| Concat.ar(WhiteNoise.ar(LFNoise1.kr(1)), in, matchlength: LFNoise1.kr(0.5).range(0.0001, 0.1), randscore: LFNoise1.kr(0.5).range(0, 1))}

(~rev[30] = \filter -> {|in|
	var hi, lo, mid, center, width;
	center = LFNoise1.kr(LFNoise1.kr(0.3).range(0, 4)).range(750, 5000);
	width = LFNoise1.kr(0.6).range(0.1, 2);
	hi = HPF.ar(in, center + (width* 500));
	lo = LPF.ar(in, center - (width * 500));
	mid = BPF.ar(in, center, width);

	hi = Pan2.ar(hi, SinOsc.kr(LFNoise1.kr(0.4).range(0, 4)));
	lo = Pan2.ar(lo, SinOsc.kr(LFNoise1.kr(0.4).range(0, 4)));
	mid = Pan2.ar(mid, SinOsc.kr(LFNoise1.kr(0.4).range(0, 4)));

	[(hi[0] + mid[0] + lo[0]), (hi[1] + mid[1] + lo[1])];
})
s.scope
~rev.play
s.stopRecording
~b.stop(10)

~rev.play(fadeTime:0)
s.record
d[\samples][\kitchen].size
s.scope