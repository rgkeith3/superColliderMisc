(
// n is numChannels
var nPanFunc, outFunc, adsrFunc, percFunc, synthDefs;
if (n == 2) {
	nPanFunc = {|sig, pan=0| Pan2.ar(sig, pan)};
} {
	nPanFunc = {|sig, panX=0, panY=0| Pan4.ar(sig, panX, panY)};
};

outFunc = {|sig, out=0, amp=0.8| Out.ar(out, sig * amp)};


adsrFunc = {|sig, atk=0.01, dec=0.1, sus=0.8, rel=0.5, gate=1| sig * EnvGen.ar(Env.adsr(atk, dec, sus, rel), gate, doneAction: 2)};

percFunc = {|sig, atk=0.01, rel=0.5| sig * EnvGen.ar(Env.perc(atk, rel), doneAction: 2)};

synthDefs = (
	oneShot: [
		{|buf, rate=1, start=0| var startPos = start * BufFrames.ir(buf); PlayBuf.ar(1, buf, BufRateScale.ir(buf)* rate, startPos: startPos, doneAction: 2)},
		percFunc,
		nPanFunc,
		outFunc
	],

	stOneShot: [
		{|buf, rate=1, start=0| var startPos = start * BufFrames.ir(buf); PlayBuf.ar(2, buf, BufRateScale.ir(buf)* rate, startPos: startPos, doneAction: 2)},
		percFunc,
		outFunc
	],

	loop: [
		{|buf, rate=1, start=0| var startPos = start * BufFrames.ir(buf); PlayBuf.ar(1, buf, BufRateScale.ir(buf)* rate, startPos: startPos, loop: 1)},
		adsrFunc,
		nPanFunc,
		outFunc
	],

	stLoop: [
		{|buf, rate=1, start=0| var startPos = start * BufFrames.ir(buf); PlayBuf.ar(2, buf, BufRateScale.ir(buf)* rate, startPos: startPos, loop: 1)},
		adsrFunc,
		outFunc
	],

	beatPlay: [
		{|buf, clock=1, beats=4, start=0| var startPos, length, rate; startPos = start * BufFrames.ir(buf); length = clock.reciprocal * beats; rate = (BufDur.ir(buf) / length) * BufRateScale.ir(buf); PlayBuf.ar(1, buf, rate, startPos: startPos, doneAction: 2)},
		adsrFunc,
		nPanFunc,
		outFunc
	],

	beatWarp: [
		{|buf, clock=1, beats=4, start=0, freqScale=1, winSize=0.2, envBuf=(-1), overlaps=8, winRand=0| var length, pointer; length = clock.reciprocal * beats; pointer = Line.ar(dur: length, add: start); Warp1.ar(1, buf, pointer, freqScale, winSize, envBuf, overlaps, winRand);},
		adsrFunc,
		nPanFunc,
		outFunc
	],

	stbeatWarp: [
		{|buf, clock=1, beats=4, start=0, freqScale=1, winSize=0.2, envBuf=(-1), overlaps=8, winRand=0| var length, pointer; length = clock.reciprocal * beats; pointer = Line.ar(dur: length, add: start); Warp1.ar(2, buf, pointer, freqScale, winSize, envBuf, overlaps, winRand);},
		adsrFunc,
		outFunc
	],

	warp: [
		{|buf, pointer=0.5, freqScale=1, winSize=0.2, envBuf=(-1), overlaps=8, winRand=0| Warp1.ar(1, buf, pointer, freqScale, winSize, envBuf, overlaps, winRand);},
		adsrFunc,
		nPanFunc,
		outFunc
	],

	stWarp: [
		{|buf, pointer=0.5, freqScale=1, winSize=0.2, envBuf=(-1), overlaps=8, winRand=0| Warp1.ar(2, buf, pointer, freqScale, winSize, envBuf, overlaps, winRand);},
		adsrFunc,
		outFunc
	],

	// maybe do something to give the pointer motion, like pointerdev?
	bufGrain: [
		{|buf, pRate=1, start=0, pDev=0.1, gRate=1, gSize=0.1, tRate=15, tDev=0.5, pan=0, pNoise=0.1, envBuf=(-1)|
			var pointer = Sweep.kr(1, BufRateScale.kr(buf) * pRate) + WhiteNoise.kr(pDev) + start;
			GrainBuf.ar(n, GaussTrig.ar(tRate, tDev), gSize, buf, gRate, pointer, pan: pan + WhiteNoise.kr(pNoise), envbufnum: envBuf);
		},
		adsrFunc,
		outFunc
	],

	// maybe try a different filter? not quite the right sound and feels like it's to cpu intensive?
	saw: [
		{|freq=440, fFreq=880, q=1, fAmt=0.1, fSpd=0.1, pan=0, pAmt=0.1, pSpd=0.1|
			Pan2.ar(RLPF.ar(SawDPW.ar(freq + LFNoise1.kr(fSpd, fAmt)), fFreq, q), pan + LFNoise1.kr(pSpd, pAmt));
		},
		adsrFunc,
		outFunc
	],

	flutterSaw: [
		{|freq=440, amt=1, rate=15, ffreq=880, q=1|
			var flutter = LFClipNoise.kr(rate, amt/2, amt/2) * freq;
			RLPF.ar(SawDPW.ar(freq + flutter), ffreq, q);
		},
		adsrFunc,
		nPanFunc,
		outFunc
	],

	// to do:
	// super saw
	// vosc
	// some drums
	// some bass
);


synthDefs.keysValuesDo {|synthName, synthFuncs|
	SynthDef(synthName.asSymbol, {
		var sig = SynthDef.wrap(synthFuncs[0]);
		synthFuncs[1..].do {|func|
			sig = SynthDef.wrap(func, prependArgs: [sig]);
		};
	}).add;
}

)