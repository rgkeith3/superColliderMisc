s.boot;
// gonna store functions here in this env
// some more util funcs
// maybe some funcs for setting up reverbs and delays? idk could be pretty easy in proxyspace
// also create my special events
// and special synthdefs (like slice)

//so from proxyspace i can refer to e[\funcs] or e[\envBufs], e[\samples], e[\wavetables]
(
// Envelopes
~ampEnvs = (
	adsr: {|in, atk=0.01, dec=0.1, sus=0.8, rel=0.1, gate=1, amp=0.8|
		in * EnvGen.ar(Env.adsr(atk, dec, sus, rel), gate, doneAction: 2);
	},

	perc: {|in, atk=0.01, rel=0.1, curve=(-4), amp=0.1|
		in * EnvGen.ar(Env.perc(atk, rel, curve: curve), doneAction: 2);
	};
);

~otherEnvs = (
	pitchEnv: {|freq=440, pitchAtk = 0, pitchDec=0.1, pitchEnvAmt=0, pitchCurve=(-4)|
		EnvGen.ar(Env.perc(pitchAtk, pitchDec, curve: pitchCurve), levelScale: pitchEnvAmt, levelBias: freq);
	},

	line: {|lineDur=1, start=0, end=1|
		Line.ar(start, end, lineDur)
	};
);

// panning functions
~pans = (
	ster: {|in, panX=0|
		Pan2.ar(in, panX);
	},
	quad: {|in, panX=0, panY=0|
		Pan4.ar(in, panX, panY);
	},
	quadAz: {|in, panX=0, panY=1|
		PanAz.ar(4, in, panX, width: panY);
	},
);

// buffer players
~bufPlayers = (
	oneShot: {|buf, rate=1|
		PlayBuf.ar(1, buf, rate, doneAction: 2);
	},

	loop: {|buf, rate=1|
		PlayBuf.ar(1, buf, rate, loop: 1);
	},

	stretch: {|buf, clock=1, beatStretch=4, pitchRatio=1, windowSize=0.2, envBuf=(-1), overlaps=8|
		var rate = clock / beatStretch;
		var pointer = Sweep.ar(1, rate);
		Warp1.ar(1, buf, pointer, pitchRatio, windowSize, envBuf, overlaps);
	},

	warp: {|buf, pointer=0.5, pitchRatio=1, windowSize=0.2, envBuf=(-1), overlaps=8, windRand=0|
		Warp1.ar(1, buf, pointer, pitchRatio, windowSize, envBuf, overlaps, windRand);
	},
);

~grainPlayers = (
	grain: {|numChannels=2, buf, pointer=0.5, trig=1, grainSize=0.1, grainSpeed=1, panX=0, envBuf=(-1)|
		GrainBuf.ar(numChannels, trig, grainSize, buf, grainSpeed, pointer, pan: panX, envbufnum: envBuf)
	}
);

// Synths
~synths = (
	saw: {|freq=440|
		SawDPW.ar(freq);
	},

	tri: {|freq=440|
		LFTri.ar(freq);
	},

	square: {|freq=440, width=0.5|
		PulseDPW.ar(freq, width);
	},

	impulse: {|freq=440|
		Impulse.ar(freq);
	},

	gendy3: {|freq=440|
		Gendy3.ar(freq: freq);
	},

	gendy5: {|freq=440, chaos=0|
		var minFreq, maxFreq;
		minFreq = freq - (freq * chaos);
		maxFreq = freq + (freq * chaos);
		Gendy5.ar(minfreq: minFreq, maxfreq: maxFreq);
	},

	quadNoise: {|freq=440|
		QuadN.ar(freq);
	},

	vosc3: {|freq=440, bufPos, pitchRatio=1|
		VOsc3.ar(bufPos, freq, freq * pitchRatio, freq * pitchRatio * pitchRatio);
	},

	vosc: {|freq=440, bufPos|
		VOsc.ar(bufPos, freq);
	}
);

~physicalModels = (
	pluck: {|freq=440, rel=1, timbre=1|
		var sig;
		sig = Pluck.ar(WhiteNoise.ar(), maxdelaytime: freq.reciprocal, delaytime: freq.reciprocal, decaytime: rel, coef: timbre);
		DetectSilence.ar(sig, doneAction: 2);
		sig;
	}
);


~filters = (
	rlpf: {|in, filtFreq=440, q=1|
		RLPF.ar(in, filtFreq, q);
	},

	rhpf: {|in, filtFreq=440, q=1|
		RHPF.ar(in, filtFreq, q);
	},

	bpf: {|in, filtFreq=440, q=1|
		BPF.ar(in, filtFreq, q);
	},

	ringz: {|in, filtFreq=440, q=1|
		Ringz.ar(in, filtFreq, q.reciprocal);
	}
);

~lfos = (
	sin: {
		|clock=1, div=1, depth=1, offset=0|
		SinOsc.kr(clock * div, mul: depth, add: offset);
	},

	saw: {|clock=1, div=1, depth=1, offset=0|
		SawDPW.kr(clock  * div, mul: depth * -1 * 2, add: offset);
	},

	ramp: {|clock=1, div=1, depth=1, offset=0|
		SawDPW.kr(clock * div, mul: depth * 2, add: offset);
	},

	square: {|clock=1, div=1, depth=1, offset=0, width=0.5|
		PulseDPW.kr(clock * div, width, depth * 2, offset);
	},

	tri: {|clock=1, div=1, depth=1, offset=0|
		LFTri.kr(clock * div, mul: depth, add: offset);
	},

	sh0: {|clock=1, div=1, depth=1, offset=0|
		LFNoise0.kr(clock * div, depth, offset);
	},

	sh1: {|clock=1, div=1, depth=1, offset=0|
		LFNoise1.kr(clock*div, depth, offset);
	},

	sh2: {|clock=1, div=1, depth=1, offset=0|
		LFNoise2.kr(clock*div, depth, offset);
	}
);

~noise = (
	white: {|noiseLvl=1| WhiteNoise.ar(noiseLvl)},
	brown: {|noiseLvl=1| BrownNoise.ar(noiseLvl)},
	pink: {|noiseLvl=1| PinkNoise.ar(noiseLvl)},
	crackle: {|noiseLvl=1, noiseChaos=1| Crackle.ar(noiseChaos, noiseLvl)},
	dust: {|noiseLvl=1, noiseFreq=50| Dust.ar(noiseFreq, noiseLvl)},
	gauss: {|noiseLvl=1, noiseFreq=50, noiseChaos=1| GaussTrig.ar(noiseFreq, noiseChaos, noiseLvl) }
);

//utils

// any useful function that i can come up with for live coding maybe something that takes in a scale and gives chords
~utils = (
// \degree, Prout(~shiftRegRout.value(4, Scale.major.degrees, 0.5))
	shiftReg: {
		|n=4, degrees=#[1], prob=1|
		{
			var register = Array.fill(n, {degrees.choose});
			prob = prob.asStream;
			loop {
				if (prob.value.coin) {
					register = register.shift(1, degrees.choose);
				};
				register.postln;
				register.yield;
			};
		};
	},

	turingMachine: {
		|n=4, degrees=#[1], prob=1|
		{
			var register = Array.fill(n, {degrees.choose});
			prob = prob.asStream;
			loop {
				if (prob.value.coin) {
					register = register.shift(1, degrees.choose);
				} {
					register = register.rotate(1);
				};
				register[0].yield
			};
		};
	},

	crudeDensFill: {
		|numBeats = 8, minDiv=0.0625, density=0.5|
		var vals;
		vals = [];
		while({vals.sum < numBeats}, {
			var nextNum, randAmt;
			randAmt = rand(density.reciprocal.asInt) + 1;
			nextNum = randAmt * minDiv;
			if (vals.sum + nextNum > numBeats, {
				vals = vals ++ (numBeats - vals.sum);
			}, {
				vals = vals ++ nextNum;
			});
		});
		vals = vals.reject({|i| i == 0});
		vals.size.postln;
		vals;
	},


	nodelatch: {"nodlatch".postln;},

	makeSynthDefs: {
		"making SynthDefs".postln;

		e[\synths].keysValuesDo {|synthKey, synthFunc|
			e[\filters].keysValuesDo {|filtKey, filtFunc|
				e[\ampEnvs].keysValuesDo {|envKey, envFunc|
					e[\pans].keysValuesDo {|panKey, panFunc|
						var synthDefName;
						synthDefName = panKey.asString ++ envKey.asString ++ filtKey.asString ++ synthKey.asString;
						SynthDef(synthDefName, {|out=0|
							var sig, freq;
							freq = SynthDef.wrap(e[\otherEnvs][\pitchEnv]);
							sig = SynthDef.wrap(synthFunc, prependArgs: [freq]);
							sig = SynthDef.wrap(filtFunc, prependArgs: [sig]);
							sig = SynthDef.wrap(envFunc, prependArgs: [sig]);
							sig = SynthDef.wrap(panFunc, prependArgs: [sig]);

							Out.ar(out, sig);
						}).add;
					};
				};
			};
		};

		e[\bufPlayers].keysValuesDo {|bufKey, bufFunc|
			e[\ampEnvs].keysValuesDo {|envKey, envFunc|
				e[\pans].keysValuesDo {|panKey, panFunc|
					var synthDefName;
					synthDefName = panKey.asString ++ envKey.asString ++ bufKey.asString;

					SynthDef(synthDefName, {|out=0|
						var sig;
						sig = SynthDef.wrap(bufFunc);
						sig = SynthDef.wrap(envFunc, prependArgs: [sig]);
						sig = SynthDef.wrap(panFunc, prependArgs: [sig]);

						Out.ar(out, sig);
					}).add;
				};
			};
		};

		e[\physicalModels].keysValuesDo {|modelKey, modelFunc|
			e[\pans].keysValuesDo {|panKey, panFunc|
				var synthDefName;
				synthDefName = panKey.asString ++ modelKey.asString;

				SynthDef(synthDefName, {|out=0|
					var sig;
					sig = SynthDef.wrap(modelFunc);
					sig = SynthDef.wrap(panFunc, prependArgs: [sig]);

					Out.ar(out, sig);
				}).add;
			};
		};

		e[\noise].keysValuesDo {|noiseKey, noiseFunc|
			e[\ampEnvs].keysValuesDo {|envKey, envFunc|
				e[\pans].keysValuesDo {|panKey, panFunc|
					var synthDefName;
					synthDefName = panKey.asString ++ envKey.asString ++ noiseKey.asString;

					SynthDef(synthDefName, {|out=0|
						var sig;
						sig = SynthDef.wrap(noiseFunc);
						sig = SynthDef.wrap(envFunc, prependArgs: [sig]);
						sig = SynthDef.wrap(panFunc, prependArgs: [sig]);

						Out.ar(out, sig);
					}).add;
				};
			};
		};
		"done makeing synths".postln;
	},

	makeCustomSynthDefs: {
		// get some cool custom ones
		// stereo sample looper
		SynthDef(\sterSampLooper, {
			|out=0, buf, rate=1|
			var sig = PlayBuf.ar(2, buf, rate, loop: 1);
			Out.ar(out, sig);
		}).add;

		SynthDef(\sterSampWarp, {
			|out=0, buf, pointer=0, pitchRatio=1, windowSize=0.2, envbuf=(-1), overlaps=8, chaos=0 |
			var sig = Warp1.ar(2, buf, pointer, pitchRatio, windowSize, envbuf, overlaps, chaos);
			Out.ar(out, sig);
		}).add;
	},

	loadBufs: { |folderName, numChannels =1|
		var sampleFolder, recurseFolder, readFiles;
		e[folderName] = ();

		sampleFolder = PathName.new(thisProcess.nowExecutingPath).parentPath +/+ PathName(folderName.asString);

		readFiles = {
			|files|
			var fileArray = [];
			files.do({
				|file|
				var buf = Buffer.readChannel(s, file.fullPath, channels: Array.series(numChannels));
				fileArray = fileArray ++ [buf];
			});
			fileArray;
		};

		recurseFolder = {
			|entry, dictionary|
			entry.postln;
			if (entry.folders.size > 0) {
				var folder = ();
				entry.folders.do({
					|subFolder|
					recurseFolder.value(subFolder, folder);
				});
				dictionary.put(entry.folderName.asSymbol, folder);
			} {
				dictionary.put(entry.folderName.asSymbol, readFiles.value(entry.files));
			}
		};

		sampleFolder.entries.do({ |entry|
			entry.postln;
			recurseFolder.value(entry, e[folderName])
		});
	},

	makeWaveTables: {
		e[\waveTables] = ();
		e[\waveTables][\noisey] = Buffer.allocConsecutive(48, s, 1024).collect({|b, i|
			var numSegs, env, sig, wt;
			numSegs = i+1;
			env = Env(
				{rrand(-1.0, 1.0)}!(numSegs + 1) * [-1, 1],
				{rrand(0.0, 5.0)}!numSegs,
				{rrand(-5.0, 5.0)}!numSegs
			);
			sig = env.asSignal(512);
			wt = sig.asWavetable;
			b.loadCollection(wt);
		});
	},

	makeEnvBufs: {
		var makeEnvBuf;
		e[\envBufs] = (
			perc: [[0,0,1],\cub],
			saw: [[0,0,1],\lin],
			trap: [[1,1,1],\sin],
			ramp: [[1,0,0],\lin],
			tri: [[0,1,0],\lin]
		);

		makeEnvBuf = { |times|
			var env = Env([0,1,1,0], times[0], times[1]);
			Buffer.sendCollection(s, env.discretize, 1);
		};

		e[\envBufs].keysValuesChange({|key, envTimes|
			makeEnvBuf.value(envTimes);
		});
	},

	cleanup: {
		s.newBusAllocators;
		ServerBoot.removeAll;
		ServerQuit.removeAll;
		ServerTree.removeAll;
	}
);
)
s.boot
e = currentEnvironment
e[\utils][\makeSynthDefs].value
e[\utils][\makeCustomSynthDefs].value
e[\utils][\loadBufs].value(\samples);
e[\utils][\loadBufs].value(\stereo_samples, 2);
e[\utils][\makeWaveTables].value
e[\utils][\makeEnvBufs].value
e[\waveTables]
e[\envBufs]
p = ProxySpace.push
e[\samples]
p.quant_(4)


