s.boot

s.options.numBuffers = 2.pow(14);
s.options.memSize = 2.pow(20);

{({SinOsc.ar(4444.4.rand, 0, 0.005)}!500).sum}.play
{[SinOsc.ar(440), SinOsc.ar(440), SinOsc.ar(440)+SinOsc.ar(440)]}.plot
{a = SinOsc.ar(440, 0, 0.5); [a, a, a+a]}.plot
{[SinOsc.ar(440), SinOsc.ar(220), SinOsc.ar(440)+SinOsc.ar(220)]}.plot
{[SinOsc.ar(440), SinOsc.ar(440, pi), SinOsc.ar(440)+SinOsc.ar(440, pi)]}.plot
{SinOsc.ar(440, 0, 10).clip(-0.75, 0.75)}.scope
{Saw.ar(880)}.freqscope
{Blip.ar(50, LFNoise0.ar(165/60*2).range(1, 20), 2).cubed.distort}.scope // using the Mouse
{Blip.ar(440, MouseX.kr(1, 20))}.freqscope
{Blip.ar(Blip.ar(MouseY.kr(0, 500), MouseX.kr(0, 20)).range(0, 1000), MouseX.kr(0, 20))}.scope
{Blip.ar(440, Line.kr(1, 22, 3) )}.play

Array.fill(5, {arg i; i.postln;});
{arg i; i.postln;}.dup(5)
Array.fill(5, {arg i; i.postln;}).sum;

{Saw.ar(MouseX.kr(100, 1000))}.freqscope
{LFSaw.ar(MouseX.kr(100, 1000))}.freqscope

(
f = {
        ({arg i;
                var j = i + 1;
                SinOsc.ar(300 * j, 0,  j.reciprocal * 0.5);
        } ! 30).sum // we sum this function 30 times
!2}; // and we make it a stereo signal
)

(
f = {
        Array.fill(30, {arg i;
                var j = i + 1;
                SinOsc.ar(300 * j, pi,  j.reciprocal * 0.5) // note pi
        }).sum // we sum this function 30 times
!2}; // and we make it a stereo signal
)

(
f = {
        ({arg i;
                var j = i * 2 + 1; // the odd harmonics (1,3,5,7,etc)
                SinOsc.ar(300 * j, 0, 1/j)
        } ! 20).sum;
};
)

f.plot; // let's plot the wave form
f.play; // listen to it
f.freqscope; // view and listen to it

{ Pulse.ar(440, MouseX.kr(0, 1), 0.5) }.scope;
{ if( SinOsc.ar(122)>0 , 1, -1 )  }.scope;
{ if( SinOsc.ar(122)>LFNoise0.kr(140/60 * 4) , 1, -1 ) * LFNoise0.kr(140/60 * 4).range(0, 1)  }.scope;

SynthDef(\triwave, {arg freq=400, pan=0, amp=1;
    var wave;
    wave = ({arg i;
                    var j = i * 2 + 1;
                    SinOsc.ar(freq * j, pi/2, 0.6 / j.squared);
            } ! 20).sum;
    Out.ar(0, Pan2.ar(wave * amp, pan));
}).add;

a = Synth(\triwave, [\freq, 300]);
a.set(\amp, 0.3, \pan, -1);
b = Synth(\triwave, [\freq, 900]);
b.set(\amp, 0.4, \pan, 1);
s.freqscope; // if the freqscope is not already running
b.set(\freq, 1400); // not band limited as we can see

(
f = {
        ({arg i;
                var j = i * 2.cubed + 1;
                SinOsc.ar(MouseX.kr(20,800) * j, 0, 1/j)
        } ! 20).sum;
};
)
f.plot;
f.play;
s.scope

(
f = {
        ({arg i;
                var j = i * 2.squared.distort + 1;
                SinOsc.ar(MouseX.kr(20,800) * j, 0, 0.31/j)
        } ! 20).sum;
};
)
f.plot;
f.play;

{ ({ SinOsc.ar(LFNoise0.ar(140/60).range(80, 800), 0, 0.1)} ! 15).sum }.scope

{
Mix.fill( 10, {
    SinOsc.ar(rrand(200, 700), 0, 0.1)
    * EnvGen.ar(Env.perc(0.0001, rrand(2, 6)))
});
}.play


