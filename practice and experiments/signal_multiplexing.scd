ProxySpace.push(s.boot)

// encoding data in 150hz sine

// 4 discreet phases can encode 4 different values
// 00, 01, 10, 11
({
	SinOsc.ar(
		150,
		phase: [Select.ar(LFNoise0.ar(150).range(0, 4), K2A.ar([0, pi/2, pi, 3pi/2])), 0],
		mul: 1
)}.scope
)


// 2 discreet amplitudes can encode 2 values
({
	SinOsc.ar(
		150,
		phase: 0,
		mul: [Select.ar(LFNoise0.ar(150).range(0, 2), K2A.ar([0.5, 1])), 1],
)}.scope
)

// 2 discreet amplitudes and 4 discreet phases can encode 8 values
// 000, 001, 010, 011, 100, 101, 110, 111
({
	SinOsc.ar(
		150,
		phase: [Select.ar(LFNoise0.ar(150).range(0, 4), K2A.ar([0, pi/2, pi, 3pi/2])), 0],
		mul: [Select.ar(LFNoise0.ar(150).range(0, 2), K2A.ar([0.5, 1])), 1],
)}.scope
)
// 2 discreet freqs, 2 discreet amplitudes, and 4 discreet phases can encode 16 values
// 0000, 0001, 0010, 0011, 0100, 0101, 0110, 0111, 1000, 1001, 1010, 1011, 1100, 1101, 1110, 1111
({
	SinOsc.ar(
		freq: [Select.ar(LFNoise0.ar(150).range(0, 2), K2A.ar([150, 300])), 150],
		phase: [Select.ar(LFNoise0.ar(150).range(0, 4), K2A.ar([0, pi/2, pi, 3pi/2])), 0],
		mul: [Select.ar(LFNoise0.ar(150).range(0, 2), K2A.ar([0.5, 1])), 1],
)}.scope
)

// 2 discreet amps, 4 discreet phases, 8 discreet freqs = 64 values or 6bits
// 000000
({
	SinOsc.ar(
		freq: [Select.ar(LFNoise0.ar(150).range(0, 8), K2A.ar([75, 150, 300, 600, 1200, 2400, 4800, 9600])), 150],
		phase: [Select.ar(LFNoise0.ar(150).range(0, 4), K2A.ar([0, pi/2, pi, 3pi/2])), 0],
		mul: [Select.ar(LFNoise0.ar(150).range(0, 2), K2A.ar([0.5, 1])), 1],
)}.scope
)

// would be interesting to consider the possibilities of encoding using timbre
// if timbre can be decoded to phases, amps, and freqs with fft
// depending on size of fft buffer, say 64 so that it's fast
// then in each FFT window, there will be (64/2)-1 freq bins = 31
// each bin can have a phase and amp even at 2 phases and 2 amps, you have 31 * 2 * 2 or 124 values
// i think this is similar to FDM (Frequency Division Multiplexing)