TempoClock.default.tempo_(2)
~tempoSet = Routine({
	var tempo = TempoClock.default.tempo * 60;
	loop {
		if (tempo < 165, {
			tempo = tempo + 1;
			TempoClock.default.tempo_(tempo/60);
		});

		1.yield;
	}
})

~tempoSet.clear

TempoClock.default.tempo * 60



~kick = Pbind(\instrument, \sterperconeShot, \buf, e[\samples][\Drums][\Kicks][5], \dur, Pseq(e[\utils][\crudeDensFill].value(8, 1/4, 0.1), inf), \amp, 2)

~kick.fadeTime_(10)

~kick = Pbind(\instrument, \sterperconeShot, \buf, e[\samples][\Drums][\Kicks][2], \dur, Pstutter(Prand([0, 4], inf), Pseq([1, 3/4, 3/4, 1/2, 1], inf)))
~kick[1] = nil
~snare = Pbind(\instrument, \sterperconeShot, \buf, e[\samples][\Drums][\Snares].choose, \dur, Pseq(e[\utils][\crudeDensFill].value(16, 1, 0.1), inf), \panX, Pwhite())
~snare.play

~hat = Pbind(\instrument, \sterperconeShot, \buf, e[\samples][\Drums]['Closed Hihat'].choose, \dur, Pseq(e[\utils][\crudeDensFill].value(4, 1/4, 0.5), inf))
~lfo = {e[\lfos][\sin].value(140/60, 1/16)}
~hat.set(\panX, ~lfo)
~hat.play

