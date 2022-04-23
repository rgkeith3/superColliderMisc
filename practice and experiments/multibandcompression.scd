~a = {PlayBuf.ar(1, d[\samples][\breaks].choose, loop: 1)}
(~a[10] = \filter -> {|in, loFreq=500, hiFreq=5000|
	var lo, mid, hi;
	lo = BHiCut.ar(in, loFreq, 5);
	hi = BLowCut.ar(in, hiFreq, 5);
	mid = BLowCut.ar(BHiCut.ar(in, hiFreq, 5), loFreq, 5);
	XFade2.ar(Mix(CompanderD.ar([lo, mid, hi], thresh: 0.1, slopeBelow: [0.9, 0.5, 0.9], slopeAbove: [1.1, 1.5, 1.1])), CompanderD.ar(in, thresh: 0.1, slopeBelow: 0.5, slopeAbove: 0.5), MouseX.kr(-1))
})

~a.clear
~a.play