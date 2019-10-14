s.boot


// cool vocal spreader
// Mouse y is doing pitch spreading which could be combined with auto-tune below
// mouse x is doing spreading around time kind of like a choru
(
{
	var sig = SoundIn.ar;

	Out.ar(~bus[\reverb][0].index, [
		PitchShift.ar(sig, 0.5, 0.5, timeDispersion: 2),
		PitchShift.ar(sig, 0.5, 2, timeDispersion: 2),
		PitchShift.ar(sig, 0.5, 1, timeDispersion: 1),
		sig
	]);
}.play
)

(
{
	var sig, freq, has_freq, correct_sig;
	sig = SoundIn.ar;

	#freq, has_freq = Tartini.kr(sig);

	correct_sig = PitchShift.ar(sig, pitchRatio: freq.cpsmidi.round.midicps / freq);

	correct_sig!2
}.play
)

152.cpsmidi.round.midicps / 152

(
SynthDef.new(\vocal, {
	arg in=0,
	out=0,
	note_1=60,
	note_2=64,
	note_3=67,
	note_4=71,
	time_spread=0;
	var sig, in_freq, has_freq, correct_sig;

	sig = SoundIn.ar(in);

	#in_freq, has_freq = Tartini.kr(sig);
	correct_sig = [
		PitchShift.ar(sig, 1, pitchRatio: note_1.midicps / in_freq, timeDispersion: time_spread),
		PitchShift.ar(sig, 1, pitchRatio: note_2.midicps / in_freq, timeDispersion: time_spread),
		PitchShift.ar(sig, 1, pitchRatio: note_3.midicps / in_freq, timeDispersion: time_spread),
		PitchShift.ar(sig, 1, pitchRatio: note_4.midicps / in_freq, timeDispersion: time_spread)
	];
	Out.ar(out, correct_sig * has_freq.round)
}).add
)

(
SynthDef.new(\vocal, {
	arg in=0,
	out=0,
	time_spread=0;
	var sig, in_freq, has_freq, correct_sig;

	sig = SoundIn.ar(in);

	#in_freq, has_freq = Tartini.kr(sig);
	correct_sig = [
		PitchShift.ar(sig, 1, pitchRatio: 2, timeDispersion: time_spread),
		PitchShift.ar(sig, 1, pitchRatio: 0.5, timeDispersion: time_spread),
		PitchShift.ar(sig, 1, pitchRatio: 1.5, timeDispersion: time_spread),
		PitchShift.ar(sig, 1, pitchRatio: 0.75, timeDispersion: time_spread)
	];
	Out.ar(out, correct_sig * has_freq.round)
}).add
)


x = Synth(\vocal, [\out, ~bus[\reverb][0].index, \time_spread, 0.5]);
x.set(\time_spread, 0)
x.free;
(
Pdef(\vocal,
	Pbind(
		\type, \set,
		\id, x.nodeID,
		\args, [\note_1, \note_2, \note_3, \note_4, \time_spread],
		\dur, 4,
		\note_1, Pseq([0,2,0,0] + 48, inf),
		\note_2, Pseq([5,4,4,4] + 48, inf),
		\note_3, Pseq([9,7,7,9] + 48, inf),
		\note_4, Pseq([17,11,16,16] + 48, inf),
		\time_spread, 0.5
	)
).play
)

Scale.major.degrees + 1


77.midicps