~revSend = ~snare * 0.3 + ~text + (~arp * 0.5); ~bass.stop(0)

~bass = Pbind(\instrument, \steradsrrlpfsaw, \dur, Pdefn(\bassDur), \octave, 2, \degree, Pdefn(\bassDeg), \scale, Scale.minor.degrees, \filtFreq, 50, \q, 1, \legato, 0.5, \rel, 0.2, \panX, Pwhite(-1.0))
~bass[1] = {[AllpassN.ar(~bass, 0.1, LFNoise1.kr(0.4, 0.05, 0.0501), 0.1), AllpassN.ar(~bass, 0.1, LFNoise1.kr(0.4, 0.05, 0.0501), 0.1)]}
~bass.set(\filtFreq, 5000, \q, 0.1)

~bass.play

~del1 = {|div=1, dec=5| var tempo = TempoClock.default.tempo; [CombN.ar(~del1snd.ar[0], 5, tempo.reciprocal * div, dec), CombN.ar(~del1snd.ar[1], 5, tempo.reciprocal * div, dec)]}
~del1snd = ~snare * 0.5;
~del1.play
~del1.set(\dec, 5, \div, 1/2)

~bass.play

~chords.clear

~chords[1] = {[CombN.ar(~chords.ar[0], 0.01, LFNoise1.kr(0.2, 0.005, 0.0051), 0.3), CombN.ar(~chords.ar[1], 0.01, LFNoise1.kr(0.2, 0.005, 0.0051), 0.3)] + ~chords.ar}