{
var freq = [333, 412, 477, 567, 676, 890, 900, 994];
var dur = [4, 3.5, 3.6, 3.1, 2, 1.4, 2.4, 4.1];
var amp = [0.4, 0.2, 0.1, 0.4, 0.33, 0.22, 0.13, 0.4];
Mix.fill( 8, { arg i;
    SinOsc.ar(freq[i], 0, 0.1)
    * EnvGen.ar(Env.perc(0.0001, dur[i]))
});
}.play


(
SynthDef(\mybell, {arg freq=333, amp=0.4, dur=2, pan=0.0;
    var signal;
    signal = Mix.fill(10, {
        SinOsc.ar(freq+(430.rand), 1.0.rand, 10.reciprocal)
        * EnvGen.ar(Env.perc(0.0001, dur), doneAction:2) }) ;
    signal = Pan2.ar(signal * amp, pan);
    Out.ar(0, signal);
}).add
)

// let's try our bell
Synth(\mybell) // same sound all the time
Synth(\mybell, [\freq, 444+(400.rand)]) // new frequency, but same sound
// try to redefine the SynthDef above and you will now get a different bell:
Synth(\mybell) // same sound all the time

(
SynthDef(\sine, {arg freq=333, amp=0.4, dur, pan=0.0;
    var signal, env;
    env = EnvGen.ar(Env.perc(0.01, dur), doneAction:2);
    signal = SinOsc.ar(freq, 0, amp) * env;
    signal = Pan2.ar(signal, pan);
    Out.ar(0, signal);
}).add
)

(
var numberOfSynths;
numberOfSynths = 15;
Array.fill(numberOfSynths, {
    Synth(\sine, [
        \freq, 300+(430.rand),
        \phase, 1.0.rand,
        \amp, numberOfSynths.reciprocal, // reciprocal here means 1/numberOfSynths
        \dur, 2+(1.0.rand)]);
});
)

