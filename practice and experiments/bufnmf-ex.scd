s.boot;
s.options.numInputBusChannels_(0)

// load the drum loop
~drums = Buffer.read(s, FluidFilesPath("Nicol-LoopE-M.wav"));

currentEnvironment.pop

// take a listen
~drums.play;

// prepare some buffers
(
~resynth = Buffer(s);
~bases = Buffer(s);
~activations = Buffer(s);
~nComponents = 3;
)

// process using FluidBufNMF
FluidBufNMF.processBlocking(s, ~drums, resynth:~resynth, resynthMode: 1, bases:~bases, activations:~activations, components:~nComponents, action:{"done!".postln;});


~layers = Array.fill(~nComponents, {Buffer.alloc(s, ~drums.numFrames)})
// hear the resynth
(
Routine{
	~nComponents.do{
		arg i;
		"now playing component: %".format(i+1).postln;
		{
			var sig, line;
			line = Line.ar(0, BufFrames.kr(~resynth), BufDur.kr(~resynth), doneAction: 2);
			sig = BufRd.ar(~nComponents, ~resynth, line, 0)[i];
			BufWr.ar(sig, ~layers[i], line);

			sig.dup;
		}.play;
		~resynth.duration.wait;
		1.wait;
	};
}.play;
)
~layers[2].play

({
	var sig, bands, comp, bufrate, pan;
	bufrate = BufDur.kr(~layers[0]).reciprocal;
	pan = LFNoise1.kr(0.5);
	sig = ~layers.collect {|layer|
		var trate, playHead, straightplay;
		straightplay = Sweep.kr(rate: bufrate);
		trate = LFNoise2.kr(bufrate * 16).range(8, 32);
		// playHead = Select.kr(LFNoise0.kr(bufrate * 8).bi2uni > 0.25, [LFNoise1.kr(bufrate/2).range(0, 1), straightplay]);
		// GrainBuf.ar(2, Impulse.ar(trate), trate.reciprocal * 2, layer, 1, playHead, pan: pan + LFNoise1.ar(1, LFNoise1.kr(1).bi2uni));
		Select.ar(LFNoise0.kr(bufrate * 8).bi2uni > 0.5, [
			GrainBuf.ar(2, Impulse.ar(trate), trate.reciprocal * 2, layer, 1, LFNoise1.kr(bufrate/2).range(0, 1), pan: pan + LFNoise1.ar(1, LFNoise1.kr(1).bi2uni)),
			PlayBuf.ar(1, layer, 1, loop: 1)!2
		])
	}.sum;

	sig = FreeVerb.ar(sig, 0.3, 0.1, 1);
	bands = 10;
	bands = bands.collect {|i|
		switch(i,
			{0}, {BLowPass.ar(sig, i.linexp(0, bands - 1, 40, 11000))},
			{bands - 1}, {BHiPass.ar(sig, i.linexp(0, bands -1, 40, 11000))},
			{BHiPass4.ar(BLowPass4.ar(sig, (i + 1).linexp(0, bands - 1, 40, 11000), 0.5), i.linexp(0, bands - 1, 40, 11000))});
		};
	comp = CompanderD.ar(bands, 0.5, 0.1, 0.1, 0.3, 0.3).sum.distort;
	Out.ar(0, comp);
}.play)
s.scope
({
	var sig = PlayBuf.ar(~nComponents, ~resynth, BufRateScale.kr(~resynth));
	Splay.ar(sig);
}.play)


// see the bases and activations
~bases.plot;
~activations.plot;