Pdefn(\bassDeg, 1)
Pdefn(\bassDur, Pseq([8, 4, 2.5, 1.5], inf))

~arp = Pbind(\instrument, \sterpercrlpfvosc3, \octave, 7, \degree, Prout(e[\utils][\turingMachine].value(4, #[1,3,5,7], 0.2)), \bufPos, 405, \dur, Pstutter(Prand([2, 4, 6, 8], inf), Prand([1/2, 1/4, 1], inf)), \filtFreq, 10000, \q, 0.1, \panX, Pwhite(-1.0), \atk, 0.01, \rel, 0.2)
~arp.set(\pitchRatio, 1.01)
~arp.fadeTime_(5)
~arp.set(\bufPos, 405)
~arp.play

e[\waveTables][\noisey].collect{|i|i.postln;}

452 - 405 / 2

~lfo3 = {e[\lfos][\sh1].value(TempoClock.default.tempo, 1/8, 24, 429)}

~arp.play
e[\waveTables][\noisey][0].bufnum
~chords = Pbind(\instrument, \steradsrrlpfsaw, \rel, 1, \dur, 4, \degree, Prout(e[\utils][\shiftReg].value(4, Scale.minor.degrees, 1)), \octave, 6, \strum, 1)
~chords.play


~lfo2 = {e[\lfos][\sin].value(140/60, 1/16, 500, 1000)}
~bass.play

~text = \sterSampLooper

~text.play

~text.set(\buf, e[\stereo_samples][\texture].choose, \rate, 1)

~text.stop

~rev = {NHHall.ar([~revSend.ar[0], ~revSend.ar[1]])}

~rev.play(fadeTime: 10)

~pluck =
~pluck.play

~compSend = ~rev;
StageLimiter.activate
~comp = {Compander.ar(~compSend, ~kick, thresh: 0.5, slopeBelow: 0.98, slopeAbove: 0.5)}

(~comp.play; ~rev.stop(0))

~pluck = {e[\physicalModels][\pluck].value(440)}
~pluck.play
~hat.play

e.know_(true)
e.samples.know_(true)
e.samples[\Drums].keys

~snare.play
~kick.play


p.clock.tempo = 2