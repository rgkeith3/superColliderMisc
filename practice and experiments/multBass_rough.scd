s.boot;
// this is gonna be a multichannel rumble chaos bass synth
(
SynthDef.new(\multBass, {
	arg root=440, chaos=0, chaos_spread=0;
	var channelArray = Array.new(2);
	2.do({
		var mix = Mix.ar([
			SawDPW.ar(root + LFNoise1.ar(chaos, chaos_spread), mul: 0.3),
			SawDPW.ar(root + LFNoise1.ar(chaos, chaos_spread), iphase: 0.3, mul: 0.3),
			SawDPW.ar(root + LFNoise1.ar(chaos, chaos_spread), iphase: 0.6, mul: 0.3),
		]);
		channelArray.add(mix);
	});
	Out.ar(0, channelArray);
}).add
)

x = Synth(\multBass);
x.set(\root, 50);
x.set(\chaos_spread, 100);
x.set(\chaos, 0.3);

({
	SawDPW.ar(
		440 + LFNoise1.ar(MouseX.kr(maxval: 10), MouseY.kr(maxval: 100))
)
}.play)