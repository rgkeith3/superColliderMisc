// stereo live-coding setup
(

s.options.numBuffers = 2.pow(14);

s.options.memSize = 2.pow(20);

s.options.outDevice_("JackRouter");
s.options.inDevice_("JackRouter");

// s.options.outDevice_("UMC404HD 192k");
// s.options.inDevice_("UMC404HD 192k");
n = 2;
s.options.numOutputBusChannels_(n);
s.options.numInputBusChannels_(n);

a = currentEnvironment;
// f = () funcs
// l = () lfos
// w = [] wavetables
// e = [] envBufs
// d = (s: samples, ss: stereo samples)
// better organize sample library
// need to use snippets

// put helper functions here
f = (
	// fills an array of \dur values that will sum to a given length
	durFill: {
		|numBeats = 8, minDiv=0.25, density=0.5|
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

	// fills an array of certain size, with values
	valFill: {
		|size=8, degrees=#[1], diff=0.5|
		var vals = Array.fill(size, {degrees[0]});
		vals = vals.collect {|val|
			if (diff.coin) {
				degrees.choose;
			} { val }
		};
		vals.postln;
		vals;
	},

	durFillSize: {
		|numBeats = 8, minDiv=0.0625, density=0.5, arrSize=8|
		var vals = Array.fill(arrSize, {minDiv});
		while({vals.sum < numBeats}, {
			var nextNum, randAmt;
			randAmt = rand(density.reciprocal.asInt) + 1;
			nextNum = randAmt * minDiv;

			if (vals.sum + nextNum > numBeats, {
				var index = rand(vals.size -1);
				vals.put(index, vals[index] + (numBeats - vals.sum));
			}, {
				var index = rand(vals.size -1);
				vals.put(index, vals[index] + nextNum);
			});
		});
		vals.postln;
		vals;
	},

	// effects nodes

	stDelay: {
		|in, divL=4, divR=4, decL=1, decR=1|
		var time = p.clock.tempo.reciprocal;
		[CombN.ar(in[0], time, time / divL, decL), CombN.ar(in[1], time, time/ divR, decR)];
	}
);

// helper lfo functions ex. { l[\sin].value(clock, 4, 100, 1000)}
l = (
	sin: {
		|clock=1, div=1, lo=(-1), hi=1|
		SinOsc.kr(clock * div).range(lo, hi);
	},

	saw: {|clock=1, div=1, lo=(-1), hi=1|
		SawDPW.kr(clock  * div).range(lo, hi);
	},

	ramp: {|clock=1, div=1, lo=(-1), hi=1|
		SawDPW.kr(clock * div).range(lo, hi);
	},

	square: {|clock=1, div=1, lo=(-1), hi=1width=0.5|
		PulseDPW.kr(clock * div, width).range(lo, hi);
	},

	tri: {|clock=1, div=1, lo=(-1), hi=1|
		LFTri.kr(clock * div).range(lo, hi);
	},

	sh0: {|clock=1, div=1, lo=(-1), hi=1|
		LFNoise0.kr(clock * div).range(lo, hi);
	},

	sh1: {|clock=1, div=1, lo=(-1), hi=1|
		LFNoise1.kr(clock*div).range(lo, hi);
	},

	sh2: {|clock=1, div=1, lo=(-1), hi=1|
		LFNoise2.kr(clock*div).range(lo, hi);
	}
);
// to store samples in. will be used later.
d = ();

// setupFuncs
~setupFuncs = (
	loadBufs: { |folderName, numChannels =1|
		var sampleFolder, recurseFolder, readFiles;
		d.put(folderName, ());

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
			recurseFolder.value(entry, d[folderName])
		});
	},

	makeWaveTables: {
		w = Buffer.allocConsecutive(48, s, 1024).collect({|b, i|
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
		e = (
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

		e.keysValuesChange({|key, envTimes|
			makeEnvBuf.value(envTimes);
		});
	},

	loadSynthDefs: {
		("SynthDefs.scd").loadRelative;
	},

	createEvents: {
		("Events.scd").loadRelative;
	}
);

s.waitForBoot {
	a[\setupFuncs][\makeWaveTables].value;
	s.sync;
	a[\setupFuncs][\makeEnvBufs].value;
	s.sync;
	"booted".postln;
};

Task({
	3.wait;
	a[\setupFuncs][\loadSynthDefs].value;
	a[\setupFuncs][\loadBufs].value(\samples);
	a[\setupFuncs][\loadBufs].value(\stereo_samples, 2)
}).start;

StageLimiter.activate;
p = ProxySpace.push(s);

p.makeTempoClock;
p.clock.tempo = 2;
p.quant = 4;
)