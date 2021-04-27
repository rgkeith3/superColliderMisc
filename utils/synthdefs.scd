(
// n is numChannels
var nPanFunc, outFunc, adsrFunc, percFunc, synthDefs;
switch (n,
	2, nPanFunc = {|sig, pan=0| Pan2.ar(sig, pan)},
	4, nPanFunc = {|sig, panX=0, panY=0| Pan4.ar(sig, panX, panY)},
	nPanFunc = {|sig, pan=0, width=2| PanAz.ar(n-1, sig, pan, level: width)}
);

outFunc = {|sig, out=0, amp=0.8| Out.ar(out, sig * amp)};


adsrFunc = {|sig, atk=0.01, dec=0.1, sus=0.8, rel=0.5, gate=1| sig * EnvGen.ar(Env.adsr(atk, dec, sus, rel), gate, doneAction: 2)};

percFunc = {|sig, atk=0.01, rel=0.5| sig * EnvGen.ar(Env.perc(atk, rel), doneAction: 2)};

// rename all synthdef 'rate' args, getting collisions
synthDefs = (
	oneShot: [
		{|buf, spd=1, start=0| var startPos = start * BufFrames.ir(buf); PlayBuf.ar(1, buf, BufRateScale.ir(buf)* spd, startPos: startPos, doneAction: 2)},
		percFunc,
		nPanFunc,
		outFunc
	],

	stOneShot: [
		{|buf, spd=1, start=0| var startPos = start * BufFrames.ir(buf); PlayBuf.ar(2, buf, BufRateScale.ir(buf)* spd, startPos: startPos, doneAction: 2)},
		percFunc,
		outFunc
	],

	loop: [
		{|buf, spd=1, start=0| var startPos = start * BufFrames.ir(buf); PlayBuf.ar(1, buf, BufRateScale.ir(buf)* spd, startPos: startPos, loop: 1)},
		adsrFunc,
		nPanFunc,
		outFunc
	],

	stLoop: [
		{|buf, spd=1, start=0| var startPos = start * BufFrames.ir(buf); PlayBuf.ar(2, buf, BufRateScale.ir(buf)* spd, startPos: startPos, loop: 1)},
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

// need to fix: the pointer is not calculating pointer speed correctly
	// also need to rename args without 'rate' getting collisions
	bufGrain: [
		{|buf, pSpd=1, start=0, pDev=0.1, gSpd=1, gSize=0.1, tSpd=15, tDev=0.5, pan=0, paNoise=0.1, envBuf=(-1)|
			var pointer = Sweep.kr(1, BufRateScale.kr(buf) * pSpd) + WhiteNoise.kr(pDev) + start;
			GrainBuf.ar(n, GaussTrig.ar(tSpd, tDev), gSize, buf, gSpd, pointer, pan: pan + WhiteNoise.kr(paNoise), envbufnum: envBuf);
		},
		adsrFunc,
		outFunc
	],

	// maybe try a different filter? not quite the right sound and feels like it's to cpu intensive?
	saw: [
		{|freq=440, cutoff=880, q=1, fAmt=0.1, fSpd=0.1, pan=0, pAmt=0.1, pSpd=0.1|
			Pan2.ar(RLPF.ar(SawDPW.ar(freq + LFNoise1.kr(fSpd, fAmt)), cutoff, q), pan + LFNoise1.kr(pSpd, pAmt));
		},
		adsrFunc,
		outFunc
	],

	flutterSaw: [
		{|freq=440, amt=1, rate=15, filter_freq=880, q=1|
			var flutter = LFClipNoise.kr(rate, amt/2, amt/2) * freq;
			RLPF.ar(SawDPW.ar(freq + flutter), filter_freq, q);
		},
		adsrFunc,
		nPanFunc,
		outFunc
	],

	noizSpr: [
		{|freq=50, detune=5, cutoff=2000, res=0.1, sprSt=0, sprEnd=1, sprTm=1, pAmt=1, pDec=1, tilt=0|
			var sig1, sig2, spr, pEnv;
			spr = Line.kr(sprSt, sprEnd, sprTm);
			pEnv = Line.ar(freq * pAmt, freq, pDec);

			sig1 = Gendy5.ar(minfreq: pEnv, maxfreq: freq + detune);
			sig2 = Gendy5.ar(minfreq: pEnv, maxfreq: freq + detune);

			sig1 = SVF.ar(sig1, cutoff, res, tilt, highpass: tilt.range(1, 0));
			sig2 = SVF.ar(sig2, cutoff, res, tilt.range(1, 0), highpass: tilt);

			sig1 = Pan2.ar(sig1, spr);
			sig2 = Pan2.ar(sig2, spr.range(0, -1));

			[sig1[0] + sig2[0], sig1[1] + sig2[1]];
		},
		adsrFunc,
		outFunc
	],

	henonDrum: [
		{|freq=440, cutoff=2000, q=0.5, pAmt=5, pDec=0.1, a=1.5, b=0, c=0.5, d=0.6|
			var sig, pEnv;
			pEnv = Line.ar(freq * pAmt, freq, pDec);
			sig = HenonN.ar(pEnv, a, b, c, d);
			RLPF.ar(sig, cutoff, q);
		},
		percFunc,
		nPanFunc,
		outFunc
	],

	wub: [
		{|freq=50, loCutoff=50, hiCutoff=500, bufPos=0, bufPosStart, bufPosEnd, wubDiv=1, q=0.5, clock=1, wubPhase=0|
			var sig, wub, bufPointer;
			bufPointer = bufPos.linlin(0, 1, bufPosStart, bufPosEnd);
			sig = VOsc.ar(bufPointer, freq);
			wub = SinOsc.ar(clock/wubDiv, wubPhase).range(loCutoff, hiCutoff);
			RLPF.ar(sig, wub, q);
		},
		adsrFunc,
		nPanFunc,
		outFunc
	],
	ringDrum: [
		{|bounce=1, freq=440, clock=1, res=1|
			Ringz.ar(Impulse.ar(clock * bounce), freq, bounce.reciprocal * res)
		},
		adsrFunc,
		nPanFunc,
		outFunc
	],
	// need to change the 'dec' arg here doesn't seem to work
	pluck: [
		{|freq=440, pAmt=1, pTime=0.1, dec=1, timbre=0.5|
			var pEnv, startP, endP, sig;
			startP = (freq + (freq * pAmt)).reciprocal;
			endP = freq.reciprocal;
			pEnv = Line.ar(startP, endP, pTime);
			sig = Pluck.ar(WhiteNoise.ar(), 1, min(startP, endP), pEnv, dec, timbre);
			DetectSilence.ar(sig, doneAction: 2);
			sig;
		},
		nPanFunc,
		outFunc
	],
	wub2: [
		{|freq=440, clock=1, wubDiv=2, wubAmt=1, wubPhase=1, pan=0|
			var sig;
			sig = SinOscFB.ar(freq, SinOsc.ar(clock/wubDiv, [0, wubPhase]).range(0, wubAmt));
			Balance2.ar(sig[0], sig[1], pan);
		},
		adsrFunc,
		outFunc
	],
	sinDrop: [
		{|freq=440, fb=0.1, dropDur=1, dropAmt=0.1|
			SinOscFB.ar(Line.ar(freq, freq * dropAmt, dropDur), fb);
		},
		percFunc,
		nPanFunc,
		outFunc
	]

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