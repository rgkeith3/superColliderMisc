s.boot

b = Buffer.alloc(s, s.sampleRate);
ProxySpace.push(s);
StageLimiter.activate;

(SynthDef(\rainmaker, { |offset=(Array.fill(16, {|i| i/16})), tapPitch=(Array.fill(16, {1.25})), grainSize=(Array.fill(16, {0.1})), grainQty=(Array.fill(16, {4})), filterType=(Array.fill(16, {1})), filterCutoff=(Array.fill(16, {440})), filterQ=(Array.fill(16, {0.5})), tapPan=(Array.fill(16, {rand(2.0) - 1}))|
	var in, rechead, playhead, sig;
	in = SoundIn.ar();

	rechead = Phasor.ar(0, BufRateScale.kr(b.bufnum), 0, BufFrames.kr(b.bufnum));



	BufWr.ar(in, b, rechead);

		playhead = Wrap.ar(rechead - (BufSampleRate.kr(b.bufnum) * offset), 0, BufFrames.kr(b.bufnum));
		Pan2.ar(BMoog.ar(Warp1.ar(1, b, playhead/BufFrames.kr(b.bufnum), tapPitch, grainSize, overlaps: grainQty), filterCutoff, filterQ, filterType), tapPan);
	};

	Out.ar(0, sig);
}).load)

// doing args with arrays seems weird, I think what I would do is
// do buffer recording in one synth
// and have each tap be it's own synth

~in = {SoundIn.ar()}
~fb = {K2A.ar()}

(~rec = {|fbAmt=0|
	var rechead;

	rechead = Phasor.ar(0, BufRateScale.kr(b.bufnum), 0, BufFrames.kr(b.bufnum));

	BufWr.ar(~in.ar + (~fb.ar * fbAmt), b, rechead);

	rechead;
})
~rec.set(\fbAmt,1)

~in = {SoundIn.ar()}
~in.scope
~fb = ~tap_0

(16.do {|i|
	var key = ("tap_" ++ i.asString).asSymbol;

	currentEnvironment[("tap_" ++ i.asString).asSymbol] = {
		|offset=0.1, tapPitch=1, grainSize=0.1, grainQty=4, filterType=0, filterCutoff=440, filterQ=0.5, tapPan=0, tapVol=1|
		var playhead, sig;
		playhead = Wrap.ar(~rec.ar - (BufSampleRate.kr(b.bufnum) * offset), 0, BufFrames.kr(b.bufnum));
		sig = Warp1.ar(1, b, playhead/BufFrames.kr(b.bufnum), tapPitch, grainSize, overlaps: grainQty);
		sig = BMoog.ar(sig, filterCutoff, filterQ, filterType);
		Pan2.ar(sig, tapPan, tapVol);
	};
})

~rec.stop
~rec.set(\fb, ~tap_16)

~rec.set(\fbAmt, 1)

16.do{|i| var key = ("tap_" ++ i.asString).asSymbol; currentEnvironment[key].play}
16.do{|i| var key = ("tap_" ++ i.asString).asSymbol; currentEnvironment[key].set(\offset, rand(1.0))}
16.do{|i| var key = ("tap_" ++ i.asString).asSymbol; currentEnvironment[key].set(\filterType, rand(3))}
16.do{|i| var key = ("tap_" ++ i.asString).asSymbol; currentEnvironment[key].set(\filterQ, 0.99)}
16.do{|i| var key = ("tap_" ++ i.asString).asSymbol; currentEnvironment[key].set(\filterCutoff, rand(5000))}
16.do{|i| var key = ("tap_" ++ i.asString).asSymbol; currentEnvironment[key].set(\tapPan, rand(2.0) - 1)}
16.do{|i| var key = ("tap_" ++ i.asString).asSymbol; currentEnvironment[key].set(\tapPitch, rand(2.0))}
16.do{|i| var key = ("tap_" ++ i.asString).asSymbol; currentEnvironment[key].set(\tapVol, rand(1.0))}
rand(2.0)
rand(3)
StageLimiter.activate