{Klang.ar(`[ [430, 810, 1050, 1220], [0.23, 0.13, 0.23, 0.13], [pi,pi,pi, pi]], 1, 0)}.play


{ ({ SinOsc.ar(rrand(180, 1200), 0.5*pi, 0.1) // the partial
        *
    // each partial gets its own envelope of 0.5 to 5 seconds
    EnvGen.ar(Env.perc(rrand(0.00001, 0.01), rrand(0.5, 5)))
} ! 12).sum }.play


(
SynthDef(\stBell, {|freq=440, harmSpread=1, rel=3, panSpread=1, panSpeed=1, out=0|
	var fund;
	fund = Pan2.ar(SinOsc.ar(freq, mul: 0.1) * EnvGen.ar(Env.perc(releaseTime: rel), 1, doneAction: 2), LFNoise1.kr(panSpeed, panSpread));
	11.do {
		fund = fund + Pan2.ar(SinOsc.ar(Rand(freq, (harmSpread * 40 * freq) + freq), mul: 0.1) * EnvGen.ar(Env.perc(releaseTime: Rand(0.01, rel)), 1), LFNoise1.kr(panSpeed, panSpread));
	};
	Out.ar(out, fund);
}).load
)

ProxySpace.push(s)

~a = Pbind(\instrument, \stBell, \degree, [0,2,4,6], \dur, 1/2, \octave, 5, \harmSpread, 0, \rel, 5, \panSpread, 1, \panSpeed, 4, \scale, Scale.major.tuning_(\pythagorean))
~a[10] = \filter -> {|in| FreeVerb.ar(in, room: 0.5, damp: 1)}

~a.play
Scale.directory
Tuning.directory
Tuning.pythagorean.ratios.size

{ Crackle.ar(XLine.kr(0.99, 2, 10), 0.4) }.freqscope.scope;
{ LFDNoise0.ar(XLine.kr(1000, 20000, 10), 0.1) }.freqscope.scope;
{ LFClipNoise.ar(XLine.kr(1000, 20000, 10), 0.1) }.freqscope.scope;
{ Impulse.ar(80, 0.7) }.play
{ Dust.ar(80) }.play


{BPF.ar(WhiteNoise.ar(0.4), MouseX.kr(100, 10000).poll(20, "cutoff"), MouseY.kr(0.01, 0.9999).poll(20, "rQ"))}.freqscope

{ Resonz.ar(WhiteNoise.ar(0.5), MouseX.kr(40,20000,1), 0.1)!2 }.play
{ Ringz.ar(Dust.ar(2, 0.6), MouseX.kr(200,6000,1), 2) }.play
{ Formlet.ar(Impulse.ar(4, 0.9), MouseX.kr(300,2000), 0, 1) }.play;
{MoogFF.ar(Saw.ar(440), MouseX.kr(400, 16000), MouseY.kr(0.01, 4))}.freqscope


{
    var modulator, carrier;
	  // unipolar modulator = AM = carrier + sidebands
	  modulator = SinOsc.ar(MouseX.kr(2, 20000, 1)).range(0,1);
    carrier = SinOsc.ar(MouseY.kr(200,2000), 0, modulator);
    carrier!2 // the output
}.play

{
    var modulator, carrier;
	  // bipolar modulator = RM = sidebands (no carrier)
	  modulator = SinOsc.ar(MouseX.kr(2, 20000, 1));
    carrier = SinOsc.ar(MouseY.kr(200,2000), 0, modulator);
    carrier!2 // the output
}.play

{SinOsc.ar(1400 + SinOsc.ar(MouseX.kr(2,2000,1), 0, MouseY.kr(1,1000)), 0, 0.5)!2}.freqscope

{ PMOsc.ar(MouseX.kr(500,2000), 600, 3, 0, 0.1) }.play; // modulate carfreq
{ PMOsc.ar(2000, MouseX.kr(200,1500), 3, 0, 0.1) }.play; // modulate modfreq
{ PMOsc.ar(2000, 500, MouseX.kr(0,10), 0, 0.1) }.play; // modulate index

{SinOsc.ar( Stepper.kr(Impulse.kr(10), 0, 4, 16, 1) * 100, 0, 0.2)}.play;

(
SynthDef(\drummer, { arg out=0, tempo=4;
    var snare, base, hihat;
    tempo = Impulse.ar(tempo); // for a drunk drummer replace Impulse with Dust !!!

    snare =     WhiteNoise.ar(Decay2.ar(PulseDivider.ar(tempo, 4, 2), 0.005, 0.5));
    base =     SinOsc.ar(Line.ar(120,60, 1), 0, Decay2.ar(PulseDivider.ar(tempo, 4, 0), 0.005, 0.5));
    hihat =     HPF.ar(WhiteNoise.ar(1), 10000) * Decay2.ar(tempo, 0.005, 0.5);

    Out.ar(out,(snare + base + hihat) * 0.4!2)
}).add;
)

a = Synth(\drummer);
a.set(\tempo, 6);
a.set(\tempo, 18);
a.set(\tempo, 180); // check the CPU! no increase.

t = TempoClock(2); // tempo is 2 beats per second (120 bpm);
t.schedAbs(t.beats.ceil, { arg beat, sec; [beat, sec].postln; 1});
t.schedAbs(t.beats.ceil, { arg beat, sec; "ho ho --".post; [beat, sec].postln; 1 });
t.beats.ceil

~notes = List[63, 61, 64, 65];

Pbind(
    \midinote, Pseq(~notes, inf),
    \dur, Pseq([0.4, 0.2, 0.1, 0.2], inf)
).play;

~notes[1] = 80

(
Pbind(
     \midinote, Pseq([72, 76, 79, 71, 72, 74, 72, 81, 79, 84, 79, 77, 76, 77, 76], 1),
     \dur, Pseq([4, 2, 2, 3, 0.5, 0.5, 4, 4, 2, 2, 2, 1, 0.5, 0.5, 2]/4, 1)
 ).play
)

SynthDef(\sin, {|freq, rel, amp, out| Out.ar(out, SinOsc.ar(freq) * EnvGen.ar(Env.perc(releaseTime: rel), 1, amp, doneAction: 2))}).add

Scale.directory
~a = Pbind(\instrument, \sin, \degree, Pseq([0,1,2,3,4,5,6,7], inf), \scale, Scale.locrian.tuning_(\just), \rel, 3, \dur, 1/2)
~a.